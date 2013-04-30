package baseball.art {
	import baseball.Imports;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import krakel.beat.BeatKeeper;
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends Obstacle {
		[Embed(source="../../../res/sprites/gap.png")] static private const SHEET:Class;
		[Embed(source="../../../res/sprites/gap2.png")] static private const GAP_TEMPLATE:Class;
		static public var GAP:BitmapData = new GAP_TEMPLATE().bitmapData;
		
		static private const gaps:Array = [];
		
		static private const WIDTH:int = 16,
							FRAME_WIDTH:int = 59,
							OFFSET:int = 15;
		
		private var _duration:Number;
		
		public function Gap() {
			super(30, SHEET);
			width = WIDTH;
			offset.x = OFFSET;
			_duration = 0;
		}
		
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void {
			_duration = value;
			if (duration == 0) {
				loadGraphic(SHEET);
				width = WIDTH;
			}
			else {
				pixels = getGapGraphic(Math.ceil(BeatKeeper.pixelsPerBeat( -SCROLL) * (duration)) + FRAME_WIDTH);
				width = frameWidth - FRAME_WIDTH + WIDTH;
				//dirty = true;
			}
		}
		static public function getGapGraphic(width:int):BitmapData {
			if (width < GAP.width) throw new Error("width must be larger than or equal to template");
			if (width in gaps) return gaps[width];
			var graphic:BitmapData = new BitmapData(width, GAP.height, true, 0);
			gaps[width] = graphic;
			var rect:Rectangle = GAP.rect.clone();
			rect.width = 47;
			var dest:Point = new Point();
			graphic.copyPixels(GAP, rect, dest);
			rect.x = 48;
			rect.width = GAP.width - 48;
			dest.x = width - rect.width;
			graphic.copyPixels(GAP, rect, dest);
			rect.x = 47;
			rect.width = width - GAP.width+1;
			graphic.fillRect(rect, 0xFF000000);
			return graphic;
		}
	}

}