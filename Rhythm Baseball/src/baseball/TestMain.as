package baseball {
	import baseball.art.BlitHero;
	import baseball.art.Hero;
	import baseball.art.RhythmAsset;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import relic.art.blitting.Blitmap;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class TestMain extends Sprite {
		private var level:Blitmap;
		
		public function TestMain():void {	
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			RhythmAsset.HERO = new Vec2(100, 309);
			
			level = new Blitmap(new BitmapData(800, 400, false, 0));
			//level.scaleX = level.scaleY = 2;
			addChild(level);
			level.addLayer("bg");
			level.place("bg", level.add(new BlitHero(), "hero"));
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void {
			level.update();
		}
	}
	
}