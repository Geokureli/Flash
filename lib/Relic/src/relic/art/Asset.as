package relic.art 
{
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import mx.core.IAssetLayoutFeatures;
	import relic.data.events.AnimationEvent;
	import relic.data.events.AssetEvent;
	import relic.data.IXMLParam;
	import relic.data.shapes.Box;
	import relic.data.Vec2;
	import relic.data.BoundMode;
	import relic.data.shapes.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author George
	 */
	public class Asset extends MovieClip implements IXMLParam {
		static public var defaultBounds:Rectangle;
		
		private var _vel:Vec2,
					_acc:Vec2,
					_origin:Vec2,
					_maxSpeed:Vec2;
		
		private var _spawned:Boolean,
					_trash:Boolean,
					_live:Boolean;
		
		private var _boundMode:String;
		
		private var _friction:Number,
					_bounce:Number;
		
		private var _shape:Shape,
					_graphicBounds:Shape;
		
		private var debugGraphics:flash.display.Shape;
		
		private var _bounds:Rectangle;
		private var _graphic:IBitmapDrawable;
		
		protected var _currentAnimation:String;
		protected var _currentFrame:int;
		protected var flashTime:int;
		
		public var animations:Object;
		public var bm:Bitmap;
		
		public function Asset() {
			super();
			addChild(bm = new Bitmap());
			setDefaultValues();
			addListeners();
		}
		
		protected function setDefaultValues():void {
			_currentFrame = 0;
			_vel = new Vec2();
			_acc = new Vec2();
			_origin = new Vec2();
			_maxSpeed = new Vec2( -1, -1);
			_bounds = defaultBounds.clone();
			_friction = 0;
			_bounce = 0;
			animations = { };
			_boundMode = BoundMode.NONE;
			_spawned = false;
			_trash = false;
			_live = true;
		}
		public function setParameters(params:Object):void {
			for (var i:String in params)
				this[i] = params[i];
		}
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function addListeners():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function removeListeners():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function setGraphicBounds():void {
			if(bm.bitmapData != null)
				graphicBounds = new Box(bm.x-origin.x, bm.y-origin.y, bm.width, bm.height);
			else if (child != null) {
				var disObj:DisplayObject = child;
				trace(disObj.getBounds(disObj));
				graphicBounds = new Box(disObj.x, disObj.y, disObj.width, disObj.height);
			}
		}
		
		public function debugDraw():void {
			if (shape == null) return;
			if (debugGraphics == null) 
				addChild(debugGraphics = new flash.display.Shape());
			shape.debugDraw(debugGraphics.graphics);
		}
		
		/** Adds all of the animations from the target SpriteSheet. */
		public function addAnimationSet(sheet:SpriteSheet):void {
			for (var i:String in sheet.animations) 
				animations[i] = sheet.animations[i];
		}
		
		/** Removes all references in the Asset */
		public function destroy():void {
			removeListeners();
			vel = acc = origin = maxSpeed = null;
			bounds = null;
			if(shape) shape.destroy();
			if(graphicBounds) graphicBounds.destroy();
			shape = graphicBounds = null;
			boundMode = null;
			animations = null;
			_currentAnimation = null;
			if (bm != null && bm.parent == this)
				removeChild(bm);
			bm = null;
			if (child != null && (child).parent == this)
				removeChild(child);
			graphic = null;
		}
		
		/** Called automatically
		 * 
		 */
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
					if (right > bounds.right) {
						right = bounds.right*2 - right;
						vel.x *= -1;
					}
					if (left  < bounds.left) {
						left = bounds.left * 2 - left;
						vel.x *= -1;
					}
					if (bottom > bounds.bottom) {
						bottom = bounds.bottom * 2 - bottom;
						vel.y *= -1;
					}
					if (top < bounds.top) {
						top = bounds.top * 2 - top;
						vel.y *= -1;
					}
					break;
				case BoundMode.DESTROY:
					if (spawned && isOffStage)
						kill();
					break;
			}
			if (!spawned && !isOffStage)
				spawned = true; 
		}
		
		public function startFlash(frames:int = 10):void {
			flashTime = frames;
		}
		
		/** Allows the asset to be garbage collected */
		public function kill():void {
			dispatchEvent(new AssetEvent(AssetEvent.KILL, this));
			_trash = true;
		}
		
		protected function get isOffStage():Boolean {
			if (bounds == null) return true;
			return left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top;
		}
		
		protected function updateGraphics():void {
			if (anim != null) {
				if (_currentFrame > anim.numFrames * anim.rate) 
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, { name:currentAnimation } ));
				draw()
				if (graphicBounds == null) setGraphicBounds();
			}
			visible = (flashTime < 1 || flashTime % 2 == 0);
			flashTime--;
			_currentFrame++;
		}
		
		private function draw():void {
			var rect:Rectangle = anim.getFrameRect(_currentFrame);
			if (bm.bitmapData == null
			|| (bm.bitmapData.width != rect.width && bm.bitmapData.height != rect.height)) {
				bm.bitmapData = new BitmapData(rect.width, rect.height);
			}
			anim.drawFrame(_currentFrame, bm.bitmapData);
		}
		
		/** Determines whether the asset is overlapping or the target asset. */
		public function isTouching(asset:Asset):Boolean {
			if(shape == null || asset.shape == null) return false;
			return shape.hitShape(
				new Vec2(
					asset.left - left,
					asset.top - top
				),
				asset.shape
			);
		}
		
		/** The left collision bound of the asset. */
		public function get left():Number	{ return x + (_shape == null ? 0 : _shape.left   ); }
		/** The right collision bound of the asset. */
		public function get right():Number	{ return x + (_shape == null ? 0 : _shape.right  ); }
		/** The top collision bound of the asset. */
		public function get top():Number	{ return y + (_shape == null ? 0 : _shape.top    ); }
		/** The bottom collision bound of the asset. */
		public function get bottom():Number	{ return y + (_shape == null ? 0 : _shape.bottom ); }
		
		public function set left(value:Number):void		{ x = value - (_shape == null ? 0 : _shape.left   ); }
		public function set right(value:Number):void	{ x = value - (_shape == null ? 0 : _shape.right  ); }
		public function set top(value:Number):void		{ y = value - (_shape == null ? 0 : _shape.top    ); }
		public function set bottom(value:Number):void	{ y = value - (_shape == null ? 0 : _shape.bottom ); }
		
		/** The currently playing animation. */
		public function get anim():Animation {
			if (_currentAnimation == null) return null;
			return animations[_currentAnimation];
		}
		
		/** the name of the current animation. */
		public function get currentAnimation():String { return _currentAnimation; }
		public function set currentAnimation(value:String):void {
			if (_currentAnimation != value) _currentFrame = 0;
			_currentAnimation = value;
		}
		
		/** The collision shape of the asset. */
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		/** The asset's graphic shape. Used to tell if it's on screen. */
		public function get graphicBounds():Shape { return _graphicBounds; }
		public function set graphicBounds(value:Shape):void { _graphicBounds = value; }
		
		/** The type of binding used in regards to its stage bounds. (see: relic.data.BoundMode)
		 * Ignored if bounds is null
		 * NONE: no binding(default)
		 * LOCK: If the asset goes past the stageBounds it will positioned back to the edge.
		 * BOUNCE: Same as locked but bounces back
		 * DESTROY: The asset is destroyed if the graphic moves out of bounds
		 */
		public function get boundMode():String { return _boundMode; }
		public function set boundMode(value:String):void { _boundMode = value; }
		
		/** The bounds of the asset. */
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(value:Rectangle):void { _bounds = value; }
		
		/** True once the asset enters the bounds. */
		public function get spawned():Boolean { return _spawned; }
		public function set spawned(value:Boolean):void { _spawned = value; }
		
		/** Used internally for garbage collection. */
		public function get trash():Boolean { return _trash; }
		public function set trash(value:Boolean):void { _trash = value; }
		
		/** If true, the containing AssetManager will automatically call update. */
		public function get live():Boolean { return _live; }
		public function set live(value:Boolean):void { _live = value; }
		
		/** The velocity of the asset. */
		public function get vel():Vec2 { return _vel; }
		public function set vel(value:Vec2):void { _vel = value; }
		
		/** The acceloration of the asset. */
		public function get acc():Vec2 { return _acc; }
		public function set acc(value:Vec2):void { _acc = value; }
		
		/** Kind of useless right now. */
		public function get origin():Vec2 { return _origin; }
		public function set origin(value:Vec2):void { _origin = value; }
		
		/** If -1, than ignored, otherwise caps velocity (positive and negative). */
		public function get maxSpeed():Vec2 { return _maxSpeed; }
		public function set maxSpeed(value:Vec2):void { _maxSpeed = value; }
		
		/** The asset's friction (0 = no friction). */
		public function get friction():Number { return _friction; }
		public function set friction(value:Number):void { _friction = value; }
		
		/** The elasticity of the asset, a ball will a bounce of .5 will bounce half as high. */
		public function get bounce():Number { return _bounce; }
		public function set bounce(value:Number):void { _bounce = value; }
		
		public function get graphic():IBitmapDrawable { return _graphic; }
		public function set graphic(value:IBitmapDrawable):void {
			if (child != null)
				removeChild(child);
			_graphic = value;
			if (value is BitmapData)
				bm.bitmapData = value as BitmapData;
			else addChild(child);
			setGraphicBounds();
			currentAnimation = null;
			
		}
		
		protected function get child():DisplayObject { return graphic as DisplayObject; }
		
		override public function toString():String {
			return '[' + getQualifiedClassName(this).split('::').pop() + ': ' + name + ']';
		}
	}

}