package baseball.art.obstacles 
{
	import baseball.art.Obstacle;
	import relic.beat.BeatKeeper;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Bomb extends Obstacle {
		static private const crest:int = 25;
		static public var SPEED:int = -10;
		static public var sprites:SpriteSheet;
		{
			sprites = new SpriteSheet(new Imports.Bomb().bitmapData);
			sprites.clearBG();
			sprites.createGrid(16, 16);
			sprites.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));
		}
		
		public function Bomb() { super(); name = "bomb";}

		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			addAnimationSet(sprites);
			currentAnimation = "idle";
			shape = new Box(0, 0, 16, 16);
			y += 26;
			//speed += SPEED;
			visible = false;
		}
		override public function update():void {
			super.update();
			const w:Number = stage.stageWidth + 200;
			if(isRhythm && boundMode == BoundMode.DESTROY){
				y = Math.pow((((HERO.x - x + 8) * 3 + w) / w), 2) * (HERO.y - crest) + crest;
				if (y < HERO.y - 64) visible = true;
			}
		}
	}

}