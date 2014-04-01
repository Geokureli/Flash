package astley.art {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class EndPipe extends FlxSprite {
		
		[Embed(source = "../../../res/astley/graphics/end_pipe.png")] static public const SPRITE:Class;
		
		public function EndPipe(x:Number = 0, y:Number = 0) { super(x, y, SPRITE); }
		
	}

}