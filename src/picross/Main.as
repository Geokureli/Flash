package picross {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite {
		
		private var _bitmap:Bitmap;
		
		public function Main() {
			super();
			
			var rowData:Vector.<Vector.<uint>> = new <Vector.<uint>> [
				new <uint> [7],					// 1
				new <uint> [2, 2],              // 2
				new <uint> [1, 1],              // 3
				new <uint> [1, 1, 1, 1],        // 4
				new <uint> [1, 1],              // 5
				new <uint> [2, 3, 2],           // 6
				new <uint> [4, 4],              // 7
				new <uint> [2, 7, 2],           // 8
				new <uint> [1, 1],              // 9
				new <uint> [1, 1],              // 10
				new <uint> [1, 1],              // 11
				new <uint> [1, 1],              // 12
				new <uint> [2, 2],              // 13
				new <uint> [2, 2],              // 14
				new <uint> [11]                 // 15
			];
			
			var columnData:Vector.<Vector.<uint>> = new <Vector.<uint>> [
				new <uint> [6],					// 1
				new <uint> [2, 2],              // 2
				new <uint> [2, 2],              // 3
				new <uint> [6, 1],              // 4
				new <uint> [2, 2, 1],           // 5
				new <uint> [1, 1, 1],           // 6
				new <uint> [1, 1, 1, 1, 1],     // 7
				new <uint> [1, 1, 1, 1],        // 8
				new <uint> [1, 1, 1, 1, 1],     // 9
				new <uint> [1, 1, 1],           // 10
				new <uint> [1, 2, 2],           // 11
				new <uint> [1, 6],              // 12
				new <uint> [2, 2],              // 13
				new <uint> [2, 2],              // 14
				new <uint> [6]                  // 15
			];
			
			_bitmap = new Bitmap(new Pic(rowData, columnData));
			addChild(_bitmap);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (stage.stageWidth < stage.stageHeight) {
				
				_bitmap.width =  stage.stageWidth;
				_bitmap.height = stage.stageWidth;
				_bitmap.x = (stage.stageHeight - stage.stageWidth) / 2;
			} else {
				
				_bitmap.width =  stage.stageHeight;
				_bitmap.height = stage.stageHeight;
				_bitmap.x = (stage.stageWidth - stage.stageHeight) / 2;
			}
			
		}
		
	}

}