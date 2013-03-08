package 
{
	import art.Dialogue;
	import art.DragBox;
	import art.Scenes.GameScene;
	import art.Scenes.MovementScene;
	import data.Script;
	import data.Vec2;
	import art.Scene;
	import art.Scenes.ProjectionScene;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite 
	{
		public var scenes:Vector.<Scene> = Vector.<Scene>([new GameScene()]);// , new MovementScene(), new ProjectionScene()]);
		private var _sceneNumber:int;
		private var currentScene:Scene;
		private var dialogue:Dialogue;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			sceneNumber = 0;
			//addChild(dialogue = new Dialogue());
			//dialogue.width = stage.stageWidth;
			//dialogue.height = 200;
			//dialogue.y = stage.stageHeight - dialogue.height;
		}
		
		private function set sceneNumber(value:int):void 
		{
			if (currentScene != null) {
				currentScene.destroy();
				removeChild(currentScene);
			}
			currentScene = scenes[value];
			addChild(currentScene);
		}
	}
	
}