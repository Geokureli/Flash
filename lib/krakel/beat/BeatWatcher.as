package krakel.beat {
	/**
	 * ...
	 * @author George
	 */
	internal class BeatWatcher {
		
		public var beat:Number;
		public var callback:Function;
		
		public function BeatWatcher(beat:Number, callback:Function):void {
			this.beat = beat;
			this.callback = callback;
		}
		// --- CALL AND DISPOSE
		public function trigger():void { callback(beat); destroy(); }
		public function destroy():void { callback = null; }
	}

}