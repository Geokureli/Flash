package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import relic.art.Animation;
	import relic.art.IAsset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.events.AnimationEvent;
	import relic.data.events.AssetEvent;
	import relic.data.shapes.Box;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blit extends EventDispatcher implements IAsset {
		private var mat:Matrix;
		
		private var _width:Number,
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
		
		private var _shape:Shape,
					_graphicBounds:Shape;
		
		private var _bounds:Rectangle;
		
		internal var _parent:BlitLayer;
		
		protected var currentFrame:int;
		protected var animations:Object;
		private var _graphic:BitmapData;
		
		public var origin:Vec2;
		
		public function Blit() {
			setDefaultValues();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function setDefaultValues():void {
			mat = new Matrix();
			_vel = new Vec2();
			_acc = new Vec2();
			_maxSpeed = new Vec2(-1, -1);
			origin = new Vec2();
			_boundMode = BoundMode.NONE;
			_friction = 0;
			_bounce = 0;
			_spawned = false;
			_trash = false;
			_live = true;
			
			
			animations = { };
		}
		
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			bounds = map.bitmapData.rect;
		}
		
		protected function setGraphicBounds():void {
			var frame:BitmapData = this.frame;
			if(graphic != null)
				_graphicBounds = new Box(origin.x, origin.y, graphic.width, graphic.height);
			if(frame != null)
				_graphicBounds = new Box(origin.x, origin.y, frame.width, frame.height);
		}
		
		public function draw(target:BitmapData):void {
			mat.translate(origin.x, origin.y);
			if (graphic != null) target.draw(graphic, mat);
			if (frame != null) target.draw(frame, mat);
			mat.translate(-origin.x, -origin.y);
		}
		
		public function addAnimationSet(sheet:SpriteSheet):void {
			for (var i:String in sheet.animations) 
				animations[i] = sheet.animations[i];
		}
		
		
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
			move();
			
			collide();
			
			updateGraphics();
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
				if (currentFrame > anim.numFrames * anim.rate)
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, {name:currentAnimation}));

				if (graphicBounds == null) setGraphicBounds();
			}
			currentFrame++;
		}
		
		private function get isOffStage():Boolean {
			if (bounds == null) return false;
			return left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top;
		}
		
		public function kill():void {
			dispatchEvent(new AssetEvent(AssetEvent.KILL, this));
			_trash = true;
		}
		
		public function destroy():void {
			
			_vel = _acc = _maxSpeed = null;
			
			_currentAnimation = _boundMode = _name = null;
			
			_shape = _graphicBounds = null;
			
			_bounds = null;
			
			if(_parent)
				_parent.remove(this);
			_parent = null;
			
			animations = null;
		}
		
		public function get x():Number { return mat.tx; }
		public function set x(value:Number):void { mat.tx = value; }
		
		public function get y():Number { return mat.ty; }
		public function set y(value:Number):void { mat.ty = value; }
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		/** The left collision bound of the blit. */
		public function get left():Number	{ return x + (_shape == null ? 0 : _shape.left); }
		/** The right collision bound of the blit. */
		public function get right():Number	{ return x + (_shape == null ? 0 : _shape.right); }
		/** The top collision bound of the blit. */
		public function get top():Number	{ return y + (_shape == null ? 0 : _shape.top); }
		/** The bottom collision bound of the blit. */
		public function get bottom():Number	{ return y + (_shape == null ? 0 : _shape.bottom); }
		
		public function set left(value:Number):void		{ x = value - (_shape == null ? 0 : _shape.left); }
		public function set right(value:Number):void	{ x = value - (_shape == null ? 0 : _shape.right); }
		public function set top(value:Number):void		{ y = value - (_shape == null ? 0 : _shape.top); }
		public function set bottom(value:Number):void	{ y = value - (_shape == null ? 0 : _shape.bottom); }
		
		/** The currently playing animation. */
		public function get anim():Animation {
			if (_currentAnimation == null) return null;
			return animations[_currentAnimation];
		}
		
		/** The frame currently being displayed */
		public function get frame():BitmapData {
			if (anim == null) return null;
			return anim.getFrame(currentFrame);
		}
		
		public function get graphic():BitmapData { return _graphic; }
		public function set graphic(value:BitmapData):void {
			_graphic = value;
			if (graphicBounds == null) setGraphicBounds();
		}
		
		/** the name of the current animation. */
		public function get currentAnimation():String { return _currentAnimation; }
		public function set currentAnimation(value:String):void {
			if (_currentAnimation != value) currentFrame = 0;
			_currentAnimation = value;
		}
		
		/** The collision shape of the blit. */
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		/** The blit's graphic shape. Used to tell if it's on screen. */
		public function get graphicBounds():Shape { return _graphicBounds; }
		public function set graphicBounds(value:Shape):void { _graphicBounds = value; }
		
		/** The bounds of the blit. */
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(value:Rectangle):void { _bounds = value; }
		
		/** The type of binding used in regards to its stage bounds. (see: relic.data.BoundMode) */
		public function get boundMode():String { return _boundMode; }
		public function set boundMode(value:String):void { _boundMode = value; }
		
		/** True once the blit enters the bounds. */
		public function get spawned():Boolean { return _spawned; }
		public function set spawned(value:Boolean):void { _spawned = value; }
		
		/** Used internally for garbage collection. */
		public function get trash():Boolean { return _trash; }
		public function set trash(value:Boolean):void { _trash = value; }
		
		/** If true, the containing Blitmap will automatically call update. */
		public function get live():Boolean { return _live; }
		public function set live(value:Boolean):void { _live = value; }
		
		/** The velocity of the blit. */
		public function get vel():Vec2 { return _vel; }
		public function set vel(value:Vec2):void { _vel = value; }
		
		/** The acceloration of the blit. */
		public function get acc():Vec2 { return _acc; }
		public function set acc(value:Vec2):void { _acc = value; }
		
		/** Ignored if -1, otherwise caps velocity (positive and negative). */
		public function get maxSpeed():Vec2 { return _maxSpeed; }
		public function set maxSpeed(value:Vec2):void { _maxSpeed = value; }
		
		/** The blit's friction (0 = no friction). */
		public function get friction():Number { return _friction; }
		public function set friction(value:Number):void { _friction = value; }
		
		/** The elasticity of the blit, a ball will a bounce of .5 will bounce half as high. */
		public function get bounce():Number { return _bounce; }
		public function set bounce(value:Number):void { _bounce = value; }
		
		protected function get stage():Stage { return _parent.stage; }
		protected function get map():Blitmap { return _parent.parent; }
	}
}