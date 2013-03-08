package art 
{
	import data.Vec2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class DragBox extends Sprite 
	{
		static public var SIZE:int = 10;
		public function DragBox(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			graphics.lineStyle(1);
			graphics.beginFill(0x808080);
			graphics.drawRect( -SIZE/2, -SIZE/2, SIZE, SIZE);
			graphics.endFill();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
		}
		
		private function mouseHandle(e:MouseEvent):void 
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
				case MouseEvent.MOUSE_MOVE:
					x = e.stageX;
					y = e.stageY;
					dispatchEvent(new Event(Event.CHANGE));
					break;
			}
		}
		public function get pos():Vec2 { return new Vec2(x, y); }
		public function set pos(v:Vec2):void { x = v.x; y = v.y; dispatchEvent(new Event(Event.CHANGE)); }
	}

}