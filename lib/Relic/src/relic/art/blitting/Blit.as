package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import relic.art.Animation;
	import relic.art.IAsset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.events.AnimationEvent;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blit extends EventDispatcher implements IAsset {
		private var _x:Number,
					_y:Number,
					_width:Number,
					_height:Number;
		
		private var _vel:Vec2,
					_acc:Vec2,
					_maxSpeed:Vec2;
		
		private var _spawned:Boolean,
					_trash:Boolean,
					_live:Boolean;
		
		private var _currentAnimation:String,
					_boundMode:String,
					_name:String;
		
		private var _friction:Number,
					_bounce:Number;
		
		private var _shape:Shape;
		
		private var debugGraphics:flash.display.Shape;
		
		private var _bounds:Rectangle;
		
		internal var _parent:BlitLayer;
		
		private var frame:int;
		private var animations:Object;
		
		public function Blit() {
			setDefaultValues();
			
		}
		
		protected function setDefaultValues():void {
			_x = _y = 0;
			_vel = new Vec2();
			_acc = new Vec2();
			_maxSpeed = new Vec2();
			_boundMode = BoundMode.NONE;
			_friction = 1;
			_bounce = 0;
			_spawned = false;
			_trash = false;
			_live = true;
			
			animations = { };
		}
		public function draw(target:BitmapData):void {
			target.draw(
				animations[currentAnimation].getFrame(frame),
				new Matrix()
			);
		}
		
		public function addAnimationSet(sheet:SpriteSheet):void {
			for (var i:String in sheet.animations) 
				animations[i] = sheet.animations[i];
		}
		
		/* INTERFACE relic.art.IAsset */
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; }
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; }
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		public function get left():Number	{ return _x + (_shape == null ? 0 : _shape.left); }
		public function get right():Number	{ return _x + (_shape == null ? 0 : _shape.right); }
		public function get top():Number	{ return _y + (_shape == null ? 0 : _shape.top); }
		public function get bottom():Number	{ return _y + (_shape == null ? 0 : _shape.bottom); }
		
		public function set left(value:Number):void		{ _x = value - (_shape == null ? 0 : _shape.left); }
		public function set right(value:Number):void	{ _x = value - (_shape == null ? 0 : _shape.right); }
		public function set top(value:Number):void		{ _y = value - (_shape == null ? 0 : _shape.top); }
		public function set bottom(value:Number):void	{ _y = value - (_shape == null ? 0 : _shape.bottom); }
		
		public function get anim():Animation { return null; }
		
		public function get currentAnimation():String { return _currentAnimation; }
		public function set currentAnimation(value:String):void {
			if (_currentAnimation != value) frame = 0;
			_currentAnimation = value;
		}
		
		public function get boundMode():String { return _boundMode; }
		public function set boundMode(value:String):void { _boundMode = value; }
		
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		public function isTouching(asset:IAsset):Boolean {
			if(shape == null || asset.shape == null) return false;
			return shape.hitShape(
				new Vec2(
					asset.left - left,
					asset.top - top
				),
				asset.shape
			);
		}
		
		public function update():void {
			
			frame++;
		}
		
		protected function move():void {
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
		}
		protected function collide():void {
			switch(boundMode) {
				case BoundMode.LOCK:
					if (right > bounds.right)	right = bounds.right;
					if (left  < bounds.left)	left = bounds.left;
					if (bottom > bounds.bottom)	bottom = bounds.bottom;
					if (top < bounds.top)		top = bounds.top;
					break;
				case BoundMode.BOUNCE:
					
					break;
				case BoundMode.DESTROY:
					if (spawned && isOffStage)
						kill();
					break;
			}
			if (!spawned && !isOffStage)
				spawned = true; 
		}
		
		protected function updateGraphics():void {
			if (currentAnimation != null) {
				if (frame > anim.numFrames * anim.rate) {
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, {name:currentAnimation}));
				}
				//var newBMD:BitmapData = animations[currentAnimation].getFrame(frame);
				//if (bm.bitmapData != newBMD) bm.bitmapData = newBMD;
				//if (graphicBounds == null) setGraphicBounds();
			}
			frame++;
		}
		
		
		private function get isOffStage():Boolean {
			if (bounds == null) return false;
			return left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top;
		}
		
		public function kill():void { }
		
		public function destroy():void {
			_currentAnimation = _name = null;
			if(_parent != null) _parent.remove(this);
			_parent = null;
			_shape = null;
		}
		
		public function get spawned():Boolean { return _spawned; }
		public function set spawned(value:Boolean):void { _spawned = value; }
		
		public function get trash():Boolean { return _trash; }
		public function set trash(value:Boolean):void { _trash = value; }
		
		public function get live():Boolean { return _live; }
		public function set live(value:Boolean):void { _live = value; }
		
		public function get vel():Vec2 { return _vel; }
		public function set vel(value:Vec2):void { _vel = value; }
		
		public function get acc():Vec2 { return _acc; }
		public function set acc(value:Vec2):void { _acc = value; }
		
		public function get maxSpeed():Vec2 { return _maxSpeed; }
		public function set maxSpeed(value:Vec2):void { _maxSpeed = value; }
		
		public function get friction():Number { return _friction; }
		public function set friction(value:Number):void { _friction = value; }
		
		public function get bounce():Number { return _bounce; }
		public function set bounce(value:Number):void { _bounce = value; }
		
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(value:Rectangle):void { _bounds = value; }
		
	}

}