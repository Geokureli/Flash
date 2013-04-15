package krakel {
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkState extends FlxState {
		
		public var parentState:FlxState;
		
		public function KrkState() { super(); }
		override public function create():void {
			super.create();
			
			initVars();
		}
		
		protected function initVars():void { }
		
		override public function update():void {
			super.update();
			
			if (FlxG.debug) debugUpdate();
		}
		
		protected function debugUpdate():void {
			if (FlxG.keys.ESCAPE && parentState != null) FlxG.switchState(parentState);
		}
		
	}

}