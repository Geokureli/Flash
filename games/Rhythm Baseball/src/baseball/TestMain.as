package baseball {
	import baseball.art.Hero;
	import baseball.art.Obstacle;
	import baseball.scenes.ButtonTestScene;
	import baseball.scenes.editor.EditorScene;
	import baseball.scenes.GameScene;
	import baseball.scenes.MainMenu;
	import baseball.scenes.RandomScene;
	import baseball.scenes.TestScene;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import relic.Asset;
	import relic.art.blitting.Blit;
	import relic.art.blitting.Blitmap;
	import relic.audio.SoundManager;
	import relic.Game;
	import relic.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class TestMain extends Game {
		
		public function TestMain():void { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			scenes = { main:MainMenu, charge:RandomScene };
			SoundManager.ENABLED = false;
			
			//Asset.DEBUG_DRAW = true;
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			showFPS = true;
		}
		
	}
	
}
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
class thing extends EventDispatcher {
	public function trigger():void {
		dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN)); 
	}
}