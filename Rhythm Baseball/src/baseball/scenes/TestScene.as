package baseball.scenes 
{
	import baseball.art.obstacles.Block;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Rock;
	import baseball.art.RhythmAsset;
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
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			if ("userLevel" in Global.VARS) level = Global.VARS.userLevel;
			else level = new XML(new Imports.testLevel);
			BeatKeeper.beatsPerMinute = level.@bpm;
			RhythmAsset.SCROLL = -Number(level.@speed);
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			//createLevel();
		}
		
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 32 && "userLevel" in Global.VARS)
				dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:"editor" } ));
		}
	}
}