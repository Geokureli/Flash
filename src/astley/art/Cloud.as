package astley.art {
	import astley.data.LevelData;
	import krakel.helpers.Random;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Cloud extends FlxSprite {
		
		[Embed(source = "../../../res/astley/graphics/cloud.png")] static private const SPRITE:Class;
		
		static public const MIN_SPREAD:int = 4 * LevelData.TILE_SIZE;
		static public const MAX_SPREAD:int = 8 * LevelData.TILE_SIZE;
		
		static private const MAX:int = 4 * LevelData.TILE_SIZE;
		static private const MIN:int = -1 * LevelData.TILE_SIZE;
		
		public function Cloud(x:int) {
			super(x, Random.between(MIN, MAX, LevelData.TILE_SIZE), SPRITE);
			
			scrollFactor.x = .5;
		}
		
	}

}