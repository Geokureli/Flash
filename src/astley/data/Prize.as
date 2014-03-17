package astley.data {
	import astley.art.Tilemap;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class Prize {
		
		static public const NONE:String = "none";
		static public const BRONZE:String = "bronze";
		static public const SILVER:String = "silver";
		static public const GOLD:String = "gold";
		static public const PLATINUM:String = "platinum";
		
		
		static private const TIERS:Vector.<String> = new <String> [
			NONE, BRONZE, SILVER, GOLD, PLATINUM
		];
		
		static private const POWERS:Number = Math.pow(Math.E, TIERS.length - 1);
		static public const NUM_TIERS:int = TIERS.length;
		
		static public function getPrize(score:int):String {
			
			var percent:Number = Tilemap.getCompletion(score);
			if (int(percent * POWERS) == 0) return TIERS[0];
			if (percent >= 1) return TIERS[TIERS.length - 1];
			
			return TIERS[int(Math.log(int(percent * POWERS)))];
		}
		
	}

}