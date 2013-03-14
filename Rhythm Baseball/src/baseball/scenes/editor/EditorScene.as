package baseball.scenes.editor {
	import baseball.art.obstacles.Block;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Rock;
	import baseball.art.Obstacle;
	import baseball.beat.BeatKeeper;
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
		public function EditorScene() {
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			level = [];
			selected = null;
			BeatKeeper.beat = 0;
			BeatKeeper.beatsPerMinute = 120;
			Obstacle.SCROLL = -10;
			Obstacle.HERO = new Vec2(50, 200);
			Bomb.SPEED = 0;
			isPlaying = false;
			songPlaying = false;
			song = "tmottbg";
		}
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			assets.autoGroup(Button, "buttons");
			assets.autoGroup(Slider, "sliders");
			
			assets.autoName("bomb");
			assets.autoName("gap");
			assets.autoName("rock");
			assets.autoName("block");
			
			add(new SongPopup(), "popup");
			
			// --- TOOLBOX
			place("front", add(new Btn(), "btn_bomb",	"tools"), { x: 10, y:10, upFrame:0, selectedFrame:5 } );
			place("front", add(new Btn(), "btn_rock",	"tools"), { x: 80, y:10, upFrame:1, selectedFrame:6 } );
			place("front", add(new Btn(), "btn_block",	"tools"), { x:150, y:10, upFrame:2, selectedFrame:7 } );
			place("front", add(new Btn(), "btn_gap",	"tools"), { x:220, y:10, upFrame:3, selectedFrame:8 } );
			place("front", add(new Btn(), "btn_remove",	"tools"), { x:290, y:10, upFrame:4, selectedFrame:9, selected:true } );
			place("back", add(new Staff(), "staff"));
			
			// --- MISC BUTTONS
			place("front", add(new Btn(), "btn_music")	,{ x:510, y:10, upFrame:13, overFrame:18 } );
			place("front", add(new Btn(), "btn_load")	,{ x:580, y:10, upFrame:10, overFrame:15 } );
			place("front", add(new Btn(), "btn_save")	,{ x:650, y:10, upFrame:11, overFrame:16 } );
			place("front", add(new Btn(), "btn_upload")	,{ x:720, y:10, upFrame:12, overFrame:17 } );
			place("front", add(new Btn(), "btn_play")	,{ x:10, y:325, upFrame:14, selectedFrame:19 } );
			place("front", add(new Btn(Imports.TestBtn), "btn_test")	,{ x:650, y:325, upFrame:0, overFrame:1, downFrame:2 } );
			
			if ("userLevel" in Global.VARS) {
				var ob:Asset;
				var beat:Number;
				BeatKeeper.beatsPerMinute = Global.VARS.userLevel.@bpm;
				Obstacle.SCROLL = -Number(Global.VARS.userLevel.@speed);
				for each(var child:XML in Global.VARS.userLevel.children()) {
					beat = Number(child);
					switch(child.name().toString()) {
						case "ball":	ob = place("mid", add(new Bomb (beat)), PARAMS); break;
						case "gap":		ob = place("mid", add(new Gap  (beat)), PARAMS); break;
						case "rock":	ob = place("mid", add(new Rock (beat)), PARAMS); break;
						case "block":	ob = place("mid", add(new Block(beat)), PARAMS); break;
					}
					level[Math.round(beat * 4)] = ob;
				}
			}
			
			place(
				"front",
				add(new Slider(5, 20, 1, 3), "sld_speed"),
				{x:100, y:350, label:"speed", width:50, value:-Obstacle.SCROLL }
			)
			place(
				"front",
				add(new Slider(2, 8, 1, 1), "sld_meter"),
				{x:175, y:350, label:"meter", width:50, value:staff.beatsPerMeasure, valueSuffix:"/8" }
			)
			place(
				"front",
				add(new Slider(60, 160, 0, 10), "sld_bpm"),
				{x:250, y:350, label:"beats/minute", width:150, value:BeatKeeper.beatsPerMinute, allowTextEdit:true, dragInterval:1 }
			)
			place(
				"front",
				add(new Slider(0, 1, 0, .25), "sld_offset"),
				{x:425, y:350, label:"offset(seconds)", width:150, precision:3, allowTextEdit:true, dragInterval:.01 }
			)
			
		}
		override protected function addListeners():void {
			super.addListeners();
			for each(var button:Button in assets.group("buttons"))
				button.addEventListener(MouseEvent.CLICK, onBtnClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
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
					staff.beatsPerMeasure = e.currentTarget.value;
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
						if (staff.songStart >= songOffset && song != null) {
							SoundManager.play(song, staff.songStart - songOffset);
							songPlaying = true;
						}
					} else if (songPlaying && song != null) {
						SoundManager.stop(song);
					}
					break;
				case "btn_music":
					place("front", "popup").addEventListener(PopupEvent.COMPLETE, popopEnd);
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
				asset("popup").removeEventListener(PopupEvent.COMPLETE, popopEnd);
				assets.remove("popup");
			} else song = null;
		}
		override protected function keyHandle(e:KeyboardEvent):void {
			if (isPlaying) {
				trace("isPlaying");
				return;
			}
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
						
						selected = OBSTACLES[btn.name.split('_')[1]];
					}
			}
		}
		
		private function mouseHandle(e:MouseEvent):void {
			//trace(e.stageY > Obstacle.HERO.y - 120, e.stageY < Obstacle.HERO.y - 100
					//, e.stageX > Obstacle.HERO.x, e.type == MouseEvent.MOUSE_DOWN);
			if (isPlaying) return;
			if (e.stageY > Obstacle.HERO.y - 100 && e.stageY < Obstacle.HERO.y + 100) {
				switch(e.type) {
					case MouseEvent.MOUSE_MOVE: break;
					case MouseEvent.MOUSE_DOWN:
						var beat:int = getBeat(e.stageX)*4;
						if (level[beat] != null && selected != null && level[beat] is selected)
							break;
						if(selected != null)
							var ob:Asset = place("mid", add(new selected(beat / 4)), PARAMS );
						if (level[beat] != null)
							kill(level[beat].name);
						level[beat] = ob;
						break;
				}
			} else if (e.stageY > Obstacle.HERO.y - 120 && e.stageY < Obstacle.HERO.y - 100
					&& e.stageX > Obstacle.HERO.x && e.type == MouseEvent.MOUSE_DOWN) {
				staff.playback = getBeat(e.stageX);
			}
		}
		private function getBeat(x:Number):Number {
			return BeatKeeper.beat + (Obstacle.HERO.x - x) / BeatKeeper.toBeatPixels(Obstacle.SCROLL);
		}
		override public function update():void {
			super.update();
			if (isPlaying) {
				BeatKeeper.update();
				staff.playback = BeatKeeper.beat;
				staff.draw();
				if (!songPlaying) trace(BeatKeeper.time, songOffset);
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
		}
		
		private function generateData():void {
			data = <level/>;
			data.@bpm = BeatKeeper.beatsPerMinute;
			data.@speed = -Obstacle.SCROLL;
			if (song != null) data.@song = song;
			data.@songOffset = songOffset.toString();
			for (var i:String in level) {
				var type:String;
				if (level[i] != null) {
					if (level[i] is Rock) type = "rock";
					else if (level[i] is Block) type = "block";
					else if (level[i] is Gap) type = "gap";
					else if (level[i] is Bomb) type = "ball";
					data.appendChild(<{type}>{Number(i)/4}</{type}>);
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
		private function get staff():Staff { return asset("staff") as Staff; }
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