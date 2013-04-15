package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Gap extends Obstacle {
		[Embed(source = "../../../res/sprites/gap.png")]static private const SHEET:Class;
		
		public function Gap() {
			super(30, SHEET);
			width = 24;
			offset.x = 15;
		}
		
	}

}