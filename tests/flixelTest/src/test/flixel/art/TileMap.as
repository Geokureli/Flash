package test.flixel.art {
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	import test.flixel.Imports;
	
	/**
	 * ...
	 * @author George
	 */
	public class TileMap extends FlxTilemap {
		
		static public const TILES:FlxPoint = new FlxPoint(128, 36);
		
		public var tileSize:FlxPoint;
		public function TileMap() {
			super();
			var level:String = "";
			for (var i:int = 0; i < TILES.y; i++){
				for (var j:int = 0; j < TILES.x; j++)
					level += (j == 0 || i == 0 || j == TILES.x-1 || i == TILES.y-1 ? '1' : '0') + (j == TILES.x-1 ? "" : ',');
				if (i < TILES.y-1) level += '\n';
			}
			loadMap(
				level,
				Imports.TILES//,
				//0,
				//0,
				//FlxTilemap.AUTO
			);
			tileSize = new FlxPoint(width / widthInTiles, height / heightInTiles);
			setTileProperties(3, UP);
			setTileProperties(2, 0x1111, onKillTile, Hero);
		}
		
		private function onKillTile(tile:FlxTile, hero:Hero):void {
			hero.x = hero.y = 50;
		}
		override protected function autoTile(Index:uint):void
		{
			if(_data[Index] == 0)
				return;
			
			_data[Index] = 0;
			if((Index-widthInTiles < 0) || (_data[Index-widthInTiles] > 0)) 		//UP
				_data[Index] += 1;
			if((Index%widthInTiles >= widthInTiles-1) || (_data[Index+1] > 0)) 		//RIGHT
				_data[Index] += 2;
			if((Index+widthInTiles >= totalTiles) || (_data[Index+widthInTiles] > 0)) //DOWN
				_data[Index] += 4;
			if((Index%widthInTiles <= 0) || (_data[Index-1] > 0)) 					//LEFT
				_data[Index] += 8;
			if((auto == ALT) && (_data[Index] == 15))	//The alternate algo checks for interior corners
			{
				if((Index%widthInTiles > 0) && (Index+widthInTiles < totalTiles) && (_data[Index+widthInTiles-1] <= 0))
					_data[Index] = 1;		//BOTTOM LEFT OPEN
				if((Index%widthInTiles > 0) && (Index-widthInTiles >= 0) && (_data[Index-widthInTiles-1] <= 0))
					_data[Index] = 2;		//TOP LEFT OPEN
				if((Index%widthInTiles < widthInTiles-1) && (Index-widthInTiles >= 0) && (_data[Index-widthInTiles+1] <= 0))
					_data[Index] = 4;		//TOP RIGHT OPEN
				if((Index%widthInTiles < widthInTiles-1) && (Index+widthInTiles < totalTiles) && (_data[Index+widthInTiles+1] <= 0))
					_data[Index] = 8; 		//BOTTOM RIGHT OPEN
			}
			_data[Index] += 1;
		}
		
	}

}