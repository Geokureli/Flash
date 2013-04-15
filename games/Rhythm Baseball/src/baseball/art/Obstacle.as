package baseball.art 
{
	import flash.display.BitmapData;
	import relic.Asset;
	import relic.art.blitting.AnimatedBlit;
	import relic.art.IDisplay;
	import relic.beat.BeatKeeper;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import relic.art.blitting.Blit;
	import relic.BoundMode;
	import relic.Vec2;
	import relic.xml.IXMLParam;
	
	/**
	 * ...
	 * @author George
	 */
	public class Obstacle extends Asset {
		static public var HERO:Vec2 = new Vec2();
		static public var SCROLL:Number;
		public var beat:Number, speed:Number;
		public var isRhythm:Boolean;
		public function Obstacle(child:BitmapData = null) {
			super( new AnimatedBlit(child) );
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			speed = SCROLL;
			boundMode = BoundMode.DESTROY;
			isRhythm = true;
			y = HERO.y
		}
		override public function setParameters(params:Object):IXMLParam {
			
			return super.setParameters(params);
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
		public function get currentAnimation():String { return blit.currentAnimation; }
		public function set currentAnimation(value:String):void { blit.currentAnimation = value; }
		
		public function get blit():AnimatedBlit { return graphic as AnimatedBlit; }
	}

}