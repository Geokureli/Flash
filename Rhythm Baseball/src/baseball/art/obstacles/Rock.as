package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.shapes.Box;
	
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
			SPRITES.addAnimation("idle", Vector.<int>([0]));
			SPRITES.addAnimation("break", Vector.<int>([1, 2, 3, 4, 5]), false);
		}
		
		public function Rock() { super(); id = "rock"; }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			
			blit.addAnimationSet(SPRITES);
			shape = new Box(0, 16, 8, 32);
			y += 16;
		}	
	}
}