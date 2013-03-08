package relic.art 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
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
		public function getFrame(num:int):BitmapData {
			num /= rate;
			
			if (num >= frames.length) {
				if (!loop) num = frames.length - 1;
				else num %= frames.length;
			}
		
			return sheet.frames[frames[num]];
		}
	}

}