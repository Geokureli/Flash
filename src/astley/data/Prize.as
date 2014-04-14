package astley.data {
	import astley.art.Tilemap;
	import com.newgrounds.API;
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
		
		static public const GOALS:Vector.<Number>  = new <Number> [
			1.5, 8, 20, 51, 131
			//1, 2, 3, 4, 5
		];
		
		static public const ACHIEVEMENTS:Vector.<String>  = new <String> [
			"You move me",
			"Never gonna let you down",
			"Poop sensation",
			"Does this game even end?",
			"Topping the charts"
		];
		
		static public function unlockMedal(name:String):void {
			if (API.getMedal(name).unlocked)
				return;
			
			API.unlockMedal(name);
		}
		
		static public const CREDIT_MEDAL:String = "That's me!";
		static public const CONTINUE_MEDAL:String = "Never gonna give you up";
		
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