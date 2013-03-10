package baseball.art.obstacles 
{
	import baseball.art.RhythmAsset;
	import baseball.Imports;
	import flash.display.Bitmap;
	import relic.art.Asset;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Block extends RhythmAsset {
		
		public function Block(beat:Number) { super(beat, new Imports.Block()); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			name = "block";
			//graphic.x -= 10;
			shape = new Box(0, 0, 24, 64);
			y++;
		}
		
	}

}