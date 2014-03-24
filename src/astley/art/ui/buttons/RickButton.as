package astley.art.ui.buttons {
	import org.flixel.FlxButton;
	/**
	 * ...
	 * @author George
	 */
	public class RickButton extends AnimatedButton {
		
		[Embed(source = "../../../../../res/astley/graphics/btn_rick.png")] static private const SPRITE:Class;
		
		public function RickButton(x:Number = 0, y:Number = 0) {
			
			super(x, y, SPRITE, 18, 19);
		}
	}
}