package astley.art.ui.buttons {
	/**
	 * ...
	 * @author George
	 */
	public class GKButton extends AnimatedButton {
		
		[Embed(source = "../../../../../res/astley/graphics/buttons/btn_gk.png")] static public const SPRITE:Class;
		
		static public const LINK:String = "http://geokureli.newgrounds.com/";
		
		public function GKButton(x:Number=0, y:Number=0) {
			super(x, y, SPRITE, 16, 13);
			
			link = LINK;
		}
		
	}

}