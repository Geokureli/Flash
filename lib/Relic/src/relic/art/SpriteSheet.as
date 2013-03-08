package relic.art 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class SpriteSheet 
	{
		public var graphic:BitmapData;
		public var animations:Object;
		public var frames:Vector.<BitmapData>;
		public function SpriteSheet(graphic:BitmapData) {
			this.graphic = graphic;
			animations = { };
		}
		public function createGrid(width:int, height:int):void {
			frames = new Vector.<BitmapData>();
			var r:Rectangle = new Rectangle(0, 0, width, height);
			var b:BitmapData;
			var mat:Matrix = new Matrix();
			for (r.y = 0; r.bottom <= graphic.height; r.y += r.height) {
				for (r.x = 0; r.right <= graphic.width; r.x += r.width) {
					b = new BitmapData(r.width, r.height, true, 0);
					mat.tx = -r.x;
					mat.ty = -r.y;
					b.draw(graphic, mat);
					frames.push(b);
				}
			}
		}
		public function clearBG(color:int = -1):void {
			SpriteSheet.clearBG(graphic, color);
		}
		//public function autoClearBG(
		public function addAnimation(name:String, frames:Vector.<int>, loop:Boolean = true, rate:int = 2):Animation {
			animations[name] = new Animation(this, frames);
			animations[name].loop = loop;
			animations[name].rate = rate;
			return animations[name];
		}
		static public function clearBG(graphic:BitmapData, color:int = -1):void {
			// --- IF NO COLOR PROVIDED REMOVE COLOR OF TOP-LEFT PIXEL
			if (color == -1) color = graphic.getPixel32(0, 0);
			graphic.threshold(graphic, graphic.rect, new Point(), "==", color, 0, 0xFFFFFFFF, true);
		}
	}

}