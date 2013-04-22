package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends Obstacle {
		[Embed(source = "../../../res/sprites/gap.png")]static private const SHEET:Class;
		private var _length:Number;
		
		public function Gap() {
			super(30, SHEET);
			width = 24;
			offset.x = 15;
			_length = 0;
		}
		
		public function get length():Number {
			return _length;
		}
		
		public function set length(value:Number):void {
			_length = value;
		}
		
		
		
	}

}