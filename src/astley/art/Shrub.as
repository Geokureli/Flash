package astley.art {
	import astley.data.LevelData;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Shrub extends FlxSprite {
		
		[Embed(source = "../../../res/astley/graphics/shrub.png")] static private const SPRITE:Class;
		
		static public const DEFAULT_Y:int = LevelData.SKY_HEIGHT - LevelData.TILE_SIZE;
		static public const MIN_SPREAD:int = 4 * LevelData.TILE_SIZE;
		static public const MAX_SPREAD:int = 16 * LevelData.TILE_SIZE;
		
		public function Shrub(x:int) { super(x, DEFAULT_Y, SPRITE); }
		
	}

}