package baseball.states.editor {
	import baseball.art.Base;
	import baseball.art.Block;
	import baseball.art.Bomb;
	import baseball.art.Button;
	import baseball.art.Gap;
	import baseball.art.Obstacle;
	import baseball.art.RepeatingTile;
	import baseball.art.Rock;
	import baseball.art.Slider;
	import baseball.Imports;
	import baseball.states.play.GameState;
	import baseball.states.play.TestMode;
	import flash.display.BitmapData;
	import flash.system.System;
	import krakel.beat.BeatKeeper;
	import krakel.KrkSound;
	import krakel.xml.XMLParser;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.system.input.Mouse;
	
	/**
	 * ...
	 * @author George
	 */
	public class EditorState extends FlxState {
		[Embed(source = "../../../../res/sprites/bomb_overlay.png")]	static private const BOMB_BTN_EMBED:Class;
		[Embed(source = "../../../../res/sprites/base.png")]			static private const BASE_BTN_EMBED:Class;
		[Embed(source = "../../../../res/sprites/playback.png")]		static private const PLAYBACK_EMBED:Class;
		static public var BOMB_BTN:BitmapData;
		static public var BASE_BTN:BitmapData;
		{
			BOMB_BTN = new BOMB_BTN_EMBED().bitmapData;
			BASE_BTN = new BASE_BTN_EMBED().bitmapData;
		}
		
		static private const OBSTACLES:Object = { bomb:Bomb, gap:Gap, block:Block, rock:Rock, base:Base, remove:null };
		private var data:XML;
		
		private var isPlaying:Boolean;
		private var songStarted:Boolean;
		private var playbackDrag:Boolean
		private var useMetronome:Boolean;
		
		private var selected:Class;
		private var highlighted:Obstacle;
		
		private var frame:int,
					meter:int,
					songOffset:int;
		
		public var songName:String;
		
		public var obstacles:Array;
		
		protected var sld_speed:Slider,
						sld_meter:Slider,
						sld_bpm:Slider,
						sld_offset:Slider;
		
		private var btn_play:FlxButton,
					btn_test:FlxButton;
		
		private var timeline:Timeline;
		private var playback:FlxSprite;
		private var song:KrkSound;
		
		private var playbackBeat:Number;
		
		public var level:XML;
		
		public function EditorState() {
			super();
		}
		
		override public function create():void {
			super.create();
			
			
			obstacles = [];
			addUI();
			playbackBeat = 0;
			songStarted = false;
			
			Obstacle.HERO = new FlxPoint(50, 200);
			FlxG.bgColor = 0xFFa4e4fc;
			
			createLevel();
		}
		
		private function addUI():void {
			
			add(timeline = new Timeline());
			timeline.x = Obstacle.HERO.x;
			
			add(new Button(8, 8, Imports.getButtonGraphic(32, 32), BOMB_BTN, bombClick));
			add(new Button(48, 8, Imports.getButtonGraphic(32, 32), null, rockClick));
			add(new Button(88, 8, Imports.getButtonGraphic(32, 32), null, blockClick));
			add(new Button(128, 8, Imports.getButtonGraphic(32, 32), null, gapClick));
			add(new Button(168, 8, Imports.getButtonGraphic(32, 32), null, baseClick));
			add(new Button(208, 8, Imports.getButtonGraphic(32, 32), null, removeClick));
			
			var slider:Slider;
			
			add(sld_speed = new Slider(5, 20, 1, 3));
			sld_speed.x = 100;
			sld_speed.y = 300;
			sld_speed.width = 50;
			sld_speed.label = "speed";
			sld_speed.changedCallback = sliderChanged;
			
			add(sld_meter = new Slider(2, 8, 1, 1));
			sld_meter.x = 175;
			sld_meter.y = 300;
			sld_meter.width = 50;
			sld_meter.valueSuffix = "/8";
			sld_meter.label = "meter";
			sld_meter.changedCallback = sliderChanged;
			
			add(sld_bpm = new Slider(60, 160, 0, 10));
			sld_bpm.x = 250;
			sld_bpm.y = 300;
			sld_bpm.dragInterval = 1;
			sld_bpm.label = "beats/minute";
			sld_bpm.changedCallback = sliderChanged;
			
			add(sld_offset = new Slider(0, 1, 0, .25));
			sld_offset.x = 400;
			sld_offset.y = 300;
			sld_offset.dragInterval = .001;
			sld_offset.label = "offset(seconds)";
			sld_offset.changedCallback = sliderChanged;
			
			add(btn_play = new FlxButton(8, 300, "Play", playClick));
			add(btn_test = new FlxButton(512, 300, "Test", testClick));
			
			add(playback = new FlxSprite(50, 79, PLAYBACK_EMBED));
			playback.offset.x = 5;
		}
		
		private function bombClick():void	{ selected = Bomb; }
		private function rockClick():void	{ selected = Rock; }
		private function blockClick():void	{ selected = Block; }
		private function gapClick():void	{ selected = Gap; }
		private function baseClick():void	{ selected = Base; }
		private function removeClick():void	{ selected = null; }
		private function playClick():void	{
			isPlaying = !isPlaying;
			if(isPlaying){
				BeatKeeper.beat = playbackBeat;
				BeatKeeper.init(songStart);
			} else {
				songStarted = false;
				song.stop();
			}
		}
		private function testClick():void {
			var testMode:TestMode = new TestMode(createXML());
			testMode.editor = this;
			FlxG.switchState(testMode);
		}
		
		private function createXML():XML {
			data = <level><assets/></level>;
			data.@bpm = BeatKeeper.beatsPerMinute;
			data.@speed = -Obstacle.SCROLL;
			if (songName != null) data.@song = songName;
			data.@offset = songOffset;
			data.@meter = meter;
			for (var i:String in obstacles) {
				var type:String;
				if (obstacles[i] != null) {
					if (obstacles[i] is Rock) type = "rock";
					else if (obstacles[i] is Block) type = "block";
					else if (obstacles[i] is Gap) type = "gap";
					else if (obstacles[i] is Bomb) type = "bomb";
					else if (obstacles[i] is Base) type = "base";
					data.assets[0].appendChild(<{type} beat={Number(i)/4}></{type}>);
				}
			}
			//trace(data.toXMLString());
			System.setClipboard(data.toXMLString());
			return data;
		}
		
		private function sliderChanged(slider:Slider):void {
			switch(slider) {
				case sld_speed:		Obstacle.SCROLL = -slider.value; break;
				case sld_meter:		meter = slider.value; break;
				case sld_bpm:		BeatKeeper.beatsPerMinute = slider.value; break;
				case sld_offset:	songOffset = slider.value*1000; return;
			}
			timeline.drawGraphic(BeatKeeper.toBeatPixels( -Obstacle.SCROLL / 4), meter);
		}
		
		private function createLevel():void {
			if (level == null)
				level = Imports.getLevel("tmottbg");
				
			sld_bpm.value = BeatKeeper.beatsPerMinute = level.@bpm;
			Obstacle.HERO = new FlxPoint(50, 140);
			Obstacle.SCROLL = -level.@speed;
			sld_speed.value = level.@speed;
			songOffset = Number(level.@offset);
			sld_offset.value = songOffset / 1000;
			sld_meter.value = meter = level.@meter;
			
			if ("@song" in level) {
				songName = level.@song.toString();
				song = new KrkSound();
				song.loadEmbedded(Imports.getSong(songName), false, true);
			}
			
			if (level.assets.length() > 0)
				createAssets(level.assets[0]);
			
			BeatKeeper.init(0);
			timeline.drawGraphic(BeatKeeper.toBeatPixels( -Obstacle.SCROLL / 4), meter);
		}
		private function createAssets(assets:XML):void {
			var obs:Obstacle;
			
			for each(var node:XML in assets.children()) {
				obs = new OBSTACLES[node.name().toString()]()
				XMLParser.setProperties(obs, node).isEditor = true;
				
				obstacles[obs.beat*4] = obs;
				add(obs);
			}
		}
		
		override public function update():void {
			if (isPlaying) {
				BeatKeeper.update();
				playbackBeat = BeatKeeper.beat;
				if (BeatKeeper.time > songOffset && !songStarted && song != null) {
					song.position = BeatKeeper.time-songOffset;
					song.play();
					songStarted = true;
				}
			} else {
				if (FlxG.keys.LEFT && BeatKeeper.beat > 0)
					BeatKeeper.beat -= .05;
				if (FlxG.keys.RIGHT)
					BeatKeeper.beat += .05;
			}
			
			super.update();
			
			if (!isPlaying)
				mouseHandle(FlxG.mouse);
			
			timeline.x = Obstacle.HERO.x + BeatKeeper.toBeatPixels( Obstacle.SCROLL) * BeatKeeper.beat;
			playback.x = Obstacle.HERO.x + BeatKeeper.toBeatPixels( Obstacle.SCROLL) * (BeatKeeper.beat - playbackBeat);
		}
		
		private function mouseHandle(mouse:Mouse):void {
			var beat:int = getBeat(mouse.x) * 4;
			if (mouse.justPressed()) {
				if (mouse.y >= 100 && mouse.y < 280) {
					
					if (obstacles[beat] != null) remove(obstacles[beat]).destroy();
					
					if (selected != null) {
						
						var ob:Obstacle = new selected();
						obstacles[beat] = ob;
						ob.isEditor = true;
						ob.beat = beat / 4;
						add(ob);
					}
				} else if (mouse.y > 80 && mouse.y < 100) {
					playbackBeat = beat/4;
				}
			} else if (mouse.y >= 100 && mouse.y < 280) {
				if (obstacles[beat] != null) {
					
					if (highlighted != obstacles[beat]) {
						if (highlighted != null) highlighted.glow = false;
						
						highlighted = obstacles[beat];
						highlighted.glow = true;
					}
				} else if (highlighted != null) {
					highlighted.glow = false;
					highlighted = null;
				}
			} else if (highlighted != null) {
				highlighted.glow = false;
				highlighted = null;
			}
		}
		private function getBeat(x:Number):Number {
			return BeatKeeper.beat + (Obstacle.HERO.x - x) / BeatKeeper.toBeatPixels(Obstacle.SCROLL);
		}
		public function get songStart():int {
			return playbackBeat;
		}
	}

}
import baseball.art.RepeatingTile;
import flash.display.BitmapData;
import flash.geom.Rectangle;
class Timeline extends RepeatingTile {
	public function Timeline() {
		super(50, 80, null, -1, 1);
	}
	public function drawGraphic(width:int, meter:int):void {
		trace(width);
		var rect:Rectangle = new Rectangle(0, 21, width, 179);
		pixels = new BitmapData(width * meter, 200, false, 0x80FFFFFF);
		frameWidth = width * meter;
		frameHeight = 200;
		for (var i:int = 0; i < meter; i++) {
			if(i % 2 == 0)
				pixels.fillRect(rect, 0x800000FF);
			rect.x += width;
		}
		
		rect.x = 0;
		rect.y = 0;
		rect.width = 1;
		rect.height = 200;
		pixels.fillRect(rect, 0xFF000000);
		
		rect.width = width * meter;
		rect.height = 1;
		rect.y = 0;
		pixels.fillRect(rect, 0xFF000000);
		
		rect.y = 199;
		pixels.fillRect(rect, 0xFF000000);
		
		rect.height = 2;
		rect.y = 19;
		pixels.fillRect(rect, 0xFF000000);
		
		resetHelpers();
	}
}