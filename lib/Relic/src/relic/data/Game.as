package relic.data 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import relic.art.Asset;
	import relic.art.IScene;
	import relic.art.Text;
	import relic.data.events.SceneEvent;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author George
	 */
	public class Game extends Sprite {
		private var _showFPS:Boolean;
		protected var debugTexts:Object;
		protected var scenes:Object;
		protected var _sceneNumber:int;
		protected var currentScene:IScene;
		protected var frameRateCount:Vector.<Number>;
		private var t:int;
		public function Game() {
			super();
			setDefaultValues();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function setDefaultValues():void {
			debugTexts = { };
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Asset.defaultBounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(FocusEvent.FOCUS_IN, onFocusLost);
			Keys.init(stage);
			Global.stage = stage;
			scene = "main";
		}
		
		private function onFocusLost(e:FocusEvent):void {
			stage.focus = stage;
		}
		
		protected function enterFrame(e:Event):void {
			if (currentScene != null) currentScene.update();
			if (debugTexts["fps_counter"] != null) {
				while (frameRateCount.length > stage.frameRate/2)
					frameRateCount.shift();
				frameRateCount.push(getTimer() - t);
				var sum:int = 0;
				for each(var i:int in frameRateCount)
					sum += i;
				setText("fps_counter", (int(1000 * frameRateCount.length / stage.frameRate * 10 / sum * stage.frameRate) / 10).toPrecision(3));
			}
			t = getTimer();
		}
		protected function set scene(value:String):void {
			if (currentScene != null) {
				currentScene.removeEventListener(SceneEvent.SCENE_CHANGE, onSceneChange);
				currentScene.destroy();
				removeChild(currentScene as DisplayObject);
			}
			//if (scenes[value] is IScene)
				//currentScene = scenes[value];
			//else 
			currentScene = new scenes[value]();
			addChildAt(currentScene as DisplayObject, 0);
			currentScene.addEventListener(SceneEvent.SCENE_CHANGE, onSceneChange);
		}
		
		public function get showFPS():Boolean { return _showFPS; }
		public function set showFPS(value:Boolean):void {
			_showFPS = value;
			if (value && debugTexts["fps_counter"] == null)
				createFPSCounter();
			if (debugTexts["fps_counter"] != null) debugTexts["fps_counter"].visible = true;
		}
		
		private function createFPSCounter():void {
			addDebugText("fps_counter");
			setTextParams("fps_counter", { x: stage.stageWidth - debugTexts["fps_counter"].width - 10 } );
			frameRateCount = new Vector.<Number>();
		}
		public function addDebugText(name:String, x:Number = 5, y:Number = 5, width:Number = 50, height:Number = 25, border:Boolean = true):void {
			var txt:TextField = (debugTexts[name] != null ? debugTexts[name] : new TextField());
			txt.width = width;
			txt.height = height;
			txt.x = x;
			txt.y = y;
			txt.defaultTextFormat = new TextFormat("Arial", 12, 0, true);
			txt.background = txt.border = border;
			txt.text = "";
			addChild(txt);
			debugTexts[name] = txt;
		}
		public function setText(name:String, value:String):void {
			debugTexts[name].text = value;
		}
		public function setTextParams(name:String, params:Object):void {
			for(var i:String in params)
				debugTexts[name][i] = params[i];
		}
		private function onSceneChange(e:SceneEvent):void {
			scene = e.data.next;
			stage.focus = stage;
		}
		
	}

}