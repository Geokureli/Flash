package algae {
	import krakel.KrkGameState;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkGameState {
		
		private var quad:Quadrat;
		
		public function GameState() { super(); }
		
		override public function create():void {
			super.create();
			
			add(quad = Imports.getLevel("level_1"));
			
			//FlxG.visualDebug = true;
			
		}
		
		
	}

}