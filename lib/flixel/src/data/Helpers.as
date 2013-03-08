package data {
	/**
	 * ...
	 * @author George
	 */
	public class Helpers {
		//public function Helpers() {}
		
		static public function random(low:Number, high:Number = 0, interval:Number = 1):Number {
			if (high < low) return random(high, low, interval);
			if (interval == 0) return low + Math.random() * (high - low);
			if (interval == 1) return int(low + Math.random() * (high - low));
			return round(low + Math.random() * (high - low), interval);
		}
		static public function round(num:Number, interval:Number):Number {
			return int(num * interval)/interval;
		}
	}
}