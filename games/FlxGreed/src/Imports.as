package  {
	import greed.levels.GreedLevel;
	import greed.levels.ChoiceLevel;
	import greed.levels.HellLevel;
	import krakel.KrkGraphic;
	import krakel.KrkSprite;
	/**
	 * ...
	 * @author George
	 */
	public class Imports {
		
		[Embed(source="../res/levels/maps/level0.csv",mimeType="application/octet-stream")]	static private const LEVEL0_CSV:Class;
		[Embed(source="../res/levels/level0.xml",mimeType="application/octet-stream")]		static private const LEVEL0_XML:Class;
		
		[Embed(source="../res/levels/maps/level1.csv",mimeType="application/octet-stream")]	static private const LEVEL1_CSV:Class;
		[Embed(source="../res/levels/level1.xml",mimeType="application/octet-stream")]		static private const LEVEL1_XML:Class;
		
		[Embed(source="../res/levels/maps/level2.csv",mimeType="application/octet-stream")]	static private const LEVEL2_CSV:Class;
		[Embed(source="../res/levels/level2.xml",mimeType = "application/octet-stream")]	static private const LEVEL2_XML:Class;
		
		[Embed(source="../res/levels/maps/testLevel.csv",mimeType="application/octet-stream")]	static private const TEST_CSV:Class;
		[Embed(source="../res/levels/testLevel.xml",mimeType = "application/octet-stream")]	static private const TEST_XML:Class;
		
		[Embed(source = "../res/graphics/hold.png")] static public const HOLD:Class;
		[Embed(source = "../res/graphics/arrows.png")] static public const ARROWS:Class;
		[Embed(source = "../res/graphics/buttonsign.png")] static public const SIGN_BUTTON:Class;
		[Embed(source = "../res/graphics/beam.png")] static public const BEAM:Class;
		
		static public const levels:Object = {
			0:new <Class>[LEVEL0_XML, LEVEL0_CSV],
			1:new <Class>[LEVEL1_XML, LEVEL1_CSV],
			2:new <Class>[LEVEL2_XML, LEVEL2_CSV]
			// --- TEST LEVEL
			//,test:new <Class>[TEST_XML, TEST_CSV]
		}
		
		{
			KrkSprite.GRAPHICS.sign_button = new KrkGraphic(SIGN_BUTTON);
			KrkSprite.GRAPHICS.hold = new KrkGraphic(HOLD);
			KrkSprite.GRAPHICS.beam = new KrkGraphic(BEAM);
			KrkSprite.GRAPHICS.arrow = new KrkGraphic(ARROWS, true, false, 0, 0,
				{
					up:[0],
					down:[1],
					left:[2],
					right:[3]
				}
			);
		}
		
		static public function getLevel(id:String, hell:Boolean = true):GreedLevel {
			if ("test" in levels) id = "test";
			if (!(id in levels)) throw new Error("No level found with the id: " + id);
			var classes:Vector.<Class> = levels[id];
			
			var level:GreedLevel = new (hell? HellLevel : ChoiceLevel) (new XML(new classes[0]()), classes[1]);
			level.name = id;
			return level;
		}
	}

}