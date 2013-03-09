package baseball.scenes.editor 
{
	import baseball.art.RhythmAsset;
	import baseball.beat.BeatKeeper;
	import flash.events.Event;
	import relic.art.Asset;
	
	/**
	 * ...
	 * @author George
	 */
	public class Staff extends Asset 
	{
		public var beatsPerMeasure:int;
		public function Staff() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			beatsPerMeasure = 4;
		}
		
		override protected function init(e:Event):void {
			super.init(e);
			draw();
		}
		public function draw():void {
			graphics.clear();
			var measure:int = BeatKeeper.toBeatPixels( -RhythmAsset.SCROLL) / 4 * beatsPerMeasure;
			graphics.lineStyle(2);
			trace((BeatKeeper.beat * 4) % beatsPerMeasure);
			for (var x:int = measure - (BeatKeeper.beat % (beatsPerMeasure/4)) * measure; x < stage.stageWidth; x += measure) {
				graphics.moveTo(x, 0);
				graphics.lineTo(x, stage.stageHeight);
			}
		}
	}

}