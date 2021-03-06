package astley.data {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class RAInput extends FlxBasic {
		
		static public var enabled:Boolean;
		static public var replayMode:Boolean;
		static public var instance:RAInput;
		
		static private function STATIC_INIT():void {
			
			enabled = true;
			replayMode = false;
			instance = new RAInput();
		}
		
		static public function get isButtonDown():Boolean {
			
			return instance.isButtonDown && enabled;
		}
		
		public var isButtonDown:Boolean;
		public var mouseJustPressed:Boolean;
		private var _antiPress:Boolean
		
		public function RAInput() {
			super();
			
			_antiPress = true;
			isButtonDown = false;
		}
		
		override public function update():void {
			super.update();
			
			isButtonDown = false;
			mouseJustPressed = FlxG.mouse.justPressed();
			
			if (!FlxG.keys.any() && !FlxG.mouse.pressed())
				_antiPress = true;
				
			else if(_antiPress) {
				
				_antiPress = false;
				isButtonDown = enabled || replayMode;
			}
		}
		
		{ STATIC_INIT(); }
	}
}