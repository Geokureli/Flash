package relic.art 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	/**
	 * ...
	 * @author George
	 */
	public class Animation {
		
		public var frames:Vector.<int>
		public var sheet:SpriteSheet;
		public var loop:Boolean;
		public var rate:int, numFrames:int;
		
		public function Animation(sheet:SpriteSheet, frames:Vector.<int>):void {
			this.sheet = sheet;
			this.frames = frames;
			loop = true;
			rate = 2;
			numFrames = frames.length;
		}
		public function drawFrame(num:int, target:BitmapData, dest:Point = null):void {
			sheet.drawFrame(getSpriteFrame(num), target, dest);
		}
		public function getFrameRect(num:int):Rectangle {
			return sheet.frames[getSpriteFrame(num)];
		}
		private function getSpriteFrame(frame:int):int {
			frame /= rate;
			
			if (frame >= frames.length) {
				if (!loop) frame = frames.length - 1;
				else frame %= frames.length;
			}
			return frames[frame];
		}
	}

}