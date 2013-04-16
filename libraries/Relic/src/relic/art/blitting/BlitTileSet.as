package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Point;
	import relic.art.ITileSet;
	import relic.art.TileSet;
	import relic.Asset;
	/**
	 * ...
	 * @author George
	 */
	public class BlitTileSet extends Blit implements ITileSet {
		public var tile:Point;
		public function BlitTileSet(child:BitmapData = null) { super(child); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
		}
		
		override public function set asset(value:Asset):void {
			super.asset = value;
		}
		override protected function setTileData():void {
			//super.setTileData();
		}
		
		public function get shapeBorder():BitmapData { return _shapeBorder; }
		public function get tileSize():Point { return rect.size; }
		
		public function get tileSet():TileSet { return asset as TileSet; }
	}

}