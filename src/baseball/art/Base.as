package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Base extends Obstacle {

		[Embed(source = "../../../res/baseball/sprites/bases.png")] static private const SHEET:Class;
		
		private var _isLast:Boolean;
		
		public function Base() {
			super(54);
			loadGraphic(SHEET, true, false, 24, 14);
			addAnimation("base", [0]);
			addAnimation("plate", [1]);
			play("base");
			scale.x = scale.y = 2;
			isLast = false;
		}
		
		public function get isLast():Boolean { return _isLast; }
		public function set isLast(value:Boolean):void {
			_isLast = value;
			play(value ? "plate" : "base" );
		}
		
	}

}