package baseball.art 
{
	import baseball.beat.BeatKeeper;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import relic.art.Asset;
	import relic.data.BoundMode;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class RhythmAsset extends Asset 
	{
		static public var BOUNDS:Rectangle;
		static public var END_X:int, SCROLL:int;
		public var beat:Number, speed:Number;
		public var isRhythm:Boolean;
		public function RhythmAsset(beat:Number, graphic:DisplayObject = null) {
			super(graphic);
			this.beat = beat;
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			speed = 0;
			bounds = BOUNDS;
			boundMode = BoundMode.DESTROY;
			isRhythm = true;
		}
		override protected function init(e:Event):void {
			super.init(e);
			debugDraw();
		}
		override public function update():void {
			super.update();
			x = END_X + BeatKeeper.toBeatPixels(SCROLL+speed) * (BeatKeeper.beat - beat);
		}
	}

}