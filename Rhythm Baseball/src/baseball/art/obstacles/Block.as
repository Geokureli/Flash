package baseball.art.obstacles 
{
	import baseball.art.RhythmBlit;
	import baseball.Imports;
	import flash.display.Bitmap;
	import relic.art.Asset;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Block extends RhythmBlit {
		
		public function Block(beat:Number) {
			super(beat); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			name = "block";
			graphic = new Imports.Block().bitmapData;
			origin.x -= 10;
			shape = new Box(0, 0, 24, 64);
			y++;
		}
		
	}

}