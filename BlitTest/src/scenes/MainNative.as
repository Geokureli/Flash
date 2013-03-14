package scenes {
	import art.Metroid;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import relic.art.Asset;
	import relic.art.Scene;
	import relic.data.Random;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class MainNative extends Scene {
		private var rect:Rectangle;
		
		public function MainNative() { super(); }
		
		override protected function init(e:Event = null):void {
			super.init(e);
			scaleX = scaleY = 2;
			rect = new Rectangle(0, 0, (stage.stageWidth - 25) / scaleX, (stage.stageHeight - 25) / scaleY);
			Asset.defaultBounds = rect;
		}
		override protected function createLayers():void {
			super.createLayers();
			assets.autoGroup(Metroid, "metroid");
			assets.autoName("metroid");
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
			if (e.type == KeyboardEvent.KEY_DOWN) trace(assets.group("metroid").length);
		}
	}

}