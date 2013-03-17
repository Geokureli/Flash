package art.Scenes {
	import art.DragBox;
	import flash.events.Event;
	import flash.geom.Point;
	import relic.art.Scene;
	/**
	 * ...
	 * @author George
	 */
	public class TutorialScene extends Scene{
		public function TutorialScene() {
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
		}
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			assets.autoGroup(DragBox, "draggers");			
		}
		override protected function addListeners():void {
			super.addListeners();
			for each(var dragger:DragBox in assets.group("draggers"))
				dragger.addEventListener(Event.CHANGE, onChange);
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			draw();
		}
		
		protected function onChange(e:Event):void {
			draw();
		}
		protected function draw():void {
			graphics.clear();
		}
		protected function drawRect(tl:Point, br:Point, ref:Point, border:int = 0x202020, h:int = 0x400040, v:int = 0x4040):void {
			graphics.lineStyle(2, border);
			graphics.drawRect(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
			if(ref != null){
				graphics.lineStyle(2, h);
				line(tl.x, ref.y, br.x, ref.y);
				graphics.lineStyle(2, v);
				line(ref.x, tl.y, ref.x, br.y);
			}
		}
		protected function line(x1:Number, y1:Number, x2:Number, y2:Number, ticks:int = 0):void {
			graphics.moveTo(x1, y1);
			graphics.lineTo(x2, y2);
		}
	}

}