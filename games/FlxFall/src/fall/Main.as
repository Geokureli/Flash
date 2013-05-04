package fall{
	import fall.states.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends KrkGame {
		
		public function Main():void {
			super(350, 600, GameState);
		}
		
		override protected function create(e:Event):void {
			super.create(e);
			
			
		}
		
	}
	
}