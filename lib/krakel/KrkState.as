package krakel {
	import org.flixel.FlxBasic;
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
		//override public function preUpdate():void {
			//super.preUpdate();
			//var basic:FlxBasic;
			//var i:uint = 0;
			//while(i < length)
			//{
				//basic = members[i++] as FlxBasic;
				//if((basic != null) && basic.exists && basic.active)
				//{
					//basic.preUpdate();
					//basic.update();
					//basic.postUpdate();
				//}
			//}
		//}
		override public function update():void {
			//super.update()
			var basic:FlxBasic;
			var i:uint = 0;
			while(i < length)
			{
				basic = members[i++] as FlxBasic;
				if((basic != null) && basic.exists && basic.active)
				{
					basic.preUpdate();
					basic.update();
					basic.postUpdate();
				}
			}
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