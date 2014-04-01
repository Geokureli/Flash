package astley.art.ui {
	import krakel.KrkBitmapFont;
	
	/**
	 * ...
	 * @author George
	 */
	public class CreditText extends KrkBitmapFont {
		
		[Embed(source = "../../../../res/astley/graphics/text/letters_med.png")] static public const FONT:Class;
		
		public function CreditText(x:int = 0, y:int = 0, text:String = "") {
			super(FONT, 6, 9, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", 36);
			
			this.x = x;
			this.y = y;
			this.text = text.toUpperCase();
		}
		
	}

}