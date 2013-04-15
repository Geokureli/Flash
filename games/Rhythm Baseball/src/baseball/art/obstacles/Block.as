package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import baseball.Imports;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import relic.Asset;
	import relic.art.blitting.Blit;
	import relic.art.blitting.SpriteSheet;
	import relic.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Block extends Obstacle {
		static public var SPRITE:BitmapData = new Imports.Block().bitmapData;
		
		public function Block() { super(SPRITE); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			id = "block";
			
			originX -= 10;
			shape = new Box(0, 0, 24, 64);
			y++;
		}
		
	}

}