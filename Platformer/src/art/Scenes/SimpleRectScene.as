package art.Scenes {
	/**
	 * ...
	 * @author George
	 */
	public class SimpleRectScene extends TutorialScene {
		
		public function SimpleRectScene() {
			
		}
		
		override protected function draw():void {
			graphics.clear();
			var tl1:Asset, br1:Asset, tl2:Asset, br2:Asset, ref1:Asset, ref2:Asset;
			ref1 = asset("p1")
			tl1 = asset("tl1");
			br1 = asset("br1");
			ref2 = asset("p2")
			tl2 = asset("tl2");
			br2 = asset("br2");
			var sumRect:Rectangle = new Rectangle(
				rect1.left - rect2.right,
				rect1.top - rect2.bottom,
				rect1.width + rect2.width,
				rect1.height + rect2.height
			)
			var color:int = sumRect.containsPoint(new Point(ref2.x-ref1.x, ref2.y-ref1.y)) ? 0x00FF00 : 0xFFFFFF;
			
			sumRect.x += ref1.x;
			sumRect.y += ref1.y;
			drawRect(sumRect.topLeft, sumRect.bottomRight, new Point(ref1.x, ref1.y));
			drawRect(new Point(tl1.x, tl1.y), new Point(br1.x, br1.y), new Point(ref1.x, ref1.y), color, 0xFF00FF, 0xFFFF);
			drawRect(new Point(tl2.x, tl2.y), new Point(br2.x, br2.y), new Point(ref2.x, ref2.y), color);
			
		}
	}

}