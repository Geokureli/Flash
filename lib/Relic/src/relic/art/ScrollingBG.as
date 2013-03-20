package relic.art 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.blitting.Blit;
	
	/**
	 * ...
	 * @author George
	 */
	public class ScrollingBG extends Blit
	{
		public var parallax:Number;
		public var rows:int, columns:int;
		public function ScrollingBG() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			parallax = 1;
			columns = -1;
			rows = 1;
		}
		//public function update():void { super.update(); }
		override public function drawToStage(target:BitmapData):void {
			if (visible) {
				var o:Point = origin.point;
				position.add(o);
				if (anim != null)
					anim.drawFrame(_currentFrame, target, position);
				else if (graphic != null) {
					var size:Rectangle = (graphic as BitmapData).rect;
					var p:Point = position.add(o);
					p.x *= parallax;
					p.x = p.x % size.width;
					if (p.x > 0) p.x -= size.width;
					var r:int = 0, c:int = 0;
					for (c = 0; p.x < map.width; p.x += size.width) {
						p.y = position.y + o.y;
						for (r = 0; r != rows; r++) {
							target.copyPixels(graphic as BitmapData, size, p);
							p.y += size.height;
						}
					}
				}
				position.subtract(o);
			}
		}
	}

}