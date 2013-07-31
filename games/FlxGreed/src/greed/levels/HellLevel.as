package greed.levels {	
	import greed.art.Gold;
	import krakel.KrkSprite;
	import org.flixel.FlxSprite;
	import greed.art.Hero;
	/**
	 * ...
	 * @author George
	 */
	public class HellLevel extends GreedLevel {
		
		[Embed(source = "../../../res/graphics/greed_hell.png")] static public const TILES:Class;
		
		public function HellLevel() {
			super();
		}
		
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			if(sprite is Gold && !(sprite && treasure))
				sprite.color = 0xFF0000;
			return sprite;
		}
		
		override public function update():void {
			super.update();
			if (isThief) _hero.kill();
		}
		
	}

}