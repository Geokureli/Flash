package krakel {
	/**
	 * ...
	 * @author George
	 */
	public class KrkControls {
		
		public var keyBinds:Object;
		
		public function KrkControls(binds:Object) {
			
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