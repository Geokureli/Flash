package krakel {
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	
	public class KrkNest extends FlxGroup {
		public var _x:Number,
					_y:Number;
		
		public function KrkNest(x:Number = 0, y:Number = 0) {
			super();
			_x = x;
			_y = y;
		}
		
		override public function add(object:FlxBasic):FlxBasic {
			if (object is FlxObject) {
				(object as FlxObject).x += x;
				(object as FlxObject).y += y;
			}
			return super.add(object);
		}
		
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			for each(var child:FlxObject in members) {
				
				if (child != null)
					child.x += value - _x;
			}
				
			_x = value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			for each(var child:FlxObject in members) {
				
				if (child != null)
					child.y += value - _y;
			}
				
			_y = value;
		}
		
	}

}