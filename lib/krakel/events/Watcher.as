package krakel.events {
	/**
	 * ...
	 * @author George
	 */
	public class Watcher {
		
		public var callbacks:Vector.<Function>;
		
		public function Watcher() {
			callbacks = new <Function>[];
		}
		public function add(callback:Function):void {
			callbacks.push(callback);
		}
		public function remove(callback:Function):void {
			var index:int = callbacks.indexOf(callback);
			if(index > 0)
				callbacks.slice(index, 1);
		}
		
		public function trigger(){}
		
	}

}