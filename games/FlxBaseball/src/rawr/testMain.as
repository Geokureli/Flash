package rawr {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class testMain extends Sprite {
		private var bm:BorderMaker;
		
		public function testMain() {
			super();
			var bmp:Bitmap = new Bitmap(
				new BorderMaker(20, 20, 4, BorderMaker.getRandomTiles(30,17))
			);
			addChild(bmp);

			bmp.x = (stage.stageWidth - bmp.width) / 2;
			bmp.y = (stage.stageHeight - bmp.height) / 2;

			//new < Vector.<Boolean> > [
				//new <Boolean>[false,false,false,false,false,false, true, true],
				//new <Boolean>[false, true, true,false,false,false,false, true],
				//new <Boolean>[false, true, true,false,false,false,false,false],
				//new <Boolean>[false,false,false,false,false,false, true,false],
				//new <Boolean>[false,false,false,false,false,false,false,false],
				//new <Boolean>[false,false,false, true,false,false,false,false],
				//new <Boolean>[false,false, true, true, true,false,false,false],
				//new <Boolean>[false, true, true, true, true, true,false,false]
			//]
		}
		
	}

}