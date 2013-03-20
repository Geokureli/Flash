package baseball.art 
{
	import relic.beat.BeatKeeper;
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
		public function Obstacle() {
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			speed = SCROLL;
			boundMode = BoundMode.DESTROY;
			isRhythm = true;
			y = HERO.y
		}
		override public function setParameters(params:Object):void {
			super.setParameters(params);
			//trace(params);
		}
		override protected function init(e:Event):void {
			super.init(e);
			x = HERO.x + BeatKeeper.toBeatPixels(SCROLL+speed) * (BeatKeeper.beat - beat);
			//debugDraw();
		}
		override public function update():void {
			if(isRhythm){
				x = HERO.x + BeatKeeper.toBeatPixels(speed * (BeatKeeper.beat - beat));
				//trace(x);
			}
			super.update();
		}
	}

}