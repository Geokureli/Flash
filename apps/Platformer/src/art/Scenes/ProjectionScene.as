package art.Scenes 
{
	import art.DragBox;
	import art.Scene;
	import data.Vec2;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class ProjectionScene extends Scene
	{
		private var origin:DragBox, axis:DragBox, v:DragBox;
		
		public function ProjectionScene() { super(); }
		override protected function init(e:Event = null):void {
			super.init();
			origin.pos = new Vec2(stage.stageWidth / 2, stage.stageHeight / 2);
			axis.pos = new Vec2(stage.stageWidth / 2, stage.stageHeight / 2 - 100);
			v.pos = new Vec2(stage.stageWidth / 2 + 100, stage.stageHeight / 2 + 100);
			draw();
		}
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			addChild(origin = new DragBox());
			addChild(axis = new DragBox());
			addChild(v = new DragBox());
		}
		override protected function addListeners():void {
			super.addListeners();
			
			origin.addEventListener(Event.CHANGE, draw);
			v.addEventListener(Event.CHANGE, draw);
			axis.addEventListener(Event.CHANGE, draw);
		}
		override protected function removeListeners():void {
			super.removeListeners();
			
			origin.removeEventListener(Event.CHANGE, draw);
			v.removeEventListener(Event.CHANGE, draw);
			axis.removeEventListener(Event.CHANGE, draw);
		}
		override protected function enterFrame(e:Event):void {
			var v:Vec2 = this.v.pos.dif(origin.pos);
			if (right) v.rotation++;
			if (left) v.rotation--;
			if (up) v.length++;
			if (down) v.length--;
			this.v.pos = v.sum(origin.pos)
		}
		
		private function draw(e:Event = null):void {
			graphics.clear();
			var origin:Vec2 = this.origin.pos;
			var axis:Vec2 = this.axis.pos; axis.subtract(origin);
			var v:Vec2 = this.v.pos; v.subtract(origin);
			drawLine(origin, axis.sum(origin), 0x0080FF, true);
			drawLine(axis.rHand.sum(origin), origin, 0x00CCFF, true);
			drawArrow(origin, v.sum(origin));
			drawArrow(origin, v.project(axis).sum(origin), 0xFF00);
			drawArrow(origin, v.project(axis.rHand).sum(origin), 0xFF0000);
		}		
	}

}