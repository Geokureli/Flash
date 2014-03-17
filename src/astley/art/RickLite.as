package astley.art {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class RickLite extends FlxSprite {
		
		[Embed(source = "../../../res/astley/graphics/rick.png")] static private const SPRITE:Class;
		
		public function RickLite(x:Number = 0, y:Number = 0) {
			super(x, y);
			
			loadGraphic(SPRITE, true, false, 16, 32);
			
			var fartFrames:Array = [];
			for (var i:int = 1; i < frames - 1; i++) {
				
				fartFrames.push(i);
			}
			fartFrames.push(0);
			
			addAnimation("idle", [0]);
			addAnimation("farting", fartFrames, 15, false);
			addAnimation("dead", [frames-1]);
		}
		
	}

}