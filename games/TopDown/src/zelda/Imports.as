package zelda {
	import relic.art.blitting.SpriteSheet;
	/**
	 * ...
	 * @author George
	 */
	public class Imports {
		
		
		[Embed(source = "../../res/zelda.png", mimeType = "image/png")]
		static private const TILES:Class;
		
		[Embed(source = "../../res/level_0.xml", mimeType="application/octet-stream")]
		static public const Level:Class;
		
		static public var ZeldaTiles:SpriteSheet;
		
		{
			ZeldaTiles = new SpriteSheet(new TILES().bitmapData).scale(2);
			ZeldaTiles.createGrid(32)
		}
	}

}