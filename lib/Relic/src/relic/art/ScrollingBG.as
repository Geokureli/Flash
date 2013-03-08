package relic.art 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author George
	 */
	public class ScrollingBG extends Bitmap 
	{
		public var speed:int;
		public var pos:int;
		public var tile:BitmapData;
		public function ScrollingBG(width:int, height:int, transparent:Boolean= true, fillColor:uint = 0xFFFFFFFF){
			super(new BitmapData(width, height, transparent, fillColor));
		}
		public function update():void {
			//if (speed == 0) return;
			pos += speed;
			pos = pos% tile.width;
			draw();
		}
		private function draw():void {
			bitmapData.fillRect(bitmapData.rect, 0);
			var r:Rectangle = tile.rect.clone();
			var mat:Matrix = new Matrix();
			for (r.x = pos; r.x < bitmapData.width; r.x += r.width) {
				mat.tx = r.x;
				bitmapData.draw(tile, mat);
			}
		}
	}

}