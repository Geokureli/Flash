package baseball.art {
	import baseball.Imports;
	import relic.art.blitting.Blit;
	import relic.art.SpriteSheet;
	
	/**
	 * ...
	 * @author George
	 */
	public class BlitHero extends Blit {
		
		static private var sprites:SpriteSheet;
		
		private var startBeat:Number;
		{
			sprites = new SpriteSheet(new Imports.Hero().bitmapData);
			sprites.clearBG();
			sprites.createGrid(64, 64);
			sprites.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));
			sprites.addAnimation("slide", Vector.<int>([8, 9]), false, 1);
			sprites.addAnimation("slide_end", Vector.<int>([8]), true, 1);
			sprites.addAnimation("duck", Vector.<int>([10, 11]), false, 1);
			sprites.addAnimation("duck_end", Vector.<int>([10]),true, 1);
			sprites.addAnimation("jump", Vector.<int>([12, 12, 12, 12, 12, 12, 12, 12, 12]));
			sprites.addAnimation("swing", Vector.<int>([13, 14, 15, 15, 16, 17, 17]), true, 1);
			sprites.addAnimation("hit", Vector.<int>([8, 9]), false);
		}
		
		public function BlitHero() {
			super();
			addAnimationSet(sprites);
			currentAnimation = "idle";
		}
		
	}

}