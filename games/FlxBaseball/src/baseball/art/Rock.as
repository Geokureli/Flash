package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Rock extends Obstacle {
		[Embed(source = "../../../res/sprites/rock.png")] static private const SHEET:Class;
		public function Rock() {
			super(16);
			loadGraphic(SHEET, true, false, 48, 48);
			addAnimation("idle", [0]);
			addAnimation("break", [1, 2, 3, 4, 5], 12, false);
			//width = 8;
		}
		
		override public function pass():void {
			super.pass();
			play("break");
		}
		override public function revive():void {
			super.revive();
			play("idle");
		}
		
	}

}