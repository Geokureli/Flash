package relic.art 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.data.helpers.BitmapHelper;
	/**
	 * ...
	 * @author George
	 */
	public class SpriteSheet extends BitmapData
	{
		public var animations:Object;
		public var frames:Vector.<Rectangle>;
		public function SpriteSheet(graphic:BitmapData) {
			super(graphic.width, graphic.height);
			copyPixels(graphic, rect, new Point());
			animations = { idle:new Animation(this, Vector.<int>([0])) };
		}
		public function createGrid(width:int = 0, height:int = 0):void {
			if (width == 0)
				width = height = Math.min(this.width, this.height);
			else if (height == 0)
				height = Math.min(width, this.height);
				
			frames = new Vector.<Rectangle>();
			var r:Rectangle = new Rectangle(0, 0, width, height);
			var b:BitmapData;
			for (r.y = 0; r.bottom <= this.height; r.y += r.height) {
				for (r.x = 0; r.right <= this.width; r.x += r.width) {
					frames.push(r.clone());
				}
			}
		}
		public function createDefualtAnimation(loop:Boolean = true, rate:int = 2):void {
			var frames:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < numFrames; i++)
				frames.push(i);
			addAnimation("idle", frames, loop, rate);
		}
		public function clearBG(color:int = -1):void {
			BitmapHelper.clearBG(this, color);
		}
		public function getFrame(num:int):BitmapData {
			var rect:Rectangle = frames[num];
			var bm:BitmapData = new BitmapData(rect.width, rect.height);
			drawFrame(num, bm, new Point());
			return bm;
		}
		public function addAnimation(name:String, frames:Vector.<int>, loop:Boolean = true, rate:int = 2):Animation {
			animations[name] = new Animation(this, frames);
			animations[name].loop = loop;
			animations[name].rate = rate;
			return animations[name];
		}
		public function drawFrame(num:int, target:BitmapData, dest:Point = null):void {
			BitmapHelper.drawTo(this, target, dest, frames != null ? frames[num] : rect);
		}
		public function get numFrames():int { return frames.length; }
	}

}
