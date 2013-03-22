package relic.art.blitting {
	import flash.geom.Point;
	/**
	 * ...
	 * @author George
	 */
	public class BlitTileSet extends Blit {
		
		public function BlitTileSet() { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
		}
		
		override protected function drawTile(position:Point, xIndex:int, yIndex:int):void {
			super.drawTile(position, xIndex, yIndex);
		}
	}

}