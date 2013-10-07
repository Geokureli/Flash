package algae{
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.KrkGame;
	import krakel.KrkLevel;
	import krakel.serial.Serializer;
	
	/**
	 * ...
	 * @author George
	 */
	
	[SWF(width = "1280", height = "960", backgroundColor = "#FFFFFF", frameRate = "30")]
	public class Main extends KrkGame {
		
		static private function init():void {
			KrkLevel.CLASS_REFS.AlgaeMap = AlgaeMap;
		}
		{ init(); }
		
		public function Main():void {
			super(1280, 960, GameState, .75);
		}
	}
}