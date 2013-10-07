package baseball.states.play {
	import baseball.art.Obstacle;
	import baseball.states.editor.EditorState;
	import krakel.beat.BeatKeeper;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	/**
	 * ...
	 * @author George
	 */
	public class TestMode extends GameState{
		public var editor:EditorState;
		public function TestMode(level:XML = null) {
			super(level);
		}
		override protected function startGame():void {
			startRound();
			defaultUpdate = updateMain;
		}
		override protected function strike(obstacle:Obstacle):void {
			//lastHit = obstacle;
			hero.flicker(15 / BeatKeeper.beatsPerMinute);
		}
		override public function update():void {
			super.update();
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.switchState(editor);
			}
		}
	}

}