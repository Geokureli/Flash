package relic.data.shapes 
{
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import relic.data.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class Shape extends EventDispatcher
	{
		public var density:Number;
		public var autoCenter:Boolean;
		
		public function Shape() 
		{
			density = 1;
			autoCenter = false;
		}
		public function hitShape(dis:Vec2, shape:Shape):Boolean { return false; }
		public function debugDraw(g:Graphics):void { }
		
		public function destroy():void { }
		
		public function get left():Number { return 0; }
		public function get right():Number { return 0; }
		public function get top():Number { return 0; }
		public function get bottom():Number { return 0; }
		
		static protected function BoxHitBox(b1:Box, b2:Box, dis:Vec2):Boolean {
			var r:Rectangle = new Rectangle(b1.left - b2.right, b1.top - b2.bottom, b1.width + b2.width, b1.height + b2.height);
			return r.contains(dis.x, dis.y);
		}
	}

}