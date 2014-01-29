package picross {
	import flash.geom.Point;
	/**
	 * Linked List Node
	 * @author George
	 */
	public class Tile {
		
		internal var _dirty:Boolean;
		
		public var group:int;
		
		private var _pos:Point;
		private var _state:TileState;
		private var _length:uint;
		private var _next:Tile;
		private var _prev:Tile;
		
		/**
		 * Linked List Node
		 * @author George
		 */
		public function Tile(x:int, y:int) {
			
			_pos = new Point(x, y);
			
			_dirty = false;
			
			_length = 1;
			group = -1;
			
			state = TileState.EMPTY;
		}
		
		public function splice(start:uint, length:uint):Tile {
			
			var startTile:Tile = this;
			while (start >= 0) {
				
				startTile = startTile.next;
				
				start--;
			}
			
			startTile.prev = null;
			var endTile:Tile = startTile;
			while (length >= 0) {
				
				endTile = endTile.next;
				
				length--;
			}
			
			endTile.next = null;
			
			return startTile;
		}
		
		public function join(...args):Tile {
			var end:Tile = args[args.length-1];
			for (var i:int = args.length-2; i >= 0; i--) {
				
				while (end.prev != null) {
					
					end = end.prev;
				}
				
				end.prev = args[i];
			}
			return args[0];
		}
		
		public function get x():int {	 return _pos.x; }
		public function set x(value:int):void { _pos.x = value; }
		
		public function get y():int {	 return _pos.y; }
		public function set y(value:int):void {	_pos.y = value; }
		
		public function get next():Tile { return _next; }
		public function set next(value:Tile):void {
			
			if (_next == value) return;
			
			var temp:Tile = _next;
			_next = value;
			
			if (temp.prev == this)
				temp.prev = null;
			
			if (value != null)
				
				_next.prev = this;
				
			else length = 1;
			
		}
		
		public function get prev():Tile { return _prev; }
		public function set prev(value:Tile):void {
			
			if (_prev == value) return;
			
			var temp:Tile = _prev;
			_prev = value;
			
			if (temp.next == this)
				temp.next = null;
			
			if (_prev != null) {
				
				if (_prev.next == null)
					_prev.next = this;
				
				_prev.length = length + 1;
			}
		}
		
		public function get length():uint { return _length; }
		public function set length(value:uint):void {
			
			_length = value;
			
			if(prev != null)
				prev.length = value + 1;
		}
		
		public function get state():TileState { return _state; }
		public function set state(value:TileState):void {
			
			if (value == _state) return;
			
			_dirty = true;
			
			_state = value;
		}
	}

}