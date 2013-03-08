package baseball.art.obstacles 
{
	import baseball.art.RhythmAsset;
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
	public class Gap extends RhythmAsset {
		static public var src:BitmapData;
		{
			src = new Imports.Gap().bitmapData;
			SpriteSheet.clearBG(src, -1);
		}
		public function Gap(beat:Number) {
			super(beat, new Bitmap(src));
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			name = "gap";
			graphic.x -= 20
			shape = new Box(-4, 0, 24, 64);
			y = 344;
		}
		
	}

}