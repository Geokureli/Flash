package rawr {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author George
	 */
	public class BorderMaker extends BitmapData {
		private var tileWidth:int,
					tileHeight:int,
					borderSize:int;
		
		public var tiles:Vector.<Vector.<Boolean>>,
					cols:Vector.<Vector.<Boolean>>,
					rows:Vector.<Vector.<Boolean>>;
		
		public function BorderMaker(tileWidth:int, tileHeight:int, borderSize:int, arr:Vector.<Vector.<Boolean>>) {
			super(tileWidth * arr[0].length + borderSize, tileHeight * arr.length + borderSize, true, 0);
			this.borderSize = borderSize;
			
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			tiles = arr;
			
			cols = new <Vector.<Boolean>>[];
			// --- INIT TOP/BOTTOM SIDES
			for (var i:int = 0; i <= tiles.length; i++) {
				
				cols.push(new <Boolean>[]);
				
				for (var j:int = 0; j <= tiles[0].length; j++)
					cols[i].push(false);
			}
			
			rows = new <Vector.<Boolean>>[];
			// --- INIT LEFT/RIGHT SIDES
			for (i = 0; i <= tiles.length; i++) {
				
				rows.push(new <Boolean>[]);
				
				for (j = 0; j <= tiles[0].length; j++)
					rows[i].push(false);
			}
			// --- SET BORDERS
			for (i = 0; i < tiles.length; i++) {
				for (j = 0; j < tiles[i].length; j++) {
					
					if (tiles[i][j]) {
						
						cols[i][j] = !cols[i][j];			// --- LEFT
						cols[i][j + 1] = !cols[i][j + 1];	// --- RIGHT
						
						rows[i][j] = !rows[i][j];			// --- TOP
						rows[i+1][j] = !rows[i+1][j];		// --- BOTTOM
					}
				}
			}
			drawBorders();
		}
		
		public function drawBorders():void {
			var rect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			// --- DRAW TILES
			for (var i:int = 0; i < tiles.length; i++) {
				for (var j:int = 0; j < tiles[i].length; j++) {
					if (tiles[i][j]) fillRect(rect, 0xFFFFFFFF);
					rect.x += tileWidth;
				}
				rect.y += tileHeight;
				rect.x = 0;
			}
			
			var edge:Rectangle = new Rectangle(0, 0, borderSize, tileHeight + borderSize);
			// --- DRAW LEFT/RIGHT BORDERS
			for (i = 0; i < cols.length; i++) {
				for (j = 0; j < cols[i].length; j++) {
					if (cols[i][j]) fillRect(edge, 0xFF000000);
					edge.x += tileWidth;
				}
				edge.y += tileHeight;
				edge.x = 0;
			}
			
			// --- DRAW LEFT/RIGHT BORDERS
			edge = new Rectangle(0, 0, tileWidth, borderSize);
			for (i = 0; i < rows.length; i++) {
				for (j = 0; j < rows[i].length; j++) {
					if (rows[i][j]) fillRect(edge, 0xFF000000);
					edge.x += tileWidth;
				}
				edge.y += tileHeight;
				edge.x = 0;
			}
			
		}
		
		static public function getRandomTiles(cols:int, rows:int):Vector.<Vector.<Boolean>> {
			var tiles:Vector.<Vector.<Boolean>> = new <Vector.<Boolean>>[];
			
			for (var i:int = 0; i < rows; i++) {
				
				tiles.push(new <Boolean>[]);
				
				for (var j:int = 0; j < cols; j++)
					tiles[i].push(Math.random() > .5);
			}
			return tiles;
		}
		
	}

}