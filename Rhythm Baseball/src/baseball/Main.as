package baseball {
	import baseball.art.obstacles.Bomb;
	import baseball.art.RhythmAsset;
	import baseball.beat.BeatKeeper;
	import baseball.data.events.BeatEvent;
	import baseball.scenes.GameScene;
	import baseball.scenes.MainMenu;
	import baseball.scenes.RandomScene;
	import baseball.scenes.TestScene;
	import baseball.scenes.editor.EditorScene;
	import flash.geom.Rectangle;
	import relic.art.blitting.Blit;
	import relic.audio.SoundManager;
	import relic.data.AssetManager;
	import relic.data.Random;
	import relic.data.Script;
	import relic.data.Vec2;
	import relic.data.events.SceneEvent;
	import relic.art.Scene;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite {
		public var scenes:Object = { main:MainMenu, editor:EditorScene, test:TestScene, random:RandomScene};
		private var _sceneNumber:int;
		private var currentScene:Scene;
		public function Main():void {	
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			RhythmAsset.BOUNDS = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			scene = "main";
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void {
			if (currentScene != null) currentScene.enterFrame();
		}
		
		private function set scene(value:String):void {
			if (currentScene != null) {
				currentScene.removeEventListener(SceneEvent.SCENE_CHANGE, onSceneChange);
				currentScene.destroy();
				removeChild(currentScene);
			}
			currentScene = new scenes[value]();
			addChild(currentScene);
			currentScene.addEventListener(SceneEvent.SCENE_CHANGE, onSceneChange);
		}
		
		private function onSceneChange(e:SceneEvent):void {
			scene = e.data.next;
			stage.focus = stage;
		}
	}
	
}