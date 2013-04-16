package relic.shapes 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.collision.CollisionData;
	import relic.Vec2;
	import flash.display.Graphics;
	import flash.events.Event;
	/**
	 * ...
	 * @author George
	 */
	public class Box extends Shape {
		
		private var _width:Number,
					_height:Number;
					
		public function Box(x:Number, y:Number, width:Number, height:Number) {
			super();
			offset = new Vec2(x, y);
			this.width = width;
			this.height = height;
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
		}
		
		override public function debugDraw(g:Graphics):void {
			g.lineStyle(1, 0xFF00);
			g.drawRect(offset.x, offset.y, width, height);
		}
		
		override public function hitShape(dis:Vec2, shape:Shape):CollisionData {
			if (shape is Box)
				return BoxHitBox(this, shape as Box, dis);
			
			return null;
		}
		
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
			
			if (autoCenter) offset.x = -value/2;
		}
		
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = value;
			
			if (autoCenter) offset.y = -value/2;
		}
		
		
		override public function get left():Number { return super.left; }
		override public function get right():Number { return super.right + width; }
		override public function get top():Number { return super.top; }
		override public function get bottom():Number { return super.bottom + height; }
		
		static public function FromRect(rect:Rectangle):Box {
			return new Box(rect.x, rect.y, rect.width, rect.height);
		}
		
		override public function toString():String {
			return "[Box: left: " + left + " top:" + top + " right:" + right + " bottom:" + bottom + " ]";
		}
	}

}