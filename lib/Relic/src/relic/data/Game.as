package relic.data 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import relic.art.Asset;
	import relic.art.IScene;
	import relic.data.events.SceneEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Game extends Sprite 
	{
		
		protected var scenes:Object;
		protected var _sceneNumber:int;
		protected var currentScene:IScene;
		
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
			addChild(currentScene as DisplayObject);
			currentScene.addEventListener(SceneEvent.SCENE_CHANGE, onSceneChange);
		}
		
		private function onSceneChange(e:SceneEvent):void {
			scene = e.data.next;
			stage.focus = stage;
		}
	}

}