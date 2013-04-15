package baseball.art {
	import baseball.Imports;
	import flash.events.Event;
	import relic.Asset;
	import relic.art.IDisplay;
	import relic.art.blitting.AnimatedBlit;
	import relic.art.blitting.SpriteSheet;
	import relic.beat.BeatKeeper;
	import relic.BoundMode;
	import relic.events.BoundEvent;
	import relic.helpers.Random;
	
	/**
	 * ...
	 * @author George
	 */
	public class Cloud extends Asset {
		static public var CLOUD_RANGE:Number = 150;
		
		static private var SPRITE:SpriteSheet
		
		{
			SPRITE = new SpriteSheet(new Imports.Cloud().bitmapData);
			SPRITE.clearBG();
			SPRITE.createGrid(48);
			SPRITE.addAnimation(null, "idle", [0, 1, 2], false, 1);
		}
		public function Cloud() { super(new AnimatedBlit()); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			blit.addAnimationSet(SPRITE);
			blit.isPlaying = false;
			blit.frame = Random.random(blit.numFrames);
			boundMode = BoundMode.LOOP;
			id = "cloud";
			y = Random.random(CLOUD_RANGE);
			vel.x = int(Obstacle.SCROLL / 8);
			addEventListener(BoundEvent.GRAPHIC_OUT, onLoop);
		}
		override protected function init(e:Event):void {
		}
		
		private function onLoop(e:BoundEvent):void {
			x += Random.random(100);
			y = Random.random(CLOUD_RANGE);
			blit.frame = Random.random(blit.numFrames);
		}
		override public function update():void {
			super.update();
		}
		public function get blit():AnimatedBlit { return graphic as AnimatedBlit; }
	}

}