package baseball{
	import baseball.states.editor.EditorState;
	import baseball.states.MenuState;
	import baseball.states.play.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	import krakel.KrkState;
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
			
			super(600, 340, MenuState);
		}
		override protected function create(e:Event):void {
			super.create(e);
			FlxG.addPlugin(new FlxScrollZone());
			FlxG.addPlugin(new FlxMouseControl());
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
			FlxG.mouse.show();
		}
	}
	
}