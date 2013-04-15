package zelda{
	import flash.display.Sprite;
	import flash.events.Event;
	import relic.Game;
	import zelda.scenes.GameScene;
	
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
			showFPS = true;
			scenes = { "main":GameScene };
		}
		override protected function enterFrame(e:Event):void {
			super.enterFrame(e);
			
		}
	}
	
}