package astley.data {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class RAInput extends FlxBasic {
		
		static public var enabled:Boolean;
		static public var instance:RAInput;
		
		static private function STATIC_INIT():void {
			
			enabled = true;
			instance = new RAInput();
		}
		
		public var isButtonDown:Boolean;
		private var _antiPress:Boolean
		
		public function RAInput() {
			super();
			
			_antiPress = true;
			isButtonDown = false;
		}
		
		override public function update():void {
			super.update();
			
			isButtonDown = false;
			
			if (!FlxG.keys.any() && !FlxG.mouse.pressed())
				_antiPress = true;
				
			else if(_antiPress && enabled) {
				
				_antiPress = false;
				isButtonDown = true;
			}
		}
		
		{ STATIC_INIT(); }
	}
}