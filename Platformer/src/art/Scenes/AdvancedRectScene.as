package art.Scenes {
	import art.DragBox;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.Asset;
	/**
	 * ...
	 * @author George
	 */
	public class AdvancedRectScene extends TutorialScene {
		
		private var rect1:Rectangle, rect2:Rectangle;
		
		public function AdvancedRectScene() { super(); }
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			place("front", add(new DragBox(200, 100), "p1" , "rect1"));
			place("front", add(new DragBox(125, 25 ), "tl1", "rect1"));
			place("front", add(new DragBox(275, 175), "br1", "rect1"));
			place("front", add(new DragBox(600, 100), "p2" , "rect2"));
			place("front", add(new DragBox(525,  25), "tl2", "rect2"));
			place("front", add(new DragBox(675, 100), "br2", "rect2"));
			
		}
		
		override protected function init(e:Event = null):void {
			var ref:Asset = asset("p1");
			var tl:Asset = asset("tl1"); 
			var br:Asset = asset("br1"); 
			rect1 = new Rectangle(tl.x - ref.x, tl.y - ref.y, br.x - tl.x, br.y - tl.y);
			ref = asset("p2");
			tl = asset("tl2"); 
			br = asset("br2"); 
			rect2 = new Rectangle(tl.x - ref.x, tl.y - ref.y, br.x - tl.x, br.y - tl.y);
			super.init(e);
		}
		
		override protected function onChange(e:Event):void {
			var ref:Asset;
			var tl:Asset; 
			var br:Asset; 
			switch(e.currentTarget.name) {
				case "p1":
					tl = asset("tl1");
					br = asset("br1");
					ref = e.currentTarget as Asset
					tl.x = ref.x + rect1.left;
					tl.y = ref.y + rect1.top;
					br.x = ref.x + rect1.right;
					br.y = ref.y + rect1.bottom;
					break;
				case "p2":
					tl = asset("tl2");
					br = asset("br2");
					ref = e.currentTarget as Asset;
					tl.x = ref.x + rect2.left;
					tl.y = ref.y + rect2.top;
					br.x = ref.x + rect2.right;
					br.y = ref.y + rect2.bottom;
					break;
				case "tl1":
					ref = asset("p1");
					br = asset("br1");
					tl = e.currentTarget as Asset;
					if (tl.x > br.x - 20) tl.x = br.x - 20;
					if (tl.y > br.y - 20) tl.y = br.y - 20;
					rect1.left = tl.x - ref.x;
					rect1.top = tl.y - ref.y;
					break;
				case "tl2":
					ref = asset("p2");
					br = asset("br2");
					tl = e.currentTarget as Asset;
					if (tl.x > br.x - 20) tl.x = br.x - 20;
					if (tl.y > br.y - 20) tl.y = br.y - 20;
					rect2.left = tl.x - ref.x;
					rect2.top = tl.y - ref.y;
					break;
				case "br1":
					ref = asset("p1");
					tl = asset("tl1");
					br = e.currentTarget as Asset;
					if (br.x < tl.x + 20) br.x = tl.x + 20;
					if (br.y < tl.y + 20) br.y = tl.y + 20;
					rect1.right = br.x - ref.x;
					rect1.bottom = br.y - ref.y;
					break;
				case "br2":
					ref = asset("p2");
					tl = asset("tl2");
					br = e.currentTarget as Asset;
					if (br.x < tl.x + 20) br.x = tl.x + 20;
					if (br.y < tl.y + 20) br.y = tl.y + 20;
					rect2.right = br.x - ref.x;
					rect2.bottom = br.y - ref.y;
					break;
			}
			super.onChange(e);
		}
		
		override protected function draw():void {
			super.draw();
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