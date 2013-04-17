package art {
	import com.saia.starlingPunk.SPEntity;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author George
	 */
	public class Card extends SPEntity {
		[Embed(source = "../../res/card.jpg")] static public const CARD:Class;
		public function Card() {
			//addChild(Image.fromBitmap(new Bitmap(new BitmapData(100, 100))));
			//var tex:Texture = Texture.fromBitmapData(new BitmapData(100, 100));
			addChild(Image.fromBitmap(new CARD()));
			
		}
		
	}

}