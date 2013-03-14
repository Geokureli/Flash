package relic.data.helpers {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class BitmapHelper {
		
		static public function clearBG(graphic:BitmapData, color:int = -1):void {
			// --- IF NO COLOR PROVIDED REMOVE COLOR OF TOP-LEFT PIXEL
			if (color == -1) color = graphic.getPixel32(0, 0);
			graphic.threshold(graphic, graphic.rect, new Point(), "==", color, 0, 0xFFFFFFFF, true);
		}
		
		static public function apply9Grid(src:BitmapData, grid:Rectangle, width:int, height:int):BitmapData {
			return apply9GridTo(src, grid, new BitmapData(width, height));
		}
		
		static public function apply9GridTo(src:BitmapData, grid:Rectangle, target:BitmapData):BitmapData {
			
			// --- TOP LEFT
			var rect:Rectangle = new Rectangle(0, 0, grid.x, grid.y);
			var p:Point = new Point();
			target.copyPixels(src, rect, p);
			
			// --- TOP RIGHT
			rect.x = grid.right;
			rect.width = src.width - grid.right;
			p.x = target.width - rect.width;
			target.copyPixels(src, rect, p);
			
			// --- BOTTOM RIGHT
			rect.y = grid.bottom;
			rect.height = src.height - grid.bottom;
			p.y = target.height - rect.height;
			target.copyPixels(src, rect, p);
			
			// --- BOTTOM RIGHT
			rect.x = 0;
			rect.width = grid.left;
			p.x = 0;
			target.copyPixels(src, rect, p);
			
			// --- TOP AND BOTTOM
			rect.size = new Point(grid.width, grid.y);
			rect.x = grid.x;
			rect.y = 0;
			p.y = 0;
			
			var rect2:Rectangle = new Rectangle(grid.x, grid.bottom, grid.width, src.height - grid.bottom);// --- BOTTOM
			var p2:Point = new Point(grid.x, target.height - rect2.height);
			
			for (p.x = grid.x; p.x <= target.width - src.width + grid.x; p.x += grid.width) {
				target.copyPixels(src, rect, p);	// --- TOP
				target.copyPixels(src, rect2, p2);	// --- BOTTOM
				p2.x++;
			}
			
			// --- LEFT AND RIGHT
			rect.x = 0;			rect.width = grid.x;
			rect.y = grid.y;	rect.height = grid.height;
			p.x = 0;
			
			rect2.width = src.width - grid.right;
			rect2.x = grid.right;
			rect2.y = grid.y;	rect2.height = grid.height
			p2.x = target.width - rect2.width;
			p2.y = grid.y
			
			for (p.y = grid.y; p.y <= target.height - src.height + grid.y; p.y += grid.height) {
				target.copyPixels(src, rect, p);	// --- TOP
				target.copyPixels(src, rect2, p2);	// --- BOTTOM
				p2.y++;
			}
			
			if (grid.width * grid.height == 1) {// --- 1 PIXEL CENTER
				rect.x = grid.x;
				rect.y = grid.y;
				rect.width = target.width - src.width + grid.width;
				rect.height = target.height - src.height + grid.height;
				target.fillRect(rect, src.getPixel32(grid.x, grid.y));
			}
			
			return target;
		}
	}
}