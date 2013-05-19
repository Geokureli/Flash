package krakel {
	import krakel.KrkSprite;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	public class Trigger extends KrkSprite {
		
		public var action:String;
		
		public function Trigger(x:Number=0, y:Number=0, graphic:Class=null) {
			super(x, y, graphic);
		}
		public function onTrigger(collider:FlxObject):void {
			trace("trigger");
			if (action != null) {
				var actionList:Array = action.split(/\s*;\s*/);
				var args:Array;
				var target:String;
			
				for each (var action:String in actionList) {
					
					args = action.split(/\s*:\s*/);
					
					if (/\(\)$/.test(args[1]) && args[0] == "this")
						this[args[1].substring(0, args[1].length-2)]();
				}
			}
		}
		override public function checkHit(obj:FlxObject):Boolean {
			return super.checkHit(obj);
		}
	}
}