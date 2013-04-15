package relic.helpers {
	/**
	 * ...
	 * @author George
	 */
	internal class KeyWatchList {
		private var _state:Boolean;
		public var list:Vector.<KeyWatcher>;
		public function KeyWatchList() { list = new Vector.<KeyWatcher>(); }
		public function set state(value:Boolean):void {
			if (_state != value)
				for each(var watcher:KeyWatcher in list)
					watcher.state = value;
			_state = value;
		}
		public function add(target:Object, paramID:String):void {
			list.push(new KeyWatcher(target, paramID));
		}
		public function remove(target:Object, paramID:String):void {
			for (var i:String in list){
				if (list[i].target == target && list[i].paramID == paramID) {
					list[i].destroy();
					list.splice(int(i), 1);
					break;
				}
			}
		}
	}

}
class KeyWatcher {
	public var target:Object;
	public var paramID:String;
	public function KeyWatcher(target:Object, paramID:String) {
		this.target = target;
		this.paramID = paramID;
		if (paramID == null) paramID = String.fromCharCode(target);
	}
	public function destroy():void { target = null; paramID = null; }
	public function set state(value:Boolean):void {
		target[paramID] = value;
	}
}
