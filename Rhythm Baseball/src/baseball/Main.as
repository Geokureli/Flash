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
	import relic.art.Asset;
	import relic.art.blitting.Blit;
	import relic.art.IScene;
	import relic.audio.SoundManager;
	import relic.data.AssetManager;
	import relic.data.Game;
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
	public class Main extends Game {
		public function Main():void {	
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			scenes = { main:MainMenu, editor:EditorScene, test:TestScene, random:RandomScene };
			new TestScene();
		}
	}
	
}