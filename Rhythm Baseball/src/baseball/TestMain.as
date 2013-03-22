package baseball {
	import baseball.art.Hero;
	import baseball.art.Obstacle;
	import baseball.scenes.GameScene;
	import baseball.scenes.RandomScene;
	import baseball.scenes.TestScene;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import relic.art.blitting.Blit;
	import relic.art.blitting.Blitmap;
	import relic.audio.SoundManager;
	import relic.data.Game;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class TestMain extends Game {
		
		public function TestMain():void {
			super()
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			scenes = { main:RandomScene };
			SoundManager.ENABLED = false;
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			showFPS = true;
		}
	}
	
}