package relic.data 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import relic.art.Asset;
	import relic.art.IScene;
	import relic.data.events.SceneEvent;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author George
	 */
	public class Game extends Sprite {
		
		private var _showFPS:Boolean;
		protected var fpsCounter:TextField;
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
		
		protected function setDefaultValues():void { }
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Asset.defaultBounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			scene = "main";
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		protected function enterFrame(e:Event):void {
			if (currentScene != null) currentScene.update();
			if (fpsCounter != null) {
				while (frameRateCount.length > stage.frameRate/2)
					frameRateCount.shift();
				frameRateCount.push(getTimer() - t);
				var sum:int = 0;
				for each(var i:int in frameRateCount)
					sum += i;
				fpsCounter.text = (int(1000 * frameRateCount.length / stage.frameRate * 10 / sum * stage.frameRate) / 10).toPrecision(3);
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
			if (value && fpsCounter == null)
				createFPSCounter();
			if (fpsCounter != null) fpsCounter.visible = true;
		}
		
		private function createFPSCounter():void {
			fpsCounter = new TextField();
			fpsCounter.width = 50;
			fpsCounter.height = 25;
			fpsCounter.defaultTextFormat = new TextFormat("Arial", 12, 0, true);
			fpsCounter.text = "000";
			fpsCounter.background = true;
			fpsCounter.border = true;
			addChild(fpsCounter);
			fpsCounter.x = stage.stageWidth - fpsCounter.width -10;
			frameRateCount = new Vector.<Number>();
		}
		
		private function onSceneChange(e:SceneEvent):void {
			scene = e.data.next;
			stage.focus = stage;
		}
		
	}

}