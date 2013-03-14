package baseball {
	import baseball.scenes.ButtonTestScene;
	import baseball.scenes.editor.EditorScene;
	import baseball.scenes.MainMenu;
	import baseball.scenes.RandomScene;
	import baseball.scenes.TestScene;
	import flash.display.Sprite;
	import relic.data.Game;
	import flash.events.Event;
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
			scenes = { main:MainMenu, editor:EditorScene, test:TestScene, song:RandomScene, random:RandomScene };
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			showFPS = true;
			
			var s:Sprite = new Sprite();
			s.width = 300;
			trace(s.width);
		}
		override protected function enterFrame(e:Event):void {
			super.enterFrame(e);
		}
	}
	
}