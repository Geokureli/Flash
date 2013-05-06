package greed.states {
	import greed.art.Gold;
	import greed.art.GreedLevel;
	import greed.art.Hero;
	import krakel.KrkGameState;
	import krakel.KrkLevel;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkGameState {
		
		[Embed(source = "../../../res/levels/testLevel/main.csv", mimeType = "application/octet-stream")] static private const LEVEL_CSV:Class;
		[Embed(source = "../../../res/levels/testLevel/Level_main.xml", mimeType = "application/octet-stream")] static private const LEVEL_XML:Class;
		[Embed(source = "../../../res/graphics/testTile.png")] static private const TILES:Class;
		
		
		static public const DEFAULT_REFS:Object = {X:1, ' ':0};
		private var hero:Hero;
		private var level:GreedLevel;
		
		override public function create():void {
			super.create();
			FlxG.bgColor = 0xFFFFFFFF;
		}
		override protected function addBG():void {
			super.addBG();
			
			add(level = new GreedLevel(new XML(new LEVEL_XML()), LEVEL_CSV, TILES));
			
			FlxG.visualDebug = true;
			
			FlxG.worldBounds.width = level.width;
			
			FlxG.worldBounds.height = level.height;
			
			FlxG.camera.bounds = new FlxRect(0, 0, level.width, level.height);
			
		}
		override protected function addMG():void {
			super.addMG();
			add(hero = new Hero(16, FlxG.height-24));
			FlxG.camera.follow(hero);
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(hero, level.map);
			FlxG.overlap(hero, level.coins, hitCoin);
		}
		
		private function hitCoin(hero:Hero, gold:Gold):void {
			gold.kill();
		}
		
		override public function destroy():void {
			super.destroy();
			
		}
		protected function createMap(map:String, refs:Object = null):String {
			if (refs == null) refs = DEFAULT_REFS;
			
			map = map.split("").join(',').split(",\n,").join('\n');
			
			for (var i:String in refs)
				map = map.split(i).join(refs[i].toString());
			
			return map;
		}
	}

}