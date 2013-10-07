package baseball.art {
	import krakel.helpers.Random;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Cloud extends FlxSprite {
		
		[Embed(source="../../../res/baseball/sprites/cloud.png")] static private var CLOUD:Class;
		
		public function Cloud(x:Number, y:Number) {
			super(x + Random.between(-80, 80), y);
			
			velocity.x = Obstacle.SCROLL * FlxG.flashFramerate / 8;
			
			loadGraphic(CLOUD, true, false, 48, 32)
			addAnimation("0", [0]);
			addAnimation("1", [1]);
			addAnimation("2", [2]);
			
			play(Random.between(3).toString());
		}
		override public function update():void {
			super.update();
			if (x < -width) x = FlxG.width;
		}
	}

}