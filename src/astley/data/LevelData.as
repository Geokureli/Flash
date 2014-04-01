package astley.data {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class LevelData {
		
		static public const TILE_SIZE:int = 16;
		static public const ROWS:int = FlxG.height / TILE_SIZE;
		static public const COLUMNS:int = FlxG.width / TILE_SIZE;
		static public const FLOOR_BUFFER:int = 2;
		static public const FLOOR_HEIGHT:int = FLOOR_BUFFER * TILE_SIZE;
		static public const SKY_ROWS:int = ROWS - FLOOR_BUFFER;
		static public const SKY_HEIGHT:int = FlxG.height - FLOOR_HEIGHT;
		
		static public const PIPES:Vector.<int> = new <int>[];
		
		static public const SCORE_BOARD_ID:String = "Gassy_Rick_Astley";
		
	}
}