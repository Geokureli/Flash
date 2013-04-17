package art {
	import com.saia.starlingPunk.SPEntity;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author George
	 */
	public class Card extends SPEntity {
		[Embed(source = "../../res/card.jpg")] static public const CARD:Class;
		public function Card() {
			addChild(Image.fromBitmap(new CARD()));
		}
		
	}

}