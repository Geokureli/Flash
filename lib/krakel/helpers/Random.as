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
			if (round > 0)
				return int(low + Math.random() * (high - low) / round) * round;
			return low + Math.random() * (high - low);
		}
		
		static public function bool(chance:Number = .5):Boolean { return Math.random() < chance; }
		
		static public function randomIndex(array:Object):int {
			return between(array.length);
		}
		
		static public function randomPoint(rect:Rectangle):Point {
			return new Point(between(rect.width) + rect.x, between(rect.height) + rect.y);
		}
	}

}