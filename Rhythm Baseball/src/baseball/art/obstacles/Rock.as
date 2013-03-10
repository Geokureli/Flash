package baseball.art.obstacles 
{
	import baseball.art.RhythmAsset;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Rock extends RhythmAsset {
		static public var sprites:SpriteSheet;
		{
			sprites = new SpriteSheet(new Imports.Rock().bitmapData);
			sprites.clearBG();
			sprites.createGrid(48, 48);
			sprites.addAnimation("idle", Vector.<int>([0]));
			sprites.addAnimation("break", Vector.<int>([1, 2, 3, 4, 5]), false);
		}
		
		public function Rock(beat:Number) { super(beat); name = "rock"; }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			
			addAnimationSet(sprites);
			currentAnimation = "idle";
			shape = new Box(0, 16, 8, 32);
			y += 16;
		}
		
	}

}