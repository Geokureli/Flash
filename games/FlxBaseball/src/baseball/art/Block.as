package baseball.art {
	/**
	 * ...
	 * @author George
	 */
	public class Block extends Obstacle {
		
		[Embed(source = "../../../res/sprites/block.png")] static private const SHEET:Class;
		
		public function Block() {
			super(8, SHEET);
		}
		
	}

}