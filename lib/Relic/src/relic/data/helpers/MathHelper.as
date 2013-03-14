package relic.data.helpers {
	/**
	 * ...
	 * @author George
	 */
	public class MathHelper {
		
		static public function roundTo(value:Number, interval:Number, func:String = "round"):Number {
			return Math[func](value / interval) * interval;
		}
		
	}

}