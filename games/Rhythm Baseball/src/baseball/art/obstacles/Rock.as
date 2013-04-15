package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import baseball.Imports;
	import relic.Asset;
	import relic.art.blitting.SpriteSheet;
	import relic.shapes.Box;
	import relic.shapes.Shape;
	
	/**
	 * ...
	 * @author George
	 */
	public class Rock extends Obstacle {
		
		static public var SPRITES:SpriteSheet;
		
		{
			SPRITES = new SpriteSheet(new Imports.Rock().bitmapData);
			SPRITES.clearBG();
			SPRITES.createGrid();
			SPRITES.addAnimation(null, "idle", [0]);
			SPRITES.addAnimation(null, "break", [1, 2, 3, 4, 5], false);
		}
		
		public function Rock() { super(SPRITES); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			id = "rock";
			
			shape = new Box(0, 16, 8, 32);
			y += 16;
		}
	}
}