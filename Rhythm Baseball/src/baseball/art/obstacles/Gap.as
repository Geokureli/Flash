package baseball.art.obstacles 
{
	import baseball.art.RhythmBlit;
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends RhythmBlit {
		static public var src:BitmapData;
		{
			src = new Imports.Gap().bitmapData;
			SpriteSheet.clearBG(src, -1);
		}
		public function Gap(beat:Number) {
			super(beat);
			graphic = src;
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			name = "gap";
			origin.x -= 20
			shape = new Box(-4, 0, 24, 64);
			y += 43;
		}
		
	}

}