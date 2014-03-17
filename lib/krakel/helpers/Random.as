package krakel.helpers 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class Random 
	{
		static public function between(low:Number, high:Number = 0, round:Number = 1):Number {
			if (low > high){
				
				var temp:Number = low;
				low = high;
				high = temp;
			}
			
			if (round > 0)
				return low + int(Math.random() * (high - low) / round) * round;
			return low + Math.random() * (high - low);
		}
		
		static private function setBetween(num:int, low:Number, high:Number = 0, round:Number = 1):Vector.<Number>{
			var list:Vector.<Number> = new <Number>[];
			for (var i:int = 0; i < num; i++) 
				list.push(between(low, high, round));
			return list;
		}
		
		static public function bool(chance:Number = .5):Boolean { return Math.random() < chance; }
		
		static public function index(array:Object):int {
			return between(array.length);
		}
		
		static public function item(array:Object):Object {
			return array[between(array.length)];
		}
		
		static public function point(x:Number, y:Number, width:Number, height:Number):Point {
			return new Point(between(width) + x, between(height) + y);
		}
		static public function points(num:int, x:Number, y:Number, width:Number, height:Number):Vector.<Point> {
			var list:Vector.<Point> = new <Point>[];
			for (var i:int = 0; i < num; i++) 
				list.push(point(x, y, width, height));
			return list;
		}
	}

}