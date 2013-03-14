package relic.data 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class Random 
	{
		static public function random(low:Number, high:Number = 0, round:Number = 1):Number {
			if (round > 0)
				return int(low + Math.random() * (high - low) / round) * round;
			return low + Math.random() * (high - low);
		}
		static public function randomIndex(array:Object):int {
			return random(array.length);
		}
		
		static public function randomPoint(rect:Rectangle):Point {
			return new Point(random(rect.width) + rect.x, random(rect.height) + rect.y);
		}
		
		static public function randomVec2(rect:Rectangle):Vec2 {
			return new Vec2(random(rect.width) + rect.x, random(rect.height) + rect.y);
		}
	}

}