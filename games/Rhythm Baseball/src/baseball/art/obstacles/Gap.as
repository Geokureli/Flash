package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import relic.Asset;
	import relic.BoundMode;
	import relic.helpers.BitmapHelper;
	import relic.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends Obstacle {
		
		static private var SPRITE:BitmapData;
		
		{
			SPRITE = new Imports.Gap().bitmapData;
			BitmapHelper.clearBG(SPRITE);
		}
		
		public function Gap() { super(SPRITE); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			id = "gap";
			originX = 15;
			shape = new Box(0, 0, 24, 64);
			y += 32;
			//boundMode = BoundMode.NONE;
		}
		override public function update():void {
			super.update();
		}
	}
}