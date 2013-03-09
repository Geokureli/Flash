package baseball.art.obstacles 
{
	import baseball.art.RhythmAsset;
	import baseball.beat.BeatKeeper;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Bomb extends RhythmAsset {
		static public var SPEED:int = -10;
		static public var sprites:SpriteSheet;
		{
			sprites = new SpriteSheet(new Imports.Bomb().bitmapData);
			sprites.clearBG();
			sprites.createGrid(16, 16);
			sprites.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));
		}
		
		public function Bomb(beat:Number) { super(beat); name = "bomb";}

		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			addAnimationSet(sprites);
			currentAnimation = "idle";
			shape = new Box(0, 0, 16, 16);
			y = 340;
			speed = SPEED;
		}
		override public function update():void {
			super.update();
			if(isRhythm && boundMode == BoundMode.DESTROY)
				y = (HERO.y + Math.pow(BeatKeeper.toBeatPixels(beat - BeatKeeper.beat) - Math.sqrt(HERO.y), 2)) / 2 + 30;
		}
	}

}