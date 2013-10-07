package algae.art {
	import krakel.KrkSprite;
	import org.flixel.FlxPoint;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author George
	 */
	public class Chiton extends KrkSprite {
		
		[Embed(source="../../../res/algae/graphics/chiton.png")] static private const SPRITE:Class
		static public const MOVE_TIME:Number = 1;
		
		public var targetPos:FlxPoint;
		
		public function Chiton(x:Number=0, y:Number=0) {
			super(x, y);
			
			loadRotatedGraphic(SPRITE, 4);
			
			scale.x = scale.y = .5;
			displayMode = STRETCH;
			
			targetPos = new FlxPoint(x, y);
			
			//offset.x = 32;
			//offset.y = 64;
			//
			//width = 10;
			//height = 10;
		}
		
		public function move(movement:FlxPoint):void {
			targetPos.x += movement.x;
			targetPos.y += movement.y;
			
			if (movement.x == 0)
				angle = movement.y > 0 ? 90 : -90;
			else angle = movement.y > 0 ? 0 : 180;
			
			TweenMax.to(this, MOVE_TIME, { x:targetPos.x, y:targetPos.y } );
		}
		
	}

}