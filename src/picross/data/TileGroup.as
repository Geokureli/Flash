package picross.data {
	/**
	 * Linked List
	 * @author George
	 */
	public class TileGroup {
		
		public var min:uint;
		public var index:uint;
		
		private var _size:uint;
		private var _length:uint;
		private var _sum:uint;
		private var _next:TileGroup;
		private var _prev:TileGroup;
		
		public function TileGroup(size:uint) {
			_sum = size;
			_size = size;
			min = _size;
			
			length = 1;
			
		}
		
		public function get next():TileGroup { return _next; }
		public function set next(value:TileGroup):void {
			
			_next = value;
			
			if (value != null)
				
				_next.prev = this;
				
			else length = 1;
			
		}
		
		public function get prev():TileGroup { return _prev; }
		public function set prev(value:TileGroup):void {
			
			_prev = value;
			
			if (_prev != null) {
				_prev.length = length + 1;
				_prev.sum = sum + _prev.size;
				_prev.min = _prev.sum + _prev.length - 1; 
			}
		}
		
		public function get length():uint { return _length; }
		public function set length(value:uint):void {
			
			_length = value;
			
			if (prev != null)
				prev.length = value + 1;
		}
		
		public function get sum():uint { return _sum; }
		public function set sum(value:uint):void {
			
			_sum = value;
			
			if (prev != null)
				prev.sum = value + prev.size;
		}
		
		public function get size():uint { return _size; }
		
		static public function create(list:Vector.<uint>):TileGroup {
			
			var head:TileGroup = new TileGroup(list.pop());
			head.index = list.length;
			
			while (list.length > 0) {
				
				new TileGroup(list.pop()).next = head;
				
				head = head.prev;
				head.index = list.length;
			}
			
			return head;
		}
	}

}