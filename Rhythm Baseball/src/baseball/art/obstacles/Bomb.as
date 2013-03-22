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
		
		static public var SPRITES:SpriteSheet;
		{
			SPRITES = new SpriteSheet(new Imports.Bomb().bitmapData);
			SPRITES.clearBG();
			SPRITES.createGrid();
			SPRITES.createDefualtAnimation();
		}
		
		static private const crest:int = 25;
		static public var SPEED:int = -10;
		public function Bomb() { super(); id = "bomb";}
		
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			blit.addAnimationSet(SPRITES);
			shape = new Box(0, 0, 16, 16);
			y += 26;
			//speed += SPEED;
			visible = false;
		}
		override public function update():void {
			super.update();
			const w:Number = 1000;
			if(isRhythm && boundMode == BoundMode.DESTROY){
				y = Math.pow((((HERO.x - x + 48) * 3 + w) / w), 2) * (HERO.y - crest) + crest;
				if (y < HERO.y - 64) visible = true;
			}
		}
	}
}