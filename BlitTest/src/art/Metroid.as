package art {
	import relic.art.blitting.Blit;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.Random;
	import relic.data.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Metroid extends Blit {
		static private const SPEED:int = 5;
		
		[Embed(source = "../../res/metroid.png", mimeType = "image/png")]
		static private var Src:Class
		static private var sprites:SpriteSheet;
		{
			sprites = new SpriteSheet(new Src().bitmapData);
			sprites.clearBG();
			sprites.createGrid();
			sprites.addAnimation("met_0", Vector.<int>([0,1]), true, 4);
			sprites.addAnimation("met_1", Vector.<int>([2,3]), true, 4);
			sprites.addAnimation("met_2", Vector.<int>([4,5]), true, 4);
		}
		public function Metroid() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			animations["idle"] = sprites.animations["met_" + Random.random(3)];
			currentAnimation = "idle";
			name = "metroid";
			
			vel.x = Random.random(2) * SPEED * 2 - SPEED;
			vel.y = Random.random(2) * SPEED * 2 - SPEED;
			boundMode = BoundMode.BOUNCE;
			shape = new Box(0, 0, 25, 25);
		}
	}

}