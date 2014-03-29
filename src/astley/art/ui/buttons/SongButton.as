package astley.art.ui.buttons {
	/**
	 * ...
	 * @author George
	 */
	public class SongButton extends AnimatedButton {
		
		[Embed(source = "../../../../../res/astley/graphics/buttons/btn_song.png")] static private const SPRITE:Class;
		static private const LINK:String = "http://www.rickastley.co.uk/";
		
		public function SongButton(x:Number = 0, y:Number = 0) {
			super(x, y, SPRITE, 19, 17);
			
			link = LINK;
		}
		
	}

}