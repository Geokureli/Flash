package krakel.helpers {
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class BitmapHelper {
		
		static private const mergeParams:Object = { color:int , alpha:Number };
		static private const channelParams:Object = { channel:uint };
		static private const slowDrawParams:Object = { scaleX:Number, scaleY:Number, scale:Number };
		
		static public function clearBG(graphic:BitmapData, color:int = -1):void {
			// --- IF NO COLOR PROVIDED REMOVE COLOR OF TOP-LEFT PIXEL
			if (color == -1) color = graphic.getPixel32(0, 0);
			graphic.threshold(graphic, graphic.rect, new Point(), "==", color, 0, 0xFFFFFFFF, true);
		}
		
		static public function DrawTo(src:BitmapData, target:BitmapData, dest:Point = null, rect:Rectangle = null, params:Object = null):void {
			
			if (params == null) {
				params = { merge:true, alphaBitmapData:null, alphaPoint:null };
			}
			if (hasMethodParams(params, mergeParams)) {
				var red:uint, green:uint, blue:uint, alpha:uint;
				if (!("color" in params)) {
					red = green = blue = 0xFF;
					alpha = uint(params.alpha * 0xFF);
				} else {
					blue = params.color & 0xFF;		params.color >>= 8;
					green = params.color & 0xFF;	params.color >>= 8;
					red = params.color & 0xFF;		params.color >>= 8;
					
					if (params.color > 0) alpha = params.alpha & 0xFF000000;
					else if ("alpha" in params) alpha = uint(params.alpha * 0xFF);
					else alpha = 0xFF;
				}
				target.merge(
					src,
					rect == null ? src.rect : rect,
					dest == null ? new Point() : dest,
					red,
					green,
					blue,
					alpha
				)
			} if (hasMethodParams(params, channelParams)) {
				target.copyChannel(
					src,
					rect == null ? src.rect : rect,
					dest == null ? new Point() : dest,
					params.channel,
					"destChannel" in params ? params.destChannel : params.channel
				)
			} else if (hasMethodParams(params, slowDrawParams)) {
				var mat:Matrix = new Matrix();
				if ("scaleX" in params) mat.scale(params.scaleX, 1);
				if ("scaleY" in params) mat.scale(1, params.scaleY);
				if ("scale" in params) mat.scale(params.scale, params.scale);
				target.draw(
					src,
					mat
				);
			} else {
				target.copyPixels(
					src,
					rect == null ? src.rect : rect,
					dest == null ? new Point() : dest,
					params.aplhaBitmapData,
					params.alphaPoint,
					params.merge
				);
			}
		}
		
		static private function hasMethodParams(params:Object, drawParams:Object):Boolean {
			for (var i:String in params)
			
				if (i in drawParams && params[i] is drawParams[i])
					return true;
			
			return false;
		}
		
		//static public function apply9Grid(src:BitmapData, grid:Rectangle, width:int, height:int):BitmapData {
			//return apply9GridTo(src, grid, new BitmapData(width, height));
		//}
		static public function apply9GridTo(src:BitmapData, target:BitmapData, grid:Rectangle, srcRect:Rectangle, dest:Rectangle, params:Object = null):void {
			if (srcRect == null)
				srcRect = src.rect;
			if (dest == null)
				dest = target.rect;
			// --- TOP LEFT
			src.lock()
			var rect:Rectangle = new Rectangle(srcRect.x, srcRect.y, grid.x, grid.y);
			var p:Point = new Point(dest.x, dest.y);
			DrawTo(src, target, p, rect, params);
			
			// --- TOP RIGHT
			rect.x = srcRect.x+grid.right;
			rect.width = srcRect.width - grid.right;
			p.x = dest.right - rect.width;
			DrawTo(src, target, p, rect, params);
			
			// --- BOTTOM RIGHT
			rect.y = srcRect.y+grid.bottom;
			rect.height = srcRect.height - grid.bottom;
			p.y = dest.bottom - rect.height;
			DrawTo(src, target, p, rect, params);
			
			// --- BOTTOM RIGHT
			rect.x = srcRect.x;
			rect.width = grid.left;
			p.x = dest.x;
			DrawTo(src, target, p, rect, params);
			
			// --- TOP AND BOTTOM
			rect.size = new Point(grid.width, grid.y);
			rect.x = srcRect.x+grid.x;
			rect.y = srcRect.y;
			p.y = dest.y;
			
			var rect2:Rectangle = new Rectangle(srcRect.x+grid.x, srcRect.y+grid.bottom, grid.width, srcRect.height - grid.bottom);// --- BOTTOM
			var p2:Point = new Point(grid.x+dest.x, dest.bottom - rect2.height);
			for (p.x = grid.x+dest.x; p.x <= dest.right - srcRect.width + grid.x; p.x += grid.width) {
				DrawTo(src, target, p, rect, params);	// --- TOP
				DrawTo(src, target, p2, rect2, params);	// --- BOTTOM
				p2.x += grid.width;
			}
			
			// --- LEFT AND RIGHT
			rect.x = srcRect.x;			rect.width = grid.x;
			rect.y = srcRect.y+grid.y;	rect.height = grid.height;
			p.x = dest.x;
			
			rect2.width = srcRect.width - grid.right;
			rect2.x = srcRect.x+grid.right;
			rect2.y = srcRect.y+grid.y;	rect2.height = grid.height
			p2.x = dest.right - rect2.width;
			p2.y = grid.y + dest.y;
			
			for (p.y = grid.y + dest.y; p.y <= dest.bottom - src.height + grid.y; p.y += grid.height) {
				DrawTo(src, target, p, rect, params);	// --- TOP
				DrawTo(src, target, p2, rect2, params);	// --- BOTTOM
				p2.y += grid.height;
			}
			
			if (grid.width * grid.height == 1) {// --- 1 PIXEL CENTER
				rect.x = grid.x+dest.x;
				rect.y = grid.y+dest.y;
				rect.width = dest.width - srcRect.width + grid.width;
				rect.height = dest.height - srcRect.height + grid.height;
				if(src.getPixel32(srcRect.x + grid.x, srcRect.y + grid.y) > 0xFFFFFF)
					target.fillRect(rect, src.getPixel32(srcRect.x + grid.x, srcRect.y + grid.y));
			}
			src.unlock();
		}
	}
}