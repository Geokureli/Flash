package krakel {
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author George
	 */
	
	public class KrkNest extends KrkGroup {
		public var _x:Number;
		public var _y:Number;
		/** not used yet */
		public var offset:FlxPoint;
		
		
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
			
			if (_x == value) return;
			
			for each(var child:FlxBasic in members) {
				
				if (child != null) {
					
					if (child is FlxObject) 
						(child as FlxObject).x += value - _x;
						
					else if (child is KrkNest)
						(child as KrkNest).x += value - _x;
				}
			}
				
			_x = value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			
			if (_y == value) return;
			
			for each(var child:FlxBasic in members) {
				
				if (child != null) {
					
					if (child is FlxObject) 
						(child as FlxObject).y += value - _y;
						
					else if (child is KrkNest)
						(child as KrkNest).y += value - _y;
				}
			}
				
			_y = value;
		}
		
	}

}