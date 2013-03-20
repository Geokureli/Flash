package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.helpers.BitmapHelper;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends Obstacle {
		static public var src:BitmapData;
		{
			src = new Imports.Gap().bitmapData;
			BitmapHelper.clearBG(src, -1);
		}
		public function Gap() {
			super();
			graphic = src;
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			name = "gap";
			origin.x = 15;
			shape = new Box(0, 0, 24, 64);
			y += 32;
			//boundMode = BoundMode.NONE;
		}
		override public function update():void {
			super.update();
		}
	}
}