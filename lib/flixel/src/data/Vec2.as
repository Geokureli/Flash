package data 
{
	/**
	 * ...
	 * @author George
	 */
	public class Vec2 {
		public var x:Number, y:Number;
			
		public function Vec2(x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}
		public function get lHand():Vec2 { return new Vec2( -y, x); }
		public function get yHand():Vec2 { return new Vec2( y, -x); }
		public function set length(num:Number):void {
			var l:Number = length;
			x = x / l * num;
			y = y / l * num;
		}
		public function get length():Number { return Math.sqrt(x * x + y * y); }
		public function get length2():Number { return x * x + y * y; }
	}

}