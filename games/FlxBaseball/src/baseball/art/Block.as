package baseball.art {
	import baseball.Imports;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import krakel.beat.BeatKeeper;
	/**
	 * ...
	 * @author George
	 */
	public class Block extends Obstacle {
		
		[Embed(source = "../../../res/sprites/block.png")] static private const SHEET:Class;
		private var _duration:Number;
		static private const OVERLAY:BitmapData = new SHEET().bitmapData;
		
		public function Block() { super(8, SHEET); }
		
		override protected function calcFrame():void {
			super.calcFrame();
			var space:int = BeatKeeper.pixelsPerBeat( -SCROLL) * .25;
			for (var p:Point = new Point(); p.x < frameWidth; p.x += space)
				framePixels.copyPixels(OVERLAY, framePixels.rect, p); 
		}
		
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void {
			_duration = value;
			if (duration == 0)
				loadGraphic(SHEET);
			else {
				frameWidth = Math.ceil(BeatKeeper.pixelsPerBeat(-SCROLL) * (duration-.25))+32;
				frameHeight = 32;
				pixels = Imports.getButtonGraphic(frameWidth, frameHeight, 1);
				dirty = true;
			}
		}
	}

}