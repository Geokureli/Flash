package greed{
	import flash.display.Sprite;
	import flash.events.Event;
	import greed.states.GameState;
	import krakel.KrkGame;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends KrkGame {
		static private const SCALE:Number = 2;
		
		public function Main():void {
			super(640 / SCALE, 360 / SCALE, GameState, SCALE);
		}
		
	}
	
}