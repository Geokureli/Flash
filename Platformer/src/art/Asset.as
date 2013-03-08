package art 
{
	import data.AnimationEvent;
	import data.Vec2;
	import data.BoundMode;
	import data.shapes.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class Asset extends MovieClip 
	{
		public var vel:Vec2, acc:Vec2, origin:Vec2, maxSpeed:Vec2;
		public var bounds:Rectangle;
		public var friction:Number, bounce:Number;
		public var shape:Shape;
		public var boundMode:String;
		public var animations:Object;
		private var _currentAnimation:String;
		public var bm:Bitmap;
		public var frame:int;
		public function Asset() 
		{
			super();
			setDefaultValues();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function setDefaultValues():void {
			frame = 0;
			vel = new Vec2();
			acc = new Vec2();
			origin = new Vec2();
			maxSpeed = new Vec2( -1, -1);
			bounds = new Rectangle();
			friction = 0;
			bounce = 0;
			animations = { };
			boundMode = BoundMode.NONE;
			addChild(bm = new Bitmap());
		}
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function addAnimationSet(sheet:SpriteSheet):void {
			for (var i:String in sheet.animations) 
				animations[i] = sheet.animations[i];
		}
		public function update():void {
			vel.add(acc);
			if (maxSpeed.x > -1) {
				if (vel.x > maxSpeed.x) vel.x = maxSpeed.x;
				if (vel.x < -maxSpeed.x) vel.x = -maxSpeed.x;
			}
			if (maxSpeed.y > -1) {
				if (vel.y > maxSpeed.y) vel.y = maxSpeed.y;
				if (vel.y < -maxSpeed.y) vel.y = -maxSpeed.y;
			}
			x += vel.x;
			y += vel.y;
			vel.multiply(1 - friction);
			switch(boundMode) {
				case BoundMode.LOCK:
					if (right > bounds.right)	right = bounds.right;
					if (left  < bounds.left)	left = bounds.left;
					if (bottom > bounds.bottom)	bottom = bounds.bottom;
					if (top < bounds.top)		top = bounds.top;
					break;
				case BoundMode.BOUNCE:
					
					break;
			}
			if (currentAnimation != null) {
				if (frame > anim.numFrames * anim.rate) {
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
				}
				var newBMD:BitmapData = animations[currentAnimation].getFrame(frame);
				if (bm.bitmapData != newBMD) bm.bitmapData = newBMD;
			}
			frame++;
		}
		public function get left():Number {
			if (shape != null) return x + origin.x + shape.left;
			return x + origin.x;
		}
		public function set left(value:Number):void {
			if (shape != null) x  = value - origin.x - shape.left;
			else x = value - origin.x;
		}
		public function get right():Number {
			if (shape != null) return x + origin.x + shape.right;
			return x + origin.x;
		}
		public function set right(value:Number):void {
			if (shape != null) x  = value - origin.x - shape.right;
			else x = value - origin.x;
		}
		public function get top():Number {
			if (shape != null) return y + origin.y + shape.top;
			return y + origin.y;
		}
		public function set top(value:Number):void {
			if (shape != null) y  = value - origin.y - shape.top;
			else y = value - origin.y;
		}
		public function get bottom():Number {
			if (shape != null) return y + origin.y + shape.bottom;
			return y + origin.y;
		}
		public function set bottom(value:Number):void {
			if (shape != null) y  = value - origin.y - shape.bottom;
			else y = value - origin.y;
		}
		public function get anim():Animation {
			if(currentAnimation in animations)
				return animations[currentAnimation];
			return null;
		}
		public function get currentAnimation():String 
		{
			return _currentAnimation;
		}
		
		public function set currentAnimation(value:String):void 
		{
			if (_currentAnimation != value) frame = 0;
			_currentAnimation = value;
		}
	}

}