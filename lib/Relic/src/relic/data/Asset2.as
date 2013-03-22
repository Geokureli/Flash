package relic.data {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import relic.art.IDisplay;
	import relic.data.BoundMode;
	import relic.data.events.AssetEvent;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	import relic.data.xml.IXMLParam;
	import relic.data.xml.XMLParser;
	/**
	 * ...
	 * @author George
	 */
	public class Asset2 extends EventDispatcher implements IXMLParam {
		static public var defaultBounds:Rectangle;
		
		private var _pos:Vec2,
					_vel:Vec2,
					_acc:Vec2,
					_origin:Vec2,
					_maxSpeed:Vec2
		
		private var _spawned:Boolean,
					_visible:Boolean,
					_trash:Boolean,
					_live:Boolean;
		
		private var _boundMode:String,
					_name:String;
		
		private var _friction:Number,
					_bounce:Number,
					_alpha:Number;
		
		private var _shape:Shape;
		
		private var _bounds:Rectangle;
		
		protected var flashTime:int;
		
		private var _graphic:IDisplay;
		public function Asset2() {
			super();
			
			setDefaultValues();
			addListeners();
		}
		protected function setDefaultValues():void {
			_vel = new Vec2();
			_acc = new Vec2();
			_origin = new Vec2();
			_maxSpeed = new Vec2( -1, -1);
			if(defaultBounds) _bounds = defaultBounds.clone();
			_friction = 0;
			_bounce = 0;
			_boundMode = BoundMode.NONE;
			_spawned = false;
			_trash = false;
			_live = true;
			_visible = true;
		}
		public function setParameters(params:Object):void {
			if (params is XML)
				XMLParser.setProperties(this, params as XML);
			else for (var i:String in params)
				this[i] = params[i];
		}
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function addListeners():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function debugDraw():void { }
		
		// ---------------------------------------------------------------------
		// 								EVENTS
		// ---------------------------------------------------------------------
		
		
		/** Called automatically from asset manager */
		public function update():void {
			move();
			
			checkBounds();
			
			if (graphic != null) graphic.update();
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
		
		protected function checkBounds():void {
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
					if (spawned && inBounds)
						kill();
					break;
			}
			if (!spawned && !inBounds)
				spawned = true; 
		}
		
		
		/** Determines whether the asset is overlapping or the target asset. */
		public function isTouching(asset:Asset2):Boolean {
			if(shape == null || asset.shape == null) return false;
			return shape.hitShape(
				new Vec2(
					asset.left - left,
					asset.top - top
				),
				asset.shape
			);
		}
		
		/** Allows the asset to be garbage collected */
		public function kill():void {
			//dispatchEvent(new AssetEvent(AssetEvent.KILL, this));
			_trash = true;
		}
		
		// ---------------------------------------------------------------------
		// 								DESTRUCTION
		// ---------------------------------------------------------------------
		
		protected function removeListeners():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function destroy():void {
			_vel = null;
			_acc = null;
			_origin = null;
			_maxSpeed = null;
			_bounds = null;
			_boundMode = null;
			
			if (_graphic != null) _graphic.destroy();
			_graphic = null;
		}
		
		// ---------------------------------------------------------------------
		// 							GETTERS/SETTERS
		// ---------------------------------------------------------------------
		
		public function get originX():Number { return _origin.x; }
		public function set originX(value:Number):void { _origin.x = value; }
		
		public function get originY():Number { return _origin.y; }
		public function set originY(value:Number):void { _origin.y = value; }
		
		/** The velocity of the asset. */
		public function get vel():Vec2 { return _vel; }
		public function set vel(value:Vec2):void { _vel = value; }
		
		/** The acceloration of the asset. */
		public function get acc():Vec2 { return _acc; }
		public function set acc(value:Vec2):void { _acc = value; }
		
		/** If -1, than ignored, otherwise caps velocity (positive and negative). */
		public function get maxSpeed():Vec2 { return _maxSpeed; }
		public function set maxSpeed(value:Vec2):void { _maxSpeed = value; }
		
		/** The asset's friction (0 = no friction). */
		public function get friction():Number { return _friction; }
		public function set friction(value:Number):void { _friction = value; }
		
		/** The elasticity of the asset, a ball will a bounce of .5 will bounce half as high. */
		public function get bounce():Number { return _bounce; }
		public function set bounce(value:Number):void { _bounce = value; }
		
		/** The collision shape of the asset. */
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		/** The left collision bound of the asset. */
		public function get left():Number	{ return x + _origin.x + (_shape == null ? 0 : _shape.left   ); }
		/** The right collision bound of the asset. */
		public function get right():Number	{ return x + _origin.x + (_shape == null ? 0 : _shape.right  ); }
		/** The top collision bound of the asset. */
		public function get top():Number	{ return y + _origin.y + (_shape == null ? 0 : _shape.top    ); }
		/** The bottom collision bound of the asset. */
		public function get bottom():Number	{ return y + _origin.y + (_shape == null ? 0 : _shape.bottom ); }
		
		public function set left(value:Number):void		{ x = value - _origin.x - (_shape == null ? 0 : _shape.left   ); }
		public function set right(value:Number):void	{ x = value - _origin.x - (_shape == null ? 0 : _shape.right  ); }
		public function set top(value:Number):void		{ y = value - _origin.y - (_shape == null ? 0 : _shape.top    ); }
		public function set bottom(value:Number):void	{ y = value - _origin.y - (_shape == null ? 0 : _shape.bottom ); }
		
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
		
		public function get graphic():IDisplay { return _graphic; }
		public function set graphic(value:IDisplay):void { _graphic = value; }
		
		
		protected function get inBounds():Boolean {
			return !(bounds == null || left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top);
		}
		
		override public function toString():String {
			return '[' + getQualifiedClassName(this).split('::').pop() + ': ' + name + ']';
		}
		
		// --- --- --- DISPLAY DELEGATES --- --- ---
		
		public function get x():Number { return _pos.x; }
		public function set x(value:Number):void { _pos.x = value;
			if (_graphic != null) graphic.x = value;
		}
		
		public function get y():Number { return _pos.y; }
		public function set y(value:Number):void { _pos.y = value;
			if (_graphic != null) graphic.y = value;
		}
		
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value;
			if (_graphic != null) graphic.alpha = value;
		}
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value;
			if (_graphic != null) graphic.visible = value;
		}
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
	}

}