package relic.art 
{
	import flash.display.DisplayObject;
	import mx.core.IAssetLayoutFeatures;
	import relic.data.events.AnimationEvent;
	import relic.data.events.AssetEvent;
	import relic.data.shapes.Box;
	import relic.data.Vec2;
	import relic.data.BoundMode;
	import relic.data.shapes.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class Asset extends MovieClip implements IAsset{
		private var _vel:Vec2,
					_acc:Vec2,
					_origin:Vec2,
					_maxSpeed:Vec2;
		
		private var _spawned:Boolean,
					_trash:Boolean,
					_live:Boolean;
		
		private var _currentAnimation:String,
					_boundMode:String;
		
		private var _friction:Number,
					_bounce:Number;
		
		private var _shape:Shape,
					_graphicBounds:Shape;
		
		private var debugGraphics:flash.display.Shape;
		
		private var _bounds:Rectangle;
		
		public var animations:Object;
		public var bm:Bitmap;
		public var graphic:DisplayObject;
		public var frame:int;
		
		public function Asset(graphic:DisplayObject = null) {
			super();
			if (graphic != null){
				addChild(this.graphic = graphic);
				setGraphicBounds();
			} else addChild(bm = new Bitmap());
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
			spawned = false;
			trash = false;
			live = true;
		}
		
		protected function setGraphicBounds():void {
			if(bm != null)
				graphicBounds = new Box(bm.x, bm.y, bm.width, bm.height);
			else if (graphic != null)
				graphicBounds = new Box(graphic.x, graphic.y, graphic.width, graphic.height);
		}
		
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function debugDraw():void {
			if (shape == null) return;
			if (debugGraphics == null) 
				addChild(debugGraphics = new flash.display.Shape());
			shape.debugDraw(debugGraphics.graphics);
		}
		
		public function addAnimationSet(sheet:SpriteSheet):void {
			for (var i:String in sheet.animations) 
				animations[i] = sheet.animations[i];
		}
		public function destroy():void {
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
			if (graphic != null && graphic.parent == this)
				removeChild(graphic);
			graphic = null;
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
		
		public function kill():void {
			dispatchEvent(new AssetEvent(AssetEvent.KILL, this));
		}
		
		private function get isOffStage():Boolean {
			if (bounds == null) return false;
			return left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top;
		}
		
		protected function updateGraphics():void {
			if (currentAnimation != null) {
				if (frame > anim.numFrames * anim.rate) {
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, {name:currentAnimation}));
				}
				var newBMD:BitmapData = animations[currentAnimation].getFrame(frame);
				if (bm.bitmapData != newBMD) bm.bitmapData = newBMD;
				if (graphicBounds == null) setGraphicBounds();
			}
			frame++;
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
		
		
		public function get left():Number	{ return x + origin.x + (_shape == null ? 0 : _shape.left   ); }
		public function get right():Number	{ return x + origin.x + (_shape == null ? 0 : _shape.right  ); }
		public function get top():Number	{ return y + origin.y + (_shape == null ? 0 : _shape.top    ); }
		public function get bottom():Number	{ return y + origin.y + (_shape == null ? 0 : _shape.bottom ); }
		
		public function set left(value:Number):void		{ x = value - origin.x - (_shape == null ? 0 : _shape.left   ); }
		public function set right(value:Number):void	{ x = value - origin.x - (_shape == null ? 0 : _shape.right  ); }
		public function set top(value:Number):void		{ y = value - origin.y - (_shape == null ? 0 : _shape.top    ); }
		public function set bottom(value:Number):void	{ y = value - origin.y - (_shape == null ? 0 : _shape.bottom ); }
		
		public function get currentAnimation():String { return _currentAnimation; }
		public function set currentAnimation(value:String):void {
			if (_currentAnimation != value) frame = 0;
			_currentAnimation = value;
		}
		
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		public function get graphicBounds():Shape { return _graphicBounds; }
		public function set graphicBounds(value:Shape):void { _graphicBounds = value; }
		
		public function get boundMode():String { return _boundMode; }
		public function set boundMode(value:String):void { _boundMode = value; }
		
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
		
		public function get origin():Vec2 { return _origin; }
		public function set origin(value:Vec2):void { _origin = value; }
		
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