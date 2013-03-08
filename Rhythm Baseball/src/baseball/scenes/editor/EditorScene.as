package baseball.scenes.editor {
	import baseball.art.obstacles.Block;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Rock;
	import baseball.art.RhythmAsset;
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
	import relic.art.Text;
	import relic.data.BoundMode;
	import relic.data.events.SceneEvent;
	import relic.data.Global;
	/**
	 * ...
	 * @author George
	 */
	public class EditorScene extends Scene{
		private var frame:int;
		private var data:XML;
		static private const OBSTACLES:Object = { bomb:Bomb, gap:Gap, block:Block, rock:Rock, remove:null };
		private var selected:Class;
		private var level:Array;
		
		public function EditorScene() {
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			level = [];
			selected = null;
			BeatKeeper.beat = 0;
			BeatKeeper.beatsPerMinute = 160;
			RhythmAsset.SCROLL = -10;
			RhythmAsset.END_X = 0;
			Bomb.SPEED = 0;
		}
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			assets.autoGroup(Button, "buttons");
			
			assets.autoName("bomb");
			assets.autoName("gap");
			assets.autoName("rock");
			assets.autoName("block");
			
			place("front", add(new Button(new Bitmap(Rock.sprites.frames[0])),	"btn_rock"),	{ x:10, y:10} );
			place("front", add(new Button(new Bitmap(Gap.src)),					"btn_gap"),		{ x:60, y:10 } );
			place("front", add(new Button(new Imports.Block()),					"btn_block"),	{ x:150, y:10 } );
			place("front", add(new Button(new Bitmap(Bomb.sprites.frames[0])),	"btn_bomb"),	{ x:200, y:10 } );
			place("front", add(new Button(new Imports.Remove()),				"btn_remove"),	{ x:250, y:10 } );
			place("front", add(new Asset(), "selector"), { x:250, y:10 } );
			asset("selector").graphics.lineStyle(1, 0x00FF00);
			asset("selector").graphics.drawRect(0,0,50,50);
			place("back", add(new Staff(), "staff"));
			
			if ("userLevel" in Global.VARS) {
				var ob:Asset;
				var beat:Number;
				BeatKeeper.beatsPerMinute = Global.VARS.userLevel.@bpm;
				RhythmAsset.SCROLL = -Number(Global.VARS.userLevel.@speed);
				var params:Object = { boundMode:BoundMode.NONE };
				for each(var child:XML in Global.VARS.userLevel.children()) {
					beat = Number(child);
					switch(child.name().toString()) {
						case "ball":
							ob = place("mid", add(new Bomb(beat)), params);
							break;
						case "gap":
							ob = place("mid", add(new Gap(beat)), params);							
							break;
						case "rock":
							ob = place("mid", add(new Rock(beat)), params);
							break;
						case "block":
							ob = place("mid", add(new Block(beat)), params);
							break;
					}
					level[Math.round(beat * 4)] = ob;
				}
			}
			
			place(
				"front",
				add(new Text(BeatKeeper.beatsPerMinute.toString()), "txt_bpm"),
				{x:500, y:10, width:100, height:20, border:true, background:true, type:TextFieldType.INPUT }
			);
			
			place(
				"front",
				add(new Text((-RhythmAsset.SCROLL).toString()), "txt_speed"),
				{x:610, y:10, width:100, height:20, border:true, background:true, type:TextFieldType.INPUT }
			);
		}
		
		override protected function addListeners():void {
			super.addListeners();
			for each(var button:Button in assets.group("buttons"))
				button.addEventListener(MouseEvent.CLICK, onBtnClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
		}
		
		override protected function removeListeners():void {
			super.removeListeners();
			for each(var button:Button in assets.group("buttons"))
				button.removeEventListener(MouseEvent.CLICK, onBtnClick);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
		}
		
		private function onBtnClick(e:MouseEvent):void {
			var btnName:String = e.currentTarget.name
			selected = OBSTACLES[btnName.split('_')[1]];
			asset("selector").x = asset(btnName).x;
		}
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.type == KeyboardEvent.KEY_UP) return;
			switch(e.keyCode) {
				case 32:
					generateData();
					break;
				case 13:
					BeatKeeper.beatsPerMinute = Number((asset("txt_bpm") as Text).text);
					RhythmAsset.SCROLL = -Number((asset("txt_speed") as Text).text);
					(asset("staff") as Staff).draw();
					break;
				default:
					if (e.keyCode > 48 && e.keyCode < 54) {
						var btn:Asset = assets.group("buttons")[e.keyCode-49];
						selected = OBSTACLES[btn.name.split('_')[1]];
						asset("selector").x = btn.x
					}
			}
		}
		
		private function generateData():void {
			data = <level/>;
			data.@bpm = BeatKeeper.beatsPerMinute;
			data.@speed = -RhythmAsset.SCROLL;
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
		
		private function mouseHandle(e:MouseEvent):void {
			if (e.stageY > 100) {
				switch(e.type) {
					case MouseEvent.MOUSE_MOVE:
						break;
					case MouseEvent.MOUSE_DOWN:
						//trace(BeatKeeper.toFramePixels(BeatKeeper.beat)
						var beat:int = BeatKeeper.beat*4 + (RhythmAsset.END_X - e.stageX) / BeatKeeper.toBeatPixels(RhythmAsset.SCROLL/4);
						if (level[beat] != null && selected != null && level[beat] is selected)
							break;
						if(selected != null)
							var ob:Asset = place("mid", add(new selected(beat / 4)), { boundMode:BoundMode.NONE } );
						if (level[beat] != null)
							kill(level[beat].name);
						level[beat] = ob;
						break;
				}
				
			}
		}
		override public function enterFrame():void {
			super.enterFrame();
			if (right) BeatKeeper.beat++;
			if (left && BeatKeeper.beat > 0) BeatKeeper.beat--;
		}
		override public function destroy():void {
			super.destroy();
			data = null;
			selected = null;
			level = null;
		}
	}

}