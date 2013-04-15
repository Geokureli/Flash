package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Bomb extends Obstacle {
		[Embed(source="../../../res/sprites/bomb.png")] static private const SHEET:Class
		public function Bomb() {
			super(30);
			loadGraphic(SHEET, true, false, 16, 16);
			addAnimation("hit", [0,1,2,3,4,5,6,7], 15)
		}
		override public function pass():void {
			super.pass();
			isRhythm = false
			velocity.x = -SCROLL*35;
			velocity.y = -800;
			acceleration.y = 1600;
			play("hit");
		}
	}

}