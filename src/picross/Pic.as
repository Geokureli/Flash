package picross {
	import flash.display.BitmapData;
	import picross.data.TileGroup;
	/**
	 * ...
	 * @author George
	 */
	public class Pic extends BitmapData {
		
		private var columnData:Vector.<TileGroup>;
		private var rowData:Vector.<TileGroup>;
		private var columns:uint;
		private var rows:uint;
		
		private var _allTiles:Vector.<Tile>;
		
		public function Pic(rowData:Vector.<Vector.<uint>>, columnData:Vector.<Vector.<uint>>) {
			this.rowData = new <TileGroup>[];
			this.columnData = new <TileGroup>[];
			
			rows = rowData.length;
			columns = columnData.length;
			
			super(columns, rows, false);
			
			while (rowData.length > 0)
				this.rowData.push(TileGroup.create(rowData.shift()));
				
			while (columnData.length > 0)
				this.columnData.push(TileGroup.create(columnData.shift()));
			
			_allTiles = new <Tile> [];
			for (var i:int = 0; i < columns; i++) {
				
				for (var j:int = 0; j < rows; j++) {
					
					_allTiles.push(new Tile(j, i));
				}
			}
			
			solve();
		}
		
		private function solve():void {
			var hadProgress:Boolean;
			do {
				hadProgress = startColumnPass() || startRowPass();
				
				reDraw();
				
			} while(hadProgress && !isSolved())
		}
		
		private function startColumnPass():void {
			
			for (var i:int = 0; i < columns; i++) {
				
				solveColumn(i);
			}
		}
		
		private function solveColumn(index:int):void {
			var line:Tile = _allTiles[index];
			var tile:Tile = line;
			
			for (var r:int = 1; r < rows; r++) {
				
				tile.next = _allTiles[r * columns + index];
				
				tile = tile.next;
			}
			
			solveLine(line, columnData[index]);
		}
		
		private function startRowPass():void {
			
			for (var i:int = 0; i < rows; i++) {
				
				solveRow(i);
			}
		}
		
		private function solveRow(index:int):void {
			var line:Tile = _allTiles[index * columns];
			var tile:Tile = line;
			
			for (var c:int = 1; c < columns; c++) {
				
				tile.next = _allTiles[index * columns + c];
				
				tile = tile.next;
			}
			
			solveLine(line, rowData[index]);
		}
		
		private function isSolved():void {
			
		}
		
		//=============================================================================
		//{region							SOLVERS
		//=============================================================================
		
		private function solveLine(tileList:Tile, dataList:TileGroup):void {
			
			if (dataList.min * 2 >= tileList.length) {
				
				if (dataList.length == 1) {
					
					var start:int = tileList.length - dataList.size;
					var length:int = dataList.size - start * 2;
					var tile:Tile = tileList;
					while (start + length >= 0) {
						
						tile = tile.next;
						
						if(start > 0)
							start--;
							
						else {
							tile.state = TileState.ON;
							
							length--;
						}
					}
				}
			}
			
			//trim(line, dataHead);
		}
		
		private function trim(line:Tile, data:Vector.<uint>):void {
			
			var i:uint;
			var length:uint;
			
			var tile:Tile = line;
			
			while (data.length > 0) {
				length = data[0];
				i = 0;
				
				var isCompleted:Boolean = true;
				
				while (tile.state != TileState.EMPTY && length > 0) {
					
					if(tile.state == TileState.ON)
						length--;
					
					tile = tile.next;
				} 
			}
		}
		
		//}	===========================================================================
		
		
		private function reDraw():void {
			
			lock();
			
			for each (var tile:Tile in _allTiles) {
				
				if (tile._dirty) {
					tile._dirty = false;
					
					setPixel(tile.x, tile.y, tile.state.color);
				}
			}
			
			unlock();
		}
	}
}