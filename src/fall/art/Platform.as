package fall.art {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Platform extends FlxSprite {
		
		static public const WIDTH:Number = 32;
		
		public function Platform() {
			super();
			makeGraphic(WIDTH, 16, 0xFF0000);
		}
		override public function revive():void {
			super.revive();
		}
	}

}