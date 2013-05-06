package krakel {
	import greed.art.Gold;
	import krakel.helpers.StringHelper;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkLevel extends FlxGroup {
		
		static public const CLASS_REFS:Object = { coin: Gold };
		public var width:int, height:int;
		
		public var map:FlxTilemap;
		
		private var levelData:XML;
		private var csv:Class;
		private var tiles:Class;
		
		public function KrkLevel(levelData:XML, csv:Class = null, tiles:Class = null) {
			super();
			this.levelData = levelData;
			this.csv = csv;
			this.tiles = tiles;
			
			width = height = 0;
			
			for each (var layer:XML in levelData.layer)
				createLayer(layer);
			
		}
		
		protected function createLayer(layer:XML):void {
			if (layer.sprite.length() > 0) {
				var group:FlxGroup = new FlxGroup();
				
				for each (var node:XML in layer.sprite)
					group.add(parseSprite(node));
				
				if (layer.@name.toString() in this)
					this[layer.@name.toString()] = group;
				
				add(group);
			}
			
				
			for each (node in layer.map)
				add(map = createTileMap(node));
		}
		
		private function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = new CLASS_REFS[node["@class"].toString()]();
			
			for each(var att:XML in node.attributes()) {
				
				var attName:String = att.name().toString();
				
				if(attName in sprite)
					sprite[attName] = StringHelper.AutoTypeString(att.toString());
			}
			trace(sprite.x, sprite.y);
			return sprite;
		}
		
		protected function createTileMap(mapData:XML):FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (csv == null) {
				
			} else {
				if (tiles == null) {
					
				} else {
					map.loadMap(
						new csv(),
						tiles,
						int(mapData.@tileWidth),
						int(mapData.@tileHeight)
					);
				}
			}
			if (map.width > width) width = map.width;
			if (map.height > height) height = map.height;
			return map;
		}
		
	}

}