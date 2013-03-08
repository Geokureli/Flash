package art 
{
	/**
	 * ...
	 * @author George
	 */
	public class Bomb extends Asset 
	{
		
		static private var sprites:SpriteSheet;
		{
			sprites = new SpriteSheet(new Imports.Bomb().bitmapData);
			sprites.clearBG();
			sprites.createGrid(16, 16);
			sprites.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));
		}
		
		public function Bomb() {
			super();
			addAnimationSet(sprites);
			currentAnimation = "idle";
		}
		
	}

}