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
			members = [];
			super.create();
			
		}
		override public function update():void {
			super.update();
			
			if (FlxG.debug) debugUpdate();
		}
		
		protected function debugUpdate():void {
			if (FlxG.keys.ESCAPE && parentState != null) toParentState();
		}
		
		protected function toParentState():void {
			FlxG.switchState(parentState);
		}
		override public function destroy():void {
			super.destroy();
			parentState = null;
		}
		
		public function pause():void{}
		public function unpause():void{}
	}

}