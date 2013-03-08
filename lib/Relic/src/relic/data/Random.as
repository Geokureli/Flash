package relic.data 
{
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
	}

}