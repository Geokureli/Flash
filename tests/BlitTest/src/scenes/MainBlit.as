package scenes {
	import art.Metroid;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.blitting.BlitScene;
	import relic.data.Random;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class MainBlit extends BlitScene {
		private var rect:Rectangle;
		
		public function MainBlit() { super(new BitmapData(400, 300)); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			rect = bitmapData.rect.clone();
			rect.width -= 25;
			rect.height -= 25;
			scaleX = scaleY = 2;
		}
		override protected function createLayers():void {
			super.createLayers();
			autoGroup(Metroid, "metroid");
			autoName("metroid");
		}
		override public function update():void {
			super.update();
			spawnMetroid();
		}
		
		private function spawnMetroid():void {
			var spawn:Vec2 = Random.randomVec2(rect);
			place("front", add(new Metroid()), { x:spawn.x, y:spawn.y } );
		}
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.type == KeyboardEvent.KEY_DOWN) trace(group("metroid").length);
		}
	}

}