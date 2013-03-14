package {
	import flash.display.Sprite;
	import flash.events.Event;
	import relic.data.Game;
	import scenes.MainBlit;
	import scenes.MainNative;
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Game {
		
		public function Main():void { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			scenes = { main:MainBlit };
			Imports;
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			showFPS = true;
		}
	}
	
}