package art 
{
	import data.Vec2;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class Scene extends Sprite 
	{
		protected var assets:Vector.<Asset>;
		protected var up:Boolean, down:Boolean, left:Boolean, right:Boolean;
		protected var drawLayer:Sprite, assetLayer:Sprite;
		
		public function Scene() 
		{
			super();
			super.addChild(assetLayer = new Sprite());
			super.addChild(drawLayer = new Sprite());
			assets = new Vector.<Asset>();
			addStaticChildren();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			up = left = down = right = false;
			addListeners();
		}
		protected function drawArrow(start:Vec2, end:Vec2, color:uint = 0x808080):void {
			var head:Vec2 = end.dif(start).unit;
			head.length = 10;
			drawLayer.graphics.beginFill(color);
			drawLayer.graphics.lineStyle(2, color);
			drawLayer.graphics.moveTo(start.x, start.y);
			drawLayer.graphics.lineTo(end.x, end.y);
			drawLayer.graphics.lineTo(end.x - head.x - head.y, end.y - head.y + head.x);
			drawLayer.graphics.lineTo(end.x - head.x + head.y, end.y - head.y - head.x);
			drawLayer.graphics.lineTo(end.x, end.y);
		}
		protected function drawLine(p1:Vec2, p2:Vec2, color:uint = 0x808080, extend:Boolean = false):void {
			var start:Vec2 = new Vec2(0, 0), end:Vec2 = new Vec2(stage.stageWidth, stage.stageHeight);
			if (p2.y == p1.y) { 
				start.y = p1.y;
				end.y = p2.y;
			} else {
				var dir:Vec2 = p2.dif(p1);
				if (dir.y > 0) {
					start.x = p1.x - dir.x * p1.y / dir.y;
					end.x = p2.x + dir.x * (end.y - p2.y) / dir.y;
				} else {
					start.x = p2.x + dir.x * p2.y / -dir.y;
					end.x = p1.x - dir.x * (end.y - p1.y) / -dir.y;
				}
			}
			drawLayer.graphics.lineStyle(2, color);
			drawLayer.graphics.moveTo(start.x, start.y);
			drawLayer.graphics.lineTo(end.x, end.y);
		}
		protected function addStaticChildren():void { }
		protected function addListeners():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandle);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		protected function enterFrame(e:Event):void { }
		protected function keyHandle(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case 37: left = e.type == KeyboardEvent.KEY_DOWN; break;
				case 38: up = e.type == KeyboardEvent.KEY_DOWN; break;
				case 39: right = e.type == KeyboardEvent.KEY_DOWN; break;
				case 40: down = e.type == KeyboardEvent.KEY_DOWN; break;
			}
		}
		protected function removeListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyHandle);
			
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		override public function addChild(child:DisplayObject):DisplayObject {
			return assetLayer.addChild(child);
		}
		override public function removeChild(child:DisplayObject):DisplayObject {
			return assetLayer.removeChild(child);
		}
		public function destroy():void {
			removeListeners();
		}
	}

}