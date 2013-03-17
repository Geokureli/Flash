package baseball {
	import baseball.scenes.ButtonTestScene;
	import baseball.scenes.editor.EditorScene;
	import baseball.scenes.GameScene;
	import baseball.scenes.MainMenu;
	import baseball.scenes.RandomScene;
	import baseball.scenes.TestScene;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import relic.data.Game;
	import flash.events.Event;
	import relic.data.Global;
	import relic.data.StringHelper;
	import relic.data.xml.XMLParser;
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
			scenes = { main:MainMenu, editor:EditorScene, test:TestScene, song:GameScene, random:RandomScene };
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			showFPS = true;
			Global.game = this;
			stage.quality = StageQuality.LOW;
			
		}
		override protected function enterFrame(e:Event):void {
			super.enterFrame(e);
		}
	}
	
}