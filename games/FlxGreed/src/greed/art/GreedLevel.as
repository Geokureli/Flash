package greed.art {
	import krakel.KrkLevel;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class GreedLevel extends KrkLevel {
		
		public var coins:FlxGroup;
		
		public function GreedLevel(levelData:XML, csv:Class=null, tiles:Class=null) {
			super(levelData, csv, tiles);
		}
		override protected function createTileMap(mapData:XML):FlxTilemap {
			var map:FlxTilemap = super.createTileMap(mapData);
			map.setTileProperties(17, FlxObject.CEILING)
			return map;
		}
	}

}