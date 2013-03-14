package baseball.art 
{
	import baseball.beat.BeatKeeper;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import relic.art.blitting.Blit;
	import relic.data.BoundMode;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class Obstacle extends Blit {
		static public var HERO:Vec2;
		static public var SCROLL:Number;
		public var beat:Number, speed:Number;
		public var isRhythm:Boolean;
		public function Obstacle(beat:Number) {
			super();
			this.beat = beat;
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			speed = 0;
			boundMode = BoundMode.DESTROY;
			isRhythm = true;
			y = HERO.y
		}
		override protected function init(e:Event):void {
			super.init(e);
			x = HERO.x + BeatKeeper.toBeatPixels(SCROLL+speed) * (BeatKeeper.beat - beat);
			//debugDraw();
		}
		override public function update():void {
			super.update();
			if(isRhythm)
				x = HERO.x + BeatKeeper.toBeatPixels((SCROLL+speed) * (BeatKeeper.beat - beat));
		}
	}

}