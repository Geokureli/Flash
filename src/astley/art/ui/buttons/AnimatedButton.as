package astley.art.ui.buttons {
	import astley.data.RAInput;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import org.flixel.FlxButton;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimatedButton extends FlxButton {
		
		static public const STATES:Array = [];
		
		public var link:String;
		
		static private function STATIC_INIT():void {
			
			STATES[NORMAL] = "normal";
			STATES[HIGHLIGHT] = "highlight";
			STATES[PRESSED] = "pressed";
		}
		
		public function AnimatedButton(x:Number = 0, y:Number = 0, graphic:Class = null, width:int = 0, height:int = 0) {
			super(x, y);
			
			loadGraphic(graphic, true, false, width, height);
			addAnimation(STATES[NORMAL], [0]);
			addAnimation(STATES[HIGHLIGHT], [1]);
			addAnimation(STATES[PRESSED], [2]);
			
			onUp = calLink;
		}
		
		private function calLink():void {
			
			navigateToURL(new URLRequest(link), "_blank");
		}
		
		override protected function updateButton():void {
			var camera:FlxCamera;
			
			if(cameras == null)
				cameras = FlxG.cameras;
			
			var i:int = 0;
			var l:uint = cameras.length;
			while (i < l) {
				
				// --- STUPID HACK FOR MY WEIRD INPUT REPLAY STUFF
				camera = cameras[i++] as FlxCamera;
				FlxG.mouse.getWorldPosition(camera, _point);
				if (overlapsPoint(_point, true, camera) && RAInput.instance.mouseJustPressed) {
					
					status = PRESSED;
					if(onDown != null)
						onDown();
					if(soundDown != null)
						soundDown.play(true);
				}
			}
			
			super.updateButton();
			
			if (_curAnim == null || _curAnim.name != STATES[status])
				play(STATES[status]);
		}
		
		{ STATIC_INIT(); }
	}
}