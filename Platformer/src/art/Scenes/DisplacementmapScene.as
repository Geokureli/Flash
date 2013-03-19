package art.Scenes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.Scene;
	import relic.data.Vec2;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.display.BitmapDataChannel;
	
	/**
	 * ...
	 * @author George
	 */
	public class DisplacementmapScene extends Scene {
		
		static private const BLUR:int = 150;
		
		public function DisplacementmapScene() {
			super();
			
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			var bm:Bitmap = gridMap;
			var map:Bitmap = circleMap;
			//map.bitmapData.applyFilter(
				//map.bitmapData,
				//map.bitmapData.rect,
				//new Point(),
				//new BevelFilter(
					//40,
					//45,
					//0xFF0000,
					//1,
					//0,
					//0,
					//40,
					//40,
					//4,
					//3
				//)
			//);
			//map.bitmapData.applyFilter(
				//map.bitmapData,
				//map.bitmapData.rect,
				//new Point(),
				//new BlurFilter(
					//BLUR,
					//BLUR,
					//1
				//)
			//);
			addChild(bm);
			bm.filters = [new DisplacementMapFilter(
					map.bitmapData,
					new Point(),
					BitmapDataChannel.RED,
					BitmapDataChannel.GREEN,
					200,
					200,
					DisplacementMapFilterMode.CLAMP,
					0,
					0
				)
			];
			
		}
		private function get gridMap():Bitmap{
			var b:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight));
			var rect:Rectangle = new Rectangle(0, 0, 1, b.bitmapData.height);
			for (; rect.x < b.bitmapData.width; rect.x += 25) {
				b.bitmapData.fillRect(rect, 0);				
			}
			rect.width = b.bitmapData.width;
			rect.height = 1;
			rect.x = 0;
			for (; rect.y < b.bitmapData.height; rect.y += 25) {
				b.bitmapData.fillRect(rect, 0);				
			}
			return b;
		}
		private function get circleMap():Bitmap {
			var b:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x808080));
			var p:Vec2 = new Vec2();
			var mid:Vec2 = new Vec2(Math.ceil(b.bitmapData.width/2), Math.ceil(b.bitmapData.height/2));
			var color:int = 0x00FF00, r:int, g:int;
			for (p.x = 0; p.x <= b.bitmapData.width; p.x++) {
				for (p.y = 0; p.y <= b.bitmapData.height; p.y++) {
					if (p.dif(mid).length < mid.x - BLUR / 2) {
						var x:Number = 1 - p.x / b.bitmapData.width;
						var y:Number = 1 - p.y / b.bitmapData.height;
						g = Math.sqrt(1-x*x) * 0xFF;
						r = Math.sqrt(1-y*y) * 0xFF;
						b.bitmapData.setPixel(p.x, p.y, r<<16|g<<8);
					}
				}
			}
			return b;
			
		}
		
	}

}