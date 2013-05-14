package krakel {
	import greed.art.Gold;
	import krakel.helpers.StringHelper;
	import krakel.xml.XMLParser;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkLevel extends FlxGroup {
		
		static public const CLASS_REFS:Object = { KrkSprite:KrkSprite, text:KrkText };
		public var width:int, height:int;
		
		public var map:KrkTilemap;
		
		public var resetGroup:FlxGroup,
					solidGroup:FlxGroup,
					overlapGroup:FlxGroup;
		
		private var levelData:XML;
		private var csv:Class;
		private var tiles:Class;
		protected var bounds:FlxRect;
		protected var groups:Object;
		
		protected var hud:HUD;
		
		public function KrkLevel(levelData:XML, csv:Class = null, tiles:Class = null) {
			super();
			this.levelData = levelData;
			this.csv = csv;
			this.tiles = tiles;
			
			groups = { };
			resetGroup = new FlxGroup();
			solidGroup = new FlxGroup();
			overlapGroup = new FlxGroup();
			
			width = height = 0;
			
			for each (var layer:XML in levelData.layer)
				createLayer(layer);
			
			addHUD();
		}
		
		
		protected function createLayer(layer:XML):void {
			if (layer.@type == "bounds") {
				bounds = new FlxRect();
			}
			if (layer.sprite.length() > 0 || layer.shape.length() > 0) {
				var group:FlxGroup = new FlxGroup();
				
				for each (var node:XML in layer.sprite)
					group.add(parseSprite(node));
				
				for each (node in layer.shape) {
					if(node.@type == "text")
					group.add(parseText(node));
				}
				//if (layer.@name.toString() in this)
					//this[layer.@name.toString()] = group;
				
				add(group);
			}
			
				
			for each (node in layer.map)
				solidGroup.add(add(map = createTileMap(node)));
		}
		
		protected function parseSprite(node:XML):FlxSprite {
			node = node.copy();
			var sprite:FlxSprite = new CLASS_REFS[node["@type"].toString()]();
			if ("@group" in node) {
				setGroup(sprite, node.@group.toString());
				delete node.@group;
			}
			if (node.@resets.toString() == "true") {
				resetGroup.add(sprite);
				delete node.@resets;
			}
			if (node.@solid.toString() == "true") {
				solidGroup.add(sprite);
				delete node.@solid;
			}
			if (node.@callback.toString() == "true") {
				overlapGroup.add(sprite);
				delete node.@callback;
			}
			
			if ("@group" in node) {
				setGroup(sprite, node.@group.toString())
				delete node.@group;
			}
			
			if (Number(node.@xScale) == 1)
				delete node.@xScale;
			
			if (Number(node.@yScale) == 1)
				delete node.@yScale;
			
			if (sprite is KrkSprite)
				(sprite as KrkSprite).setParameters(node);
			else XMLParser.setProperties(sprite, node);
			
			return sprite;
		}
		private function parseText(node:XML):FlxText {
			var txt:FlxText = new FlxText(
				Number(node.@x),
				Number(node.@y),
				Number(node.@width),
				node.@text.toString()
			);
			txt.alignment = node.@align.toString()
			return txt;
		}
		private function setGroup(sprite:FlxSprite, group:String):void {
			if (!(group in groups)) groups[group] = new FlxGroup();
			groups[group].add(sprite);
		}
		
		protected function createTileMap(mapData:XML):KrkTilemap {
			
			if (csv == null) {
				// --- LOAD SHIT
			}
			
			if (tiles == null) {
				// --- LOAD SHIT
			}
			
			var map:KrkTilemap = new KrkTilemap(mapData, new csv(), tiles);
			
			if (map.width > width) width = map.width;
			if (map.height > height) height = map.height;
			return map;
		}
		
		
		protected function addHUD():void { add(hud = new HUD()); }
		
		protected function reset():void {
			
			for each(var obj:FlxObject in resetGroup.members)
				if (obj != null) obj.revive();
			
		}
		
		override public function destroy():void {
			super.destroy();
			
			map = null;
		
			levelData = null;
			csv = null;
			tiles = null;
		}
		
		public function get cloudsEnabled():Boolean { return map.cloudsEnabled; }
		public function set cloudsEnabled(value:Boolean):void {
			map.cloudsEnabled = value;
		}
	}

}