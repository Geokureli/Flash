package baseball{
	import baseball.states.editor.EditorState;
	import baseball.states.MenuState;
	import baseball.states.IntroState;
	import baseball.states.play.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.ads.AdBox;
	import krakel.ads.FlxMochiBox;
	import krakel.KrkGame;
	import krakel.KrkSound;
	import krakel.KrkState;
	import mochi.as3.MochiAd;
	import mochi.as3.MochiServices;
	import mochi.MochiBot;
	import org.flixel.FlxG;
	import krakel.beat.BeatKeeper;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxMouseControl;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	/**
	 * ...
	 * @author George
	 */
	[Frame(factoryClass="NGPreloader")]
	public class Main extends KrkGame {
		
		public function Main() {
			super(600, 350, FlxG.debug ? MenuState : IntroState, 1, 60, 30, true);
			//addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		override protected function create(e:Event):void {
			super.create(e);
			FlxG.addPlugin(new FlxScrollZone());
			FlxG.addPlugin(new FlxMouseControl());
			FlxG.addPlugin(new BeatKeeper());
			
			//FlxG.mouse.show();
			if(!FlxG.debug)
				MochiBot.track(this, "88255b00");
			
			if (AdBox.instance is FlxMochiBox) {
				(AdBox.instance as FlxMochiBox).game = this;
			}
			AdBox.createDock("top");
			
			//KrkSound.enabled = false;
			FlxG.visualDebug = FlxG.debug;
		}
	}
	
}