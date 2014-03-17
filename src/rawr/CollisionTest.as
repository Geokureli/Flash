package rawr {
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "384", height = "576", backgroundColor = "#5c94fc", frameRate = "30")]
	public class CollisionTest extends FlxGame {
		
		public function CollisionTest() {
			super(128, 192, GameState, 3, 60, 30, false);
		}	
	}
}
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxState;

class GameState extends FlxState {
	
	override public function create():void {
		super.create();
		
		trace(FlxG.overlap(new FlxObject(50, 50, 50, 50), new FlxObject(50, 50, 50, 50)));
	}
}