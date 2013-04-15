package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Base extends Obstacle {
		[Embed(source = "../../../res/sprites/bases.png")] static private const SHEET:Class;
		public function Base() {
			super(54);
			loadGraphic(SHEET, true, false, 24, 14);
			addAnimation("base", [0]);
			addAnimation("plate", [1]);
			play("base");
			scale.x = scale.y = 2;
		}
		
	}

}