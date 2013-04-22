package baseball{
	import baseball.states.editor.EditorState;
	import baseball.states.MenuState;
	import baseball.states.play.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	import krakel.KrkSound;
	import krakel.KrkState;
	import mochi.MochiBot;
	import org.flixel.FlxG;
	import krakel.beat.BeatKeeper;
	import org.flixel.plugin.photonstorm.FlxMouseControl;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	/**
	 * ...
	 * @author George
	 */
	[Frame(factoryClass="baseball.Preloader")]
	public class Main extends KrkGame {
		
		public function Main() {
			
			super(600, 400, MenuState);
		}
		override protected function create(e:Event):void {
			super.create(e);
			FlxG.addPlugin(new FlxScrollZone());
			FlxG.addPlugin(new FlxMouseControl());
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
			FlxG.mouse.show();
			if(!FlxG.debug)
				MochiBot.track(this, "88255b00");
			//KrkSound.enabled = false;
		}
	}
	
}