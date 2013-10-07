package  {
	import algae.Quadrat;
	import flash.text.Font;
	import krakel.KrkGraphic;
	import krakel.KrkSprite;
	import krakel.serial.KrkImporter;
	
	/**
	 * ...
	 * @author George
	 */
	public class Imports extends KrkImporter {
		
		[Embed(source = "../res/KBPlanetEarth.ttf", fontName = "KBPlanetEarth")] static public const KBPlanetEarth:Class;
		
		[Embed(source = "../res/levels/test_0.xml", mimeType = "application/octet-stream")] static private const LEVEL0_XML:Class;
		[Embed(source = "../res/levels/levelA.xml", mimeType = "application/octet-stream")] static private const LEVEL1_XML:Class;
		
		[Embed(source = "../res/levels/maps/test_0/seaweed.csv", mimeType = "application/octet-stream")] static private const SEAWEED_0_CSV:Class;
		[Embed(source = "../res/levels/maps/levelA/seaweed.csv", mimeType="application/octet-stream")] static private const SEAWEED_1_CSV:Class;
		[Embed(source = "../res/levels/maps/test_0/height.csv", mimeType = "application/octet-stream")] static private const HEIGHT_0_CSV:Class;
		[Embed(source = "../res/levels/maps/levelA/height.csv", mimeType="application/octet-stream")] static private const HEIGHT_1_CSV:Class;
		[Embed(source = "../res/levels/maps/test_0/grow.csv", mimeType = "application/octet-stream")] static private const GROW_0_CSV:Class;
		[Embed(source = "../res/levels/maps/levelA/grow.csv", mimeType="application/octet-stream")] static private const GROW_1_CSV:Class;
		
		[Embed(source = "../res/graphics/colors.png")]static public const SEAWEED_TILES:Class;
		[Embed(source = "../res/graphics/heightUI.png")]static public const HEIGHT_TILES:Class;
		[Embed(source = "../res/graphics/toGrow.png")]static public const GROW_TILES:Class;
		
		[Embed(source = "../res/graphics/stonewall.png")] static private const STONE_WALL:Class;
		[Embed(source = "../res/graphics/water.png")] static private const WATER:Class;
		[Embed(source = "../res/graphics/counter_energy.png")] static private const COUNTER_ENERGY:Class;
		[Embed(source = "../res/graphics/counter_rounds.png")] static private const COUNTER_ROUNDS:Class;
		[Embed(source = "../res/graphics/counter_phase.png")] static private const COUNTER_PHASE:Class;
		
		[Embed(source = "../res/audio/songs/menu_theme.mp3")] static private const MENU_THEME:Class;
		
		static private const songs:Object = { };
		
		static public const levels:Object = {
			test_0:LEVEL0_XML,
			level_1:LEVEL1_XML
		}
		
		{ INIT(); }
		static private function INIT():void{
			Font.registerFont(KBPlanetEarth);
			
			graphics.bg = STONE_WALL;
			graphics.energyMeter = COUNTER_ENERGY;
			graphics.phaseReadout = COUNTER_PHASE;
			graphics.roundMeter = COUNTER_ROUNDS;
			graphics.colors = SEAWEED_TILES;
			graphics.water = WATER;
			
			maps.levelA = {seaweed:SEAWEED_1_CSV};
		}
		
		static public function getLevel(id:String):Quadrat{
			if ("test" in levels) id = "test";
			if (!(id in levels)) throw new Error("No level found with the id: " + id);
			
			var level:Quadrat = new Quadrat();
			level.setParameters(new XML(new (levels[id])()));
			//level.name = id;
			return level;
		}
		
	}

}