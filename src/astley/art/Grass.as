package astley.art {
	import astley.data.LevelData;
	import krakel.art.KrkRepeatingTile;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class Grass extends KrkRepeatingTile{
		
		[Embed(source = "../../../res/astley/graphics/floor_top.png")] static public const SPRITE:Class;
		
		public function Grass() {
			super(0, LevelData.SKY_HEIGHT - 3, SPRITE, -1);
		}
		
	}

}