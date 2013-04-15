package test.flixel.states {
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author George
	 */
	public class MainState extends FlxState {
		
		private var btn_play:FlxButton;
		
		public function MainState() { super(); }
		override public function create():void {
			super.create();
			btn_play = new FlxButton(0, 50, "Play", onClick);
			add(btn_play);
		}
		
		private function onClick():void {
			FlxG.switchState(new GameState());
		}
		override public function destroy():void {
			super.destroy();
			
		}
	}

}