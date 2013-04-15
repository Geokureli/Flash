package test.flixel{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
	import test.flixel.states.GameState;
	import test.flixel.states.MainState;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends FlxGame {
		static private const SCALE:int = 4;
		public function Main():void { 
			super(stage.stageWidth / SCALE, stage.stageHeight / SCALE, GameState, SCALE);
		}
		override protected function create(FlashEvent:Event):void {
			super.create(FlashEvent);
			FlxG.mouse.show();
		}
	}
	
}