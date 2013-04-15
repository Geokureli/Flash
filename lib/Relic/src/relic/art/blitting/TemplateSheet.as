package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import relic.helpers.BitmapHelper;
	
	/**
	 * ...
	 * @author George
	 */
	public class TemplateSheet extends SpriteSheet {
		private var _grid:Rectangle;
		public function TemplateSheet(graphic:BitmapData, grid:Rectangle = null) {
			super(graphic);
			if (grid == null) grid = new Rectangle(int(rect.width / 2), int(rect.height / 2), 1, 1);
			_grid = grid;
		}
		public function createSheet(width:int, height:int):SpriteSheet {
			var sheet:SpriteSheet = new SpriteSheet(new BitmapData(width * columns, height * rows));
			
			if (frames == null) {
				
				drawTemplate(sheet)
				return sheet;
			}
			
			var destRect:Rectangle = new Rectangle(0, 0, width, height);
			var srcRect:Rectangle = new Rectangle(0, 0, this.width / columns, this.height / rows);
			
			sheet.createGrid(width, height);
			
			for (var frame:int = 0; frame < frames.length; frame++)
				drawTemplate(sheet, sheet.frames[frame], frame)
			
			for (var anim:String in groups["default"])
				sheet.addAnimation("default", anim, groups["default"][anim].frames, groups["default"][anim].loop, groups["default"][anim].rate);
				
			return sheet;
		}
		public function drawTemplate(target:BitmapData, destRect:Rectangle = null, frame:int = 0, params:Object = null):void {
			if (destRect == null)
				destRect = target.rect;
			BitmapHelper.apply9GridTo(this, target, _grid, frames == null ? rect : frames[frame], destRect, params);
		}
		
		//public function get grid():Rectangle {
			//if (_grid == null) 
			//return _grid;
		//}
		//
		//public function set grid(value:Rectangle):void { _grid = value; }
	}

}