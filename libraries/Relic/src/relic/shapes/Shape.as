package relic.shapes 
{
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.collision.CollisionData;
	import relic.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class Shape extends EventDispatcher {
		
		public var density:Number;
		public var autoCenter:Boolean;
		
		public var vel:Vec2,
					offset:Vec2;
		
		public function Shape() {
			setDefaultValues();
		}
		protected function setDefaultValues():void {
			density = 1;
			autoCenter = false;
			vel = new Vec2();
			offset = new Vec2();
		}
		public function hitShape(dis:Vec2, shape:Shape):CollisionData { return null; }
		public function debugDraw(g:Graphics):void { }
		
		public function destroy():void { }
		
		public function get left():Number { return offset.x; }
		public function get right():Number { return offset.x; }
		public function get top():Number { return offset.y; }
		public function get bottom():Number { return offset.y; }
		
		public function hitPoint(p:Point):Boolean { return false; }
		
		static protected function BoxHitBox(b1:Box, b2:Box, dis:Vec2):CollisionData {
			var r:Rectangle = new Rectangle(b1.left - b2.right, b1.top - b2.bottom, b1.width + b2.width, b1.height + b2.height);
			if (r.contains(dis.x, dis.y)) {
				
				var projection:Vec2 = new Vec2();
				
				projection.x = (dis.x > 0 ? r.right - dis.x : r.left - dis.x);
				projection.y = (dis.y > 0 ? r.bottom - dis.y : r.top - dis.y);
					
				return new CollisionData(b1, b2, dis, projection);
			} 
			return null;
		}
		override public function toString():String {
			return "[Shape]";
		}
	}

}