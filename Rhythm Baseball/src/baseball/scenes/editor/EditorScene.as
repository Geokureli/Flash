package baseball.scenes.editor {
	import baseball.art.obstacles.Block;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Rock;
	import baseball.art.Obstacle;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import relic.beat.BeatKeeper;
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import relic.art.Asset;
	import relic.art.Button;
	import relic.art.Scene;
	import relic.art.Slider;
	import relic.art.Text;
	import relic.audio.SoundManager;
	import relic.data.BoundMode;
	import relic.data.events.PopupEvent;
	import relic.data.events.SceneEvent;
	import relic.data.Global;
	import relic.data.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class EditorScene extends Scene{
		static private const GLOW:GlowFilter = new GlowFilter(0, 1, 2, 2, 8, 1);
		static private const GLOW_2:GlowFilter = new GlowFilter(0xFFFFFF, 1, 2, 2, 8, 1);
		
		static private const OBSTACLES:Object = { bomb:Bomb, gap:Gap, block:Block, rock:Rock, remove:null };
		static private const PARAMS:Object = { boundMode:BoundMode.NONE };
		private var frame:int;
		private var data:XML;
		private var selected:Class;
		private var level:Array;
		private var isPlaying:Boolean;
		private var song:String;
		private var songOffset:int;
		private var songPlaying:Boolean;
		private var playbackDrag:Boolean
		private var useMetronome:Boolean;
		private var highlighted:Obstacle;
		public function EditorScene() {
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			selected = null;
			BeatKeeper.beat = 0;
			BeatKeeper.beatsPerMinute = 120;
			Obstacle.SCROLL = -10;
			Obstacle.HERO = new Vec2(50, 200);
			Bomb.SPEED = 0;
			isPlaying = false;
			songPlaying = false;
			playbackDrag = false;
			useMetronome = false;
			song = "tmottbg";
		}
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			assets.autoGroup(Button, "buttons");
			assets.autoGroup(Slider, "sliders");
			assets.autoGroup(Obstacle, "obstacles");
			
			assets.autoID("bomb");
			assets.autoID("gap");
			assets.autoID("rock");
			assets.autoID("block");
			
			add(new SongPopup(), "popup");
			
			// --- TOOLBOX
			place("front", add(new Btn(), "btn_bomb",	"tools"), { x: 10, y:10, upFrame:0, selectedFrame:5 } );
			place("front", add(new Btn(), "btn_rock",	"tools"), { x: 80, y:10, upFrame:1, selectedFrame:6 } );
			place("front", add(new Btn(), "btn_block",	"tools"), { x:150, y:10, upFrame:2, selectedFrame:7 } );
			place("front", add(new Btn(), "btn_gap",	"tools"), { x:220, y:10, upFrame:3, selectedFrame:8 } );
			(place("front", add(new Btn(), "btn_remove","tools"), { x:290, y:10, upFrame:4, selectedFrame:9 } ) as Button).selected = true;
			place("back", add(new Staff(), "staff"));
			
			// --- NAVIGATION BUTTONS
			place("front", add(new Btn(Imports.navButtons), "btn_left2")	,{ x:360, y:58, upFrame:6, overFrame:7, downFrame:8 } );
			place("front", add(new Btn(Imports.navButtons), "btn_left")		,{ x:380, y:58, upFrame:3, overFrame:4, downFrame:5 } );
			place("front", add(new Btn(Imports.navButtons), "btn_right")	,{ x:400, y:58, upFrame:0, overFrame:1, downFrame:2 } );
			place("front", add(new Btn(Imports.navButtons), "btn_right2")	,{ x:420, y:58, upFrame:9, overFrame:10,downFrame:11} );
			
			
			// --- MISC BUTTONS
			place("front", add(new Btn(), "btn_music")	,{ x:510, y:10, upFrame:13, overFrame:18 } );
			place("front", add(new Btn(), "btn_save")	,{ x:580, y:10, upFrame:10, overFrame:15 } );
			place("front", add(new Btn(), "btn_load")	,{ x:650, y:10, upFrame:11, overFrame:16 } );
			place("front", add(new Btn(), "btn_upload")	,{ x:720, y:10, upFrame:12, overFrame:17 } );
			place("front", add(new Btn(), "btn_play")	,{ x:10, y:325, upFrame:14, selectedFrame:19 } );
			place("front", add(new Btn(Imports.TestBtn), "btn_test") ,{ x:650, y:325, upFrame:0, overFrame:1, downFrame:2 } );
			place("front", add(new Btn(Imports.smlButtons), "btn_metronome") ,{ x:360, y:10, upFrame:0, selectedFrame:1 } );
			//place("front", add(new Btn(Imports.smlButtons), "btn_playback") ,{ x:650, y:325, upFrame:0, downFrame:1 } );
			
			place( "front", add(new Slider(5, 20, 1, 3), "sld_speed"),
				{x:100, y:375, label:"speed", width:50, value:-Obstacle.SCROLL }
			)
			place( "front", add(new Slider(2, 8, 1, 1), "sld_meter"),
				{x:175, y:375, label:"meter", width:50, value:staff.meter, valueSuffix:"/8" }
			)
			place( "front", add(new Slider(60, 160, 0, 10), "sld_bpm"),
				{x:250, y:375, label:"beats/minute", width:150, value:BeatKeeper.beatsPerMinute, allowTextEdit:true, dragInterval:1 }
			)
			place( "front", add(new Slider(0, 1, 0, .25), "sld_offset"),
				{x:425, y:375, label:"offset(seconds)", width:150, value:songOffset/1000, precision:3, allowTextEdit:true, dragInterval:.01 }
			)
			
			if ("userLevel" in Global.VARS)
				loadLevel(Global.VARS.userLevel);
			else level = [];
		}
		
		private function loadLevel(level:XML):void {
			assets.killGroup("obstacles");
			this.level = [];
			var ob:Obstacle;
			var beat:Number;
			BeatKeeper.beatsPerMinute = level.@bpm;
			Obstacle.SCROLL = -Number(level.@speed);
			if("@offset" in level) songOffset = Number(level.@offset);
			if("@meter" in level) staff.meter = Number(level.@meter);
			
			for each(var child:XML in level.assets[0].children()) {
				beat = Number(child.@beat);
				switch(child.name().toString()) {
					case "ball":	ob = place("mid", add(new Bomb ()), PARAMS) as Obstacle; break;
					case "gap":		ob = place("mid", add(new Gap  ()), PARAMS) as Obstacle; break;
					case "rock":	ob = place("mid", add(new Rock ()), PARAMS) as Obstacle; break;
					case "block":	ob = place("mid", add(new Block()), PARAMS) as Obstacle; break;
				}
				ob.beat = beat;
//				ob.update();
				ob.debugDraw();
				this.level[Math.round(beat * 4)] = ob;
			}
			slider("sld_speed").value = -Obstacle.SCROLL;
			slider("sld_meter").value = staff.meter;
			slider("sld_bpm").value = BeatKeeper.beatsPerMinute;
			slider("sld_offset").value = songOffset / 1000;
			if(stage) staff.draw();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			for each(var button:Button in assets.group("buttons"))
				button.addEventListener(MouseEvent.CLICK, onBtnClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			for each(var slider:Slider in assets.group("sliders"))
				slider.addEventListener(Event.CHANGE, onChange);
		}
		override protected function removeListeners():void {
			super.removeListeners();
			for each(var button:Button in assets.group("buttons"))
				button.removeEventListener(MouseEvent.CLICK, onBtnClick);
			for each(var slider:Slider in assets.group("sliders"))
				slider.removeEventListener(Event.CHANGE, onChange);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
		}

		private function onChange(e:Event):void {
			switch(e.currentTarget.name) {
				case "sld_speed":
					Obstacle.SCROLL = -e.currentTarget.value;
					staff.draw();
					break;
				case "sld_meter":
					staff.meter = e.currentTarget.value;
					staff.draw();
					break;
				case "sld_bpm":
					BeatKeeper.beatsPerMinute = e.currentTarget.value;
					staff.draw();
					break;
				case "sld_offset":
					songOffset = e.currentTarget.value * 1000;
					staff.draw();
					break;
			}
		}
		
		private function onBtnClick(e:MouseEvent):void {
			switch(e.currentTarget.name) {
				case "btn_test":
					if (isPlaying) return;
					generateData();
					break;
				case "btn_play":
					isPlaying = !e.currentTarget.selected;
					for each(var slider:Slider in assets.group("sliders"))
						slider.enabled = !isPlaying;
					e.currentTarget.selected = isPlaying;
					//BeatKeeper.beat = playback;
					BeatKeeper.init(staff.songStart);
					if (isPlaying) {
						if (useMetronome) {
							if (staff.meter % 2 == 0) {
								
								var sndArr:Array = ["onBeat", null];
								
								for (var i:int = 2; i < staff.meter; i += 2) 
									sndArr.push("offBeat", null);
								
								BeatKeeper.setMetronome(sndArr, 1);
							} else 
								BeatKeeper.setSimpleMetronome(staff.meter, "onBeat", "offBeat", 1);
						}
						if (staff.songStart >= songOffset && song != null) {
							SoundManager.play(song, staff.songStart - songOffset);
							songPlaying = true;
						}
					} else if (songPlaying && song != null) {
						SoundManager.stop(song);
						songPlaying = false;
					}
					break;
				case "btn_music":
					place("front", "popup").addEventListener(PopupEvent.COMPLETE, popopEnd);
					break;
				case "btn_load":
					loadLevel(new XML(new Imports.Level1()));
					break;
				case "btn_save":
					break;
				case "btn_upload": break;
				case "btn_left2": BeatKeeper.beat = 0; staff.draw(); break;
				case "btn_left": BeatKeeper.beat -= .25; staff.draw(); break;
				case "btn_right": BeatKeeper.beat += .25; staff.draw(); break;
				case "btn_right2":
					var end:Number = level.length;
					while (level[end - 1] == null && end > 1)
						end--;
					if(end > staff.meter)
						BeatKeeper.beat = (end - staff.meter) / 4;
					staff.draw();
					break;
				case "btn_metronome":
					e.currentTarget.selected = useMetronome = !useMetronome;
					break;
				default:
					if (isPlaying) return;
					for each(var btn:Button in assets.group("tools"))
						btn.selected = false;
						
					e.currentTarget.selected = true;
					var btnName:String = e.currentTarget.name
					selected = OBSTACLES[btnName.split('_')[1]];
			}
		}
		
		
		private function popopEnd(e:PopupEvent):void {
			song = e.params as String;
			if (SoundManager.hasMusic(song)) {
				Global.VARS.song = song;
				a("popup").removeEventListener(PopupEvent.COMPLETE, popopEnd);
				assets.remove("popup");
			} else song = null;
		}
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.type == KeyboardEvent.KEY_UP) return;
			switch(e.keyCode) {
				case 32:
					break;
				case 13: break;
				default:
					if (e.keyCode > 48 && e.keyCode < 54) {
						var btn:Button = assets.group("tools")[e.keyCode-49] as Button;
						
						for each(var button:Button in assets.group("tools"))
							button.selected = false;
						
						btn.selected = true;
						
						selected = OBSTACLES[btn.id.split('_')[1]];
					}
			}
		}
		
		private function mouseHandle(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_UP) playbackDrag = false;
			if (isPlaying) return;
			if (e.stageY > Obstacle.HERO.y - 100 && e.stageY < Obstacle.HERO.y + 100) {
				switch(e.type) {
					case MouseEvent.MOUSE_MOVE:
						if (highlighted != null) highlighted.filters = [];
						highlighted = level[int(getBeat(e.stageX) * 4)]
						if (highlighted != null) highlighted.filters = [GLOW_2, GLOW];
						break;
					case MouseEvent.MOUSE_DOWN:
						var beat:int = getBeat(e.stageX)*4;
						if (level[beat] != null && selected != null && level[beat] is selected)
							break;
						if(selected != null){
							var ob:Obstacle = place("mid", add(new selected()), PARAMS ) as Obstacle;
							ob.beat = beat / 4;
							ob.debugDraw()
						}
						if (level[beat] != null)
							kill(level[beat].name);
						level[beat] = ob;
						break;
				}
			} else if (e.stageY > Obstacle.HERO.y - 120 && e.stageY < Obstacle.HERO.y - 100
					&& (e.type == MouseEvent.MOUSE_DOWN || playbackDrag)) {
				var dragBeat:Number = getBeat(e.stageX);
				if (dragBeat < 0) dragBeat = 0;
				staff.playback = dragBeat;
				playbackDrag = true;
			}
		}
		private function getBeat(x:Number):Number {
			return BeatKeeper.beat + (Obstacle.HERO.x - x) / BeatKeeper.toBeatPixels(Obstacle.SCROLL);
		}
		override public function update():void {
			if (isPlaying) {
				BeatKeeper.update();
				staff.playback = BeatKeeper.beat;
				staff.draw();
				if (!songPlaying && song != null && BeatKeeper.time > songOffset) {
					SoundManager.play(song, songOffset - BeatKeeper.time);
					songPlaying = true;
				}
			} else {
				if (right){
					BeatKeeper.beat += .25;
					staff.draw();
				}
				if (left && BeatKeeper.beat > 0) {
					BeatKeeper.beat -= .25;
					staff.draw();
				}
			}
			super.update();
		}
		
		private function generateData():void {
			data = <level><assets/></level>;
			data.@bpm = BeatKeeper.beatsPerMinute;
			data.@speed = -Obstacle.SCROLL;
			if (song != null) data.@song = song;
			data.@offset = songOffset.toString();
			data.@meter = staff.meter.toString();
			for (var i:String in level) {
				var type:String;
				if (level[i] != null) {
					if (level[i] is Rock) type = "rock";
					else if (level[i] is Block) type = "block";
					else if (level[i] is Gap) type = "gap";
					else if (level[i] is Bomb) type = "ball";
					data.assets[0].appendChild(<{type} beat={Number(i)/4}></{type}>);
				}
			}
			//trace(data.toXMLString());
			System.setClipboard(data.toXMLString());
			Global.VARS["userLevel"] = data;
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:"test" } ));
		}
		
		override public function destroy():void {
			super.destroy();
			data = null;
			selected = null;
			level = null;
		}
		private function get staff():Staff { return a("staff") as Staff; }
		private function slider(name:String):Slider { return a(name) as Slider; }
	}
}
import baseball.Imports;
import relic.art.Button;
import flash.display.Bitmap;
import relic.art.SpriteSheet;

class Btn extends Button {

	public var src:SpriteSheet;
	
	public function Btn(src:SpriteSheet = null) {
		super();
		if(src == null)
			this.src = Imports.Buttons;
		else this.src = src;
	}
	
	public function set upFrame			(value:int):void { upState			= src.getFrame(value); }
	public function set downFrame		(value:int):void { downState		= src.getFrame(value); }
	public function set overFrame		(value:int):void { overState		= src.getFrame(value); }
	public function set selectedFrame	(value:int):void { selectedState	= src.getFrame(value); }
}