package astley.art {
	import astley.data.LevelData;
	import flash.display.MovieClip;
	import krakel.helpers.Random;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class Tilemap extends FlxTilemap {
		
		static public const PIPE_INTERVAL:int = 6;
		static public const PIPE_START:int = 12;
		
		static public var addPipes:Boolean = true;
		
		[Embed(source = "../../../res/astley/graphics/tiles_0.png")] static private const TILES:Class;
		
		static private const CLOUD_STAMP:Array = [[1, 2], [3, 4]];
		static private const PIPE_FRAME:int = 3;
		static private const PIPE_STAMP:Array =[[4 + PIPE_FRAME, 5 + PIPE_FRAME], [0 + PIPE_FRAME, 1 + PIPE_FRAME]];
		static private const PIPE_SHAFT:Array = [2 + PIPE_FRAME, 3 + PIPE_FRAME];
		static private const PIPE_BASE:Array = [6 + PIPE_FRAME, 7 + PIPE_FRAME];
		static private const PIPE_GAP:int = 4;
		static private const PIPE_MIN:int = 2;
		static private const FLOOR_FRAME:int = PIPE_FRAME-2;
		static private const GROUND_FRAME:int = PIPE_FRAME-1;
		
		static private function STATIC_INIT():void {
			
			var last:Array = PIPE_STAMP.pop();
			for (var i:int = 0; i < PIPE_GAP; i++)
			{
				PIPE_STAMP.push([0, 0]);
			}
			
			PIPE_STAMP.push(last);
		}
		
		private var _isReplay:Boolean;
		
		public function Tilemap(isReplay:Boolean = false) {
			super();
			
			_isReplay = isReplay;
			
			loadMap(
				
				generateTileData(),
				TILES,
				LevelData.TILE_SIZE,
				LevelData.TILE_SIZE,
				OFF,
				0,
				1,
				GROUND_FRAME
			);
		}
		
		private function generateTileData():String {
			
			var columns:int = int(FlxG.camera.bounds.width / LevelData.TILE_SIZE);
			var rows:int = LevelData.ROWS;
			
			var data:Array = [];
			var tile:int;
			var row:Array;
			for (var i:int = 0; i < rows; i++) {
				
				tile = 0;
				if (i == rows - LevelData.FLOOR_BUFFER - 1)
					tile = 0;// FLOOR_FRAME;
				else if (i >= rows - LevelData.FLOOR_BUFFER)
					tile = GROUND_FRAME;
				
				row = [];
				for (var j:int = 0; j < columns; j++) {
					
					row.push(tile);
				}
				data.push(row);
			}
			
			if(addPipes) createPipes(data, columns);
			
			var map:String = "";
			while (data.length > 0) {
				
				map += data.shift().join(',') + '\n';
			}
			
			return map.substr(0, map.length - 1);
		}
		
		private function createPipes(data:Array, columns:int):void {
			
			var x:int = PIPE_START;
			do {
				
				stampPipe(x, data);
				x += PIPE_INTERVAL;
				
			} while (x < columns);
		}
		
		private function stampImage(x:int, y:int, data:Array, stamp:Array):void {
			
			for (var i:int = 0; i < stamp[0].length; i++) {
				
				for (var j:int = 0; j < stamp.length; j++) {
					
					data[j + y][i + x] = stamp[j][i];
				}
			}
		}
		
		private function stampCloud(x:int, data:Array):void {
			
			stampImage(x, Random.between(y), data, CLOUD_STAMP);
		}
		
		public function stampPipe(x:int, data:Array):void {
			var y:int
			
			if (_isReplay) {
				
				y = LevelData.PIPES[(x - PIPE_START) / PIPE_INTERVAL];
			}
			else {
				
				y = Random.between(PIPE_MIN, FlxG.height / LevelData.TILE_SIZE - PIPE_MIN - PIPE_GAP - LevelData.FLOOR_BUFFER);
				LevelData.PIPES.push(y);
			}
			var stamp:Array = PIPE_STAMP.concat();
			
			while (y > 0) {
				stamp.unshift(PIPE_SHAFT);
				y--;
			}
			
			while (stamp.length < data.length - LevelData.FLOOR_BUFFER)
			{
				stamp.push(PIPE_SHAFT);
			}
			//stamp.push(PIPE_BASE);
			
			stampImage(x, y, data, stamp);
		}
		
		static public function getScore(distance:int):int {
			
			return 1 + (distance / LevelData.TILE_SIZE - PIPE_START) / PIPE_INTERVAL
		}
		
		static public function getCompletion(score:int):Number {
			
			trace(score, getScore(FlxG.camera.bounds.width), score / getScore(FlxG.camera.bounds.width));
			return score / getScore(FlxG.camera.bounds.width);
		}
		
		{ STATIC_INIT(); }
	}
}