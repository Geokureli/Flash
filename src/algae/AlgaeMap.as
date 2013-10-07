package algae {
	import krakel.KrkTilemap;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTilemapBuffer;
	
	/**
	 * ...
	 * @author George
	 */
	public class AlgaeMap extends KrkTilemap {
		
		static public const GREEN_PLANT:uint = 2,
							RED_PLANT:uint = 3,
							BROWN_PLANT:uint = 4,
							GREEN_SEED:uint = 5,
							RED_SEED:uint = 6,
							BROWN_SEED:uint = 7,
							BARNACLE:uint = 10;
		
		
		public function AlgaeMap(mapData:XML) { super(mapData); }
		
		/** @inheritDoc */
		override public function loadMap(
				MapData:String,
				TileGraphic:Class,
				TileWidth:uint = 0, TileHeight:uint = 0,
				AutoTile:uint = OFF,
				StartingIndex:uint = 0, DrawIndex:uint = 1, CollideIndex:uint = 1):FlxTilemap {
			return super.loadMap(MapData, TileGraphic, TileWidth, TileHeight, AutoTile, StartingIndex, DrawIndex, CollideIndex);
		}
		
		/**
		 * Returns the index of the tile that overlaps the given world coordinate.
		 * @param	x: The horizontal coordinate
		 * @param	y: The vertical coordinate
		 * @return The overlapping tile's index.
		 */
		public function indexAtPos(x:Number, y:Number):uint {
			return uint(x / _tileWidth) + uint(y / _tileHeight) * widthInTiles;
		}
		
		/**
		 * Returns the x and y index of the current mouse position.
		 * @param	x: The horizonal world position.
		 * @param	y: The vertical world position.
		 * @param	point: an optional point to set the coordinates, if not specified, a new FlxPoint is created.
		 * @return a point with the coordinate indices.
		 */
		public function getTileIndicesAtPos(x:Number, y:Number, point:FlxPoint = null):FlxPoint {
			if (point == null)
				point = new FlxPoint();
			
			point.x = uint(x / _tileWidth);
			point.y = uint(y / _tileHeight);
			
			return point;
		}
		
		/**
		 * Returns the x and y index of the current mouse position.
		 * @param	x: The horizonal world position.
		 * @param	y: The vertical world position.
		 * @param	point: an optional point to set the coordinates, if not specified, a new FlxPoint is created.
		 * @return a point with the coordinate indices.
		 */
		public function getTileCoordsAtPos(x:Number, y:Number, center:Boolean = false, point:FlxPoint = null):FlxPoint {
			if (point == null)
				point = new FlxPoint();
			
			point.x = uint(x / _tileWidth) * _tileWidth;
			point.y = uint(y / _tileHeight) * _tileHeight;
			
			if (center) {
				point.x += _tileWidth / 2;
				point.y += _tileHeight / 2;
			}
			return point;
		}
		
		public function get tileSize():uint { return _tileWidth; }
	}

}