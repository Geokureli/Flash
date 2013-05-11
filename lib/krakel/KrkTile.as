package krakel {
	import krakel.helpers.StringHelper;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkTile extends FlxTile {
		public var type:String;
		public var scheme:KrkScheme;
		public var kills:Boolean;
		
		public function KrkTile(tile:FlxTile, data:XML) {
			super(tile.tilemap, tile.index, tile.width, tile.height, tile.visible, tile.allowCollisions);
			
			callback = tile.callback == null
				? defaultCallback
				: tile.callback;
			
			index = tile.index;
			filter = tile.filter;
			tile.destroy();
			
			data = data.copy();
			delete data.@callback;
			
			kills = data.@kills.toString() == "true";
			
			allowCollisions = FlxObject.ANY;
			if (data.@cloud == "true")
				allowCollisions = CEILING;
			else if ("@edges" in data)
				allowCollisions = StringHelper.AutoTypeString(data.@edges.toString()) as uint;
		}
		
		protected function defaultCallback(tile:KrkTile, obj:FlxSprite):void { hitObject(obj); }
		public function hitObject(obj:FlxSprite):void {
			x = (mapIndex % tilemap.widthInTiles) * width;
			y = (mapIndex / tilemap.heightInTiles) * height;
			if (kills) obj.kill();
		}
		
		protected function setIndex(index:Number):void {
			var column:uint	= mapIndex % tilemap.widthInTiles;
			var row:uint	= mapIndex / tilemap.widthInTiles;
			tilemap.setTile(column, row, 0);
		}
		
		public function get currentPos():FlxPoint {
			return new FlxPoint(
				(mapIndex % tilemap.widthInTiles) * width, 
				(mapIndex / tilemap.heightInTiles) * height
			);
		}
		
		public function get edges():uint { return allowCollisions; }
		public function set edges(value:uint):void { allowCollisions = value; }
		
		override public function destroy():void {
			super.destroy();
			type = null;
		}
		
		override public function toString():String {
			if (type == null) return super.toString();
			return "Tile: " + type;
		}
	}

}