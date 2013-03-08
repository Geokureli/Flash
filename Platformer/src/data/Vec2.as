package data 
{
	/**
	 * ...
	 * @author George
	 */
	public class Vec2 
	{
		public var	x:Number,
					y:Number;
		
		public function Vec2(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		public function clone():Vec2 { return new Vec2(x, y); }
		public function dot(v:Vec2):Number { return x * v.x + y * v.y; }
		public function isSameDir(v:Vec2):Boolean { return dot(v) > 0; }
		public function toString():String { return x + ", " + y; } 
		// --- --- --- --- --- --- -
		// --- --- MODIFIERS --- --- 
		// --- --- --- --- --- --- -
		
		public function add(v:Vec2):void { x += v.x; y += v.y; }
		public function subtract(v:Vec2):void { x -= v.x; y -= v.y; }
		public function multiply(scaler:Number):void { x *= scaler; y *= scaler; }
		public function divide(scaler:Number):void { x /= scaler; y /= scaler; }
		public function normalize():void {
			var l:Number = length;
			x = x / l;
			y = y / l;
		}
		
		// --- --- --- --- --- --- -
		// --- --- OPERATORS --- --- 
		// --- --- --- --- --- --- - 
		
		public function sum(v:Vec2):Vec2 { return new Vec2(x + v.x, y + v.y); }
		public function dif(v:Vec2):Vec2 { return new Vec2(x - v.x, y - v.y); }
		public function scale(num:Number):Vec2 { return new Vec2(x * num, y * num); }
		public function project(v:Vec2):Vec2 { return v.unit.scale(dot(v.unit)); }

		// --- --- --- --- --- --- --- --- -
		// --- --- GETTERS / SETTERS --- ---
		// --- --- --- --- --- --- --- --- -
		
		public function get length2():Number { return x * x + y * y; }
		public function get length():Number { return Math.sqrt(x * x + y * y); }
		public function set length(num:Number):void { normalize(); multiply(num); }
		public function get angle():Number { return Math.atan2(y, x); }
		public function set angle(num:Number):void {
			var l:Number = length;
			x = Math.cos(num) * l;
			y = Math.sin(num) * l;
		}
		public function get rotation():Number { return angle / Math.PI * 180; }
		public function set rotation(num:Number):void { angle = num * Math.PI / 180; }
		
		public function get rHand():Vec2 { return new Vec2(-y, x); }
		public function get lHand():Vec2 { return new Vec2(y, -x); }
		
		public function get unitX():Number { return x / length; }
		public function get unitY():Number { return y / length; }
		public function get unit():Vec2 {
			var v:Vec2 = clone();
			v.normalize();
			return v;
		}
		public function get string():String { return toString(); }
	}

}