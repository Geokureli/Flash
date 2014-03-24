package astley.art.ui.buttons {
	import org.flixel.FlxButton;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimatedButton extends FlxButton {
		
		static public const STATES:Array = [];
		
		static private function STATIC_INIT():void {
			
			STATES[NORMAL] = "normal";
			STATES[HIGHLIGHT] = "highlight";
			STATES[PRESSED] = "pressed";
		}
		
		public function AnimatedButton(x:Number = 0, y:Number = 0, graphic:Class = null, width:int = 0, height:int = 0) {
			
			loadGraphic(graphic, true, false, width, height);
			addAnimation(STATES[NORMAL], [0]);
			addAnimation(STATES[HIGHLIGHT], [1]);
			addAnimation(STATES[PRESSED], [2]);
		}
		
		override protected function updateButton():void {
			super.updateButton();
			
			if (_curAnim != status)
				play(status);
		}
		
		{ STATIC_INIT(); }
	}
}