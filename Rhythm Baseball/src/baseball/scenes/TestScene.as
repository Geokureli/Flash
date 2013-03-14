package baseball.scenes 
{
	import baseball.art.obstacles.Block;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Rock;
	import baseball.art.Obstacle;
	import baseball.beat.BeatKeeper;
	import baseball.Imports;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import relic.data.events.SceneEvent;
	import relic.data.Global;
	/**
	 * ...
	 * @author George
	 */
	public class TestScene extends GameScene {
		
		public function TestScene() { super(); }
		override protected function setLevelProperties():void {
			super.setLevelProperties();
			if ("userLevel" in Global.VARS) level = Global.VARS.userLevel;
			else level = new XML(new Imports.testLevel);
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();			
			strikes = 0;
		}
		override protected function init(e:Event):void {
			super.init(e);
		}
		
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 32 && "userLevel" in Global.VARS)
				dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:"editor" } ));
		}
		override protected function reset():void {
			super.reset();
			strikes = 0;
		}
	}
}