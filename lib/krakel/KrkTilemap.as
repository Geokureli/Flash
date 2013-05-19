package krakel {
	import flash.geom.Rectangle;
	import krakel.helpers.StringHelper;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkTilemap extends FlxTilemap {
		
		static public const TILE_TYPES:Object = { };
		
		private var _cloudsEnabled:Boolean;
		
		private var clouds:Vector.<FlxTile>;
		private var special:Vector.<KrkTile>;
		
		public function KrkTilemap(mapData:XML, csv:String, tiles:Class) {
			super();
			clouds = new Vector.<FlxTile>();
			special = new Vector.<KrkTile>();
			cloudsEnabled = true;
			loadMap(
				csv,
				tiles,
				int(mapData.@tileWidth),
				int(mapData.@tileHeight),
				FlxTilemap.OFF,
				0,
				int(mapData.@collIdx),
				int(mapData.@drawIdx)
			);
			
			setParameters(mapData);
		}
		
		private function setParameters(mapData:XML):void {
			for each(var properties:XML in mapData.properties) {
				
				
				
				for each (var tileData:XML in properties.tile) {
					
					var tileId:int = int(tileData.@id);
					
					var range:int = 1;
					if("@range" in tileData)
						range = int(tileData.@range)
					
					var isCloud:Boolean = tileData.@cloud.toString() == "true";
					
					var isAdvanced:Boolean =
						tileData.@kills.toString() == "true"
						|| "@type" in tileData
						|| "@frames" in tileData
						|| "@frameTimer" in tileData;
					
					for (var i:int = 0; i < range; i++) {
						// --- STORE ALL CLOUD TILES
						if (isCloud) 
							setCloud(tileId+i);
						
						// --- REPLACE FlxTile WITH KrkTile
						if (isAdvanced) {
							var tile:KrkTile = createAdvancedTile(tileId + i, tileData);
							if(tileData.@callback.toString() == "true")
								tile.callback = hitCallback;
								
							special.push(tile);
						}
					}
					// --- SET FLXTILE PROPERTIES
					if (!isAdvanced && hasAttribute(tileData, "edges", "callback", "cloud")) {
						
						var callback:Function;
						if(tileData.@callback.toString() == "true")
							callback = hitCallback;
						
						var edges:uint = FlxObject.ANY;
						if ("@edges" in tileData)
							edges = StringHelper.AutoTypeString(tileData.@edges.toString()) as uint;
						else if (tileData.@cloud.toString() == "true")
							edges = CEILING;
						
						setTileProperties(
							tileId,
							edges,
							callback,
							null,
							range
						);
					}
					
				}
				
			}
		}
		
		protected function hitCallback(tile:FlxTile, object:KrkSprite):void {
			if (tile is KrkTile)
				(tile as KrkTile).hitObject(object);
		}
		
		protected function hasAttribute(node:XML, ...args):Boolean {
			for each (var item:String in args)
				if ('@' + item in node) return true;
			return false;
		}
		
		///** @inheritDoc */
		//override public function setTileProperties(index:uint, allowCollisions:uint = 0x1111, callback:Function = null, callbackFilter:Class = null, range:uint = 1):void {
			//if(range <= 0) range = 1;
				//
			//var tile:FlxTile;
			//var i:uint = index;
			//var l:uint = index + range;
			//while (i < l) {
				// --- REPLACE FlxTile WITH KrkTile
				//tile = _tileObjects[i] = new KrkTile(_tileObjects[i] as FlxTile);
				//i++;
				//tile.allowCollisions = allowCollisions;
				//tile.callback = callback;
				//tile.filter = callbackFilter;
			//}
		//}
		public function createAdvancedTile(index:uint, data:XML):KrkTile {
			var tile:FlxTile = _tileObjects[index];
			var type:String = "@type" in data 
				? data.@type.toString()
				: null;
			
			if (type != null && type in TILE_TYPES)
				tile = _tileObjects[index] = new TILE_TYPES[type](tile);
			else 
				tile = _tileObjects[index] = new KrkTile(tile);
				
			(tile as KrkTile).setParameters(data);
			
			return tile as KrkTile;
		}
		
		public function getTileData(index:uint):FlxTile {
			return _tileObjects[index];
		}
		
		public function setCloud(index:uint):void { clouds.push(_tileObjects[index]); }
		
		override public function revive():void {
			super.revive();
			for each(var tile:KrkTile in special)
				tile.revive();
		}
		
		override public function destroy():void {
			super.destroy();
			clouds = null;
		}
		
		public function get cloudsEnabled():Boolean { return _cloudsEnabled; }
		public function set cloudsEnabled(value:Boolean):void {
			if (_cloudsEnabled == value) return;
			
			_cloudsEnabled = value;
			
			if (clouds.length == 0) return;
			
			for each (var tile:FlxTile in clouds) 
				tile.allowCollisions = value ? FlxObject.CEILING : FlxObject.NONE;
		}
	}

}