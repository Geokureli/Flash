package fall{
	import fall.states.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	
	/**
	 * ...
	 * @author George
	 */
	
	[SWF(width = "350", height = "600", backgroundColor = "#000000", frameRate = "30")]
	public class Main extends KrkGame {
		
		public function Main():void {
			super(350, 600, GameState);
		}
		
		override protected function create(e:Event):void {
			super.create(e);
			
			
		}
		
	}
	
}