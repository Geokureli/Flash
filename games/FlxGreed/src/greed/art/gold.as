package greed.art {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class gold extends FlxSprite {
		
		public function gold(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y);
			makeGraphic(4, 4);
		}
		
	}

}