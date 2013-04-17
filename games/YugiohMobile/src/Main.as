package {
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			//Starling.handleLostContext = true;
			var starling:Starling = new Starling(GameEngine, stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			starling.showStats = true;
			starling.start();
		}
		
		private function deactivate(e:Event):void {
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}