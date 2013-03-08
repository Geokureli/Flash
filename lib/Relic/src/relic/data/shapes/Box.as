package relic.data.shapes 
{
	import relic.data.Vec2;
	import flash.display.Graphics;
	import flash.events.Event;
	/**
	 * ...
	 * @author George
	 */
	public class Box extends Shape 
	{
		private var _width:Number, _height:Number;
		public var offset:Vec2;
		
		public function Box(x:Number, y:Number, width:Number, height:Number) {
			offset = new Vec2(x, y);
			this.width = width;
			this.height = height;
		}
		
		override public function debugDraw(g:Graphics):void {
			g.lineStyle(1, 0xFF00);
			g.drawRect(offset.x, offset.y, width, height);
		}
		override public function hitShape(dis:Vec2, shape:Shape):Boolean 
		{
			if (shape is Box) return BoxHitBox(this, shape as Box, dis);
			return false;
		}
		override public function get left():Number { return offset.x; }
		override public function get right():Number { return width + offset.x; }
		override public function get top():Number { return offset.y; }
		override public function get bottom():Number { return height + offset.y; }
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function set width(value:Number):void {
			_width = value;
			if (autoCenter) offset.x = -value / 2;
			//dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set height(value:Number):void {
			_height = value;
			if (autoCenter) offset.y = -value/2;
			//dispatchEvent(new Event(Event.CHANGE));
		}
	}

}