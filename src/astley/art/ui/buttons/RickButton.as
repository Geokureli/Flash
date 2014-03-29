package astley.art.ui.buttons {
	import org.flixel.FlxButton;
	/**
	 * ...
	 * @author George
	 */
	public class RickButton extends AnimatedButton {
		
		[Embed(source = "../../../../../res/astley/graphics/buttons/btn_rick.png")] static private const SPRITE:Class;
		static public const LINK:String = "http://piq.codeus.net/gallery/?user=11742";
		
		public function RickButton(x:Number = 0, y:Number = 0) {
			super(x, y, SPRITE, 18, 19);
			
			link = LINK;
		}
	}
}