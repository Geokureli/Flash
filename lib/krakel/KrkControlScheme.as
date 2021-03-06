package krakel {
	import krakel.KrkScheme;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkControlScheme extends KrkScheme {
		static public const KEY_DIRECTIONS:Object = {
			l:"A,LEFT",
			r:"D,RIGHT",
			u:"W,UP",
			d:"S,DOWN"
		}
		
		public var keyBinds:Object;
		
		override public function preUpdate():void {
			super.preUpdate();
			setKeys();
		}
		public function setKeys():void {
			for (var bind:String in keyBinds) {
				this[bind] = false;
				// --- CHECK EACH KEY IN BIND
				for each (var key:String in keyBinds[bind].split(','))
					this[bind] ||= FlxG.keys.pressed(key);
				// --- SET ANTI KEY
				if ('_' + bind in this && !this[bind]) this['_' + bind] = true;
			}
		}
		
	}

}