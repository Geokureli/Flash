package astley.art.ui.buttons {
	/**
	 * ...
	 * @author George
	 */
	public class MEHButton extends AnimatedButton {
		
		[Embed(source = "../../../../../res/astley/graphics/buttons/btn_meh.png")] static public const SPRITE:Class;
		
		static public const LINK:String = "https://itunes.apple.com/us/artist/mehware/id296615880";
		
		public function MEHButton(x:Number=0, y:Number=0) {
			super(x, y, SPRITE, 25, 13);
			
			link = LINK;
		}
		
	}

}