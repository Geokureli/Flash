package krakel {
	import flash.geom.Rectangle;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	/**
	 * ...
	 * @author George
	 */
	public class KrkDepthBG extends FlxGroup{
		
		public function KrkDepthBG() { super(); }
		
		public function create(sprite:FlxSprite, topSpeed:Number, bottomSpeed:Number = 0):FlxSprite {
			add(sprite);
			
			var rect:Rectangle = new Rectangle(0, 0, sprite.width, 1);
			var speed:Number = topSpeed;
			var dif:Number = topSpeed - bottomSpeed;
			FlxScrollZone.add(sprite, rect, speed, 0);
			for (rect.y = 0; rect.y < sprite.height; rect.y++) {
				FlxScrollZone.createZone(sprite, rect, speed, 0);
				speed = bottomSpeed + (dif * (sprite.height - rect.y) / sprite.height);
			}
			return sprite;
		}
		
	}

}