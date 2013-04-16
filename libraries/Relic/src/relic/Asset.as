package relic {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import relic.art.blitting.AnimatedBlit;
	import relic.art.blitting.Blit;
	import relic.art.IDisplay;
	import relic.BoundMode;
	import relic.collision.CollisionData;
	import relic.events.AssetEvent;
	import relic.events.BoundEvent;
	import relic.IAssetHolder;
	import relic.serial.Serializer;
	import relic.shapes.Shape;
	import relic.Vec2;
	import relic.xml.IXMLParam;
	import relic.xml.XMLParser;
	/**
	 * ...
	 * @author George
	 */
	
	[Event(name="overlap",			type="relic.events.CollisionEvent")]
	[Event(name="enter",			type="relic.events.CollisionEvent")]
	[Event(name="leave",			type="relic.events.CollisionEvent")]
	[Event(name="mouseDown",		type="flash.events.MouseEvent")]
	[Event(name="mouseUp",			type="flash.events.MouseEvent")] 
	[Event(name="mouseMove",		type="flash.events.MouseEvent")] 
	[Event(name="mouseOver",		type="flash.events.MouseEvent")] 
	[Event(name="mouseOut",			type="flash.events.MouseEvent")] 
	[Event(name="rollOver",			type="flash.events.MouseEvent")] 
	[Event(name="rollOut",			type="flash.events.MouseEvent")] 
	[Event(name="mouseMove",		type="flash.events.MouseEvent")] 
	[Event(name="mouseMove",		type="flash.events.MouseEvent")]
	[Event(name="click",			type="flash.events.MouseEvent")]
	[Event(name="addedToStage",		type="flash.events.Event")]
	[Event(name="removedFromStage",	type="flash.events.Event")]
	//[Event(name="added",			type="flash.events.Event")]
	//[Event(name="removed",			type="flash.events.Event")]
	
	public class Asset extends EventDispatcher implements IXMLParam {
		static public var DEBUG_DRAW:Boolean = CONFIG::debug;
		
		static private var AUTO_ID:int;
		static public var defaultBounds:Rectangle;
		
		{ AUTO_ID = 0; }
		
		private var _parent:IAssetHolder;
		
		private var _pos:Vec2,
					_vel:Vec2,
					_acc:Vec2,
					_origin:Vec2,
					_maxSpeed:Vec2;
		
		public var last:Vec2;
		
		private var _parallax:Point;
		
		private var _boundMode:String,
					_id:String;
		
		private var _graphic:IDisplay;
		
		private var _tileMap:Array;
		
		private var _mouseEnabled:Boolean,
					_spawned:Boolean,
					_visible:Boolean,
					_trash:Boolean,
					_live:Boolean,
					_shapeIn:Boolean,
					_graphicIn:Boolean,
					_debugDraw:Boolean;
		
		private var _friction:Number,
					_bounce:Number,
					_alpha:Number,
					_width:Number,
					_height:Number;
		
		private var _columns:int,
					_rows:int;
		
		private var _shape:Shape;
		
		private var _bounds:Rectangle;
		
		protected var flashTime:int;
		
		public var moves:Boolean;
		
		public function Asset(graphic:IDisplay = null) {
			super();
			
			_graphic = graphic;
			setDefaultValues();
			if (graphic) initAddedGraphic();
			
			addListeners();
		}
		protected function setDefaultValues():void {
			
			_pos = new Vec2();
			_vel = new Vec2();
			_acc = new Vec2();
			_origin = new Vec2();
			_maxSpeed = new Vec2(-1, -1);
			_parallax = new Point(1, 1);
			
			_boundMode = BoundMode.NONE;
			if (defaultBounds)
				_bounds = defaultBounds.clone();
			
			_friction =
				_bounce =
				_width =
				_height = 0;
			
			_columns =
				_rows = 1;
			
			
			_live =
				_visible = 
				moves = true;
			
			_spawned =
				_trash =
				_shapeIn =
				_graphicIn =
				_mouseEnabled = false;
		}
		
		public function setParameters(params:Object):IXMLParam {
			if (params is XML) {
				if ("graphic" in params) graphic.setParameters(XMLParser.removeFromParent(params.graphic[0]));
				XMLParser.setProperties(this, params as XML);
			} else {
				if ("graphic" in params) {
					setGraphicParams(params.graphic);
					//delete params.graphic;
				}
				for (var i:String in params) {
					if(i != "graphic")
						this[i] = params[i];
				}
			}
			
			return this;
		}
		protected function setGraphicParams(params:Object):void {
			if (params is IDisplay)
				
				graphic = params as IDisplay;
				
			else if (params is BitmapData || "type" in params)
				
				createGraphic(params);
			
			else {
				if ("target" in params) 
					graphic = params.target;
					
				graphic.setParameters(params);
			}
			
		}
		protected function initAddedGraphic():void {
			
			_graphic.debugDraw	= _debugDraw;
			_graphic.visible	= _visible;
			_graphic.alpha		= _alpha;
			_graphic.x			= _pos.x;
			_graphic.y			= _pos.y;
			_graphic.width		= _width;
			_graphic.height		= _height;
			_graphic.parallaxX	= _parallax.x;
			_graphic.parallaxY	= _parallax.y;
			_graphic.columns	= _columns;
			_graphic.rows		= _rows;
			_graphic.asset		= this;
			if (tileMap) _graphic.tileMap = _tileMap;
		}
		
		protected function createGraphic(params:Object):void {
			if (params is BitmapData) {
				
				if (!(graphic is Blit))
					graphic = new Blit();
				
				(graphic as Blit).child = params as BitmapData;
				//(graphic as Blit).addAnimationSet(new SpriteSheet(params.graphic));
			} else if ("type" in params) {
				var type:String = params.type;
				delete params.type;
				graphic = Serializer.createObject(type, params) as IDisplay;
			}
		}
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function addListeners():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// ---------------------------------------------------------------------
		// 								EVENTS
		// ---------------------------------------------------------------------
		
		protected function mouseHandle(e:MouseEvent):void {
			dispatchEvent(e);
		}
		
		/** Called automatically from asset manager */
		public function preUpdate():void {
			if (graphic != null) graphic.preUpdate();
		}
		
		/** Called automatically from asset manager */
		public function update():void {
			
			last = _pos.clone();
			move();
			
			checkBounds();
			
			if (graphic != null) graphic.update();
		}
		
		public function draw():void {
			if(graphic != null){
				graphic.visible = flashTime <= 0 || flashTime % 2 == 0;
				if (visible && graphic.needsRedraw ) graphic.draw();
			}
			flashTime--;
		}
		
		protected function move():void {
			_vel.add(acc);
			if (maxSpeed.x > -1) {
				if (_vel.x > maxSpeed.x) _vel.x = maxSpeed.x;
				if (_vel.x < -maxSpeed.x) _vel.x = -maxSpeed.x;
			}
			if (maxSpeed.y > -1) {
				if (_vel.y > maxSpeed.y) _vel.y = maxSpeed.y;
				if (_vel.y < -maxSpeed.y) _vel.y = -maxSpeed.y;
			}
			x += _vel.x;
			y += _vel.y;
			_vel.multiply(1 - friction);
		}
		
		protected function checkBounds():void {
			var shapeIn:Boolean = inBounds(true);
			var graphicIn:Boolean = inBounds();
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
						_vel.x *= -1;
					}
					if (left  < bounds.left) {
						left = bounds.left * 2 - left;
						_vel.x *= -1;
					}
					if (bottom > bounds.bottom) {
						bottom = bounds.bottom * 2 - bottom;
						_vel.y *= -1;
					}
					if (top < bounds.top) {
						top = bounds.top * 2 - top;
						_vel.y *= -1;
					}
					
					break;
				case BoundMode.LOOP:
					if (!inBounds()) {
						if (gRight < bounds.left && _vel.x < 0) gLeft = bounds.right;
						if (gLeft > bounds.right && _vel.x > 0) gRight = bounds.left;
						if (gBottom < bounds.top && _vel.y < 0) gTop = bounds.bottom;
						if (gTop > bounds.bottom && _vel.y > 0) gBottom = bounds.top;
					}
					break;
				case BoundMode.DESTROY:
					if (spawned && !inBounds())
						kill();
					break;
				case BoundMode.NONE: return;
			}
			if (shapeIn != _shapeIn)
				dispatchEvent(new BoundEvent(shapeIn ? BoundEvent.SHAPE_IN : BoundEvent.SHAPE_OUT));
			if (graphicIn != _graphicIn)
				dispatchEvent(new BoundEvent(graphicIn ? BoundEvent.GRAPHIC_IN : BoundEvent.GRAPHIC_OUT));
			
			_shapeIn = shapeIn;
			_graphicIn = graphicIn;
			
			if (!spawned && graphicIn)
				_spawned = true;
		}
		
		public function startFlash(frames:int = 10):void {
			flashTime = frames
		}
		
		/** Determines whether the asset is overlapping or the target asset. */
		public function isTouching(asset:Asset):CollisionData {
			if(shape == null || asset.shape == null) return null;
			var data:CollisionData = shape.hitShape(
				new Vec2(
					asset.left - left,
					asset.top - top
				),
				asset.shape
			);
			if (data != null) {
				data.attacker = this;
				data.victim = asset;
				data.chooseSeparationAxis();
			}
			return data;
		}
		
		public function touchingPoint(p:Point, graphics:Boolean = true):Boolean {
			if (graphics && gShape != null) return gShape.hitPoint(p.subtract(_pos.point));
			if (shape != null) return shape.hitPoint(p.subtract(_pos.point).subtract(_origin.point));
			return false;
		}
		
		/** Allows the asset to be garbage collected */
		public function kill():void {
			//dispatchEvent(new AssetEvent(AssetEvent.KILL, this));
			_trash = true;
		}
		
		protected function inBounds(collision:Boolean = false):Boolean {
			if (collision || gShape == null)
				return !(bounds == null || left > bounds.right || right < bounds.left || top > bounds.bottom || bottom < bounds.top);
			return !(gLeft > bounds.right || gRight < bounds.left || gTop > bounds.bottom || gBottom < bounds.top);
		}
		
		protected function addMouseListeners():void {
			
			graphic.addEventListener(MouseEvent.MOUSE_WHEEL, mouseHandle);
			graphic.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			graphic.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			graphic.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			graphic.addEventListener(MouseEvent.MOUSE_OVER, mouseHandle);
			graphic.addEventListener(MouseEvent.MOUSE_OUT, mouseHandle);
			graphic.addEventListener(MouseEvent.ROLL_OVER, mouseHandle);
			graphic.addEventListener(MouseEvent.ROLL_OUT, mouseHandle);
			graphic.addEventListener(MouseEvent.CLICK, mouseHandle);
		}
		
		protected function removeMouseListeners():void {
			
			graphic.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseHandle);
			graphic.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			graphic.removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			graphic.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			graphic.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandle);
			graphic.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandle);
			graphic.removeEventListener(MouseEvent.ROLL_OVER, mouseHandle);
			graphic.removeEventListener(MouseEvent.ROLL_OUT, mouseHandle);
			graphic.removeEventListener(MouseEvent.CLICK, mouseHandle);
		}
		
		// ---------------------------------------------------------------------
		// 								DESTRUCTION
		// ---------------------------------------------------------------------
		
		protected function removeListeners():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			mouseEnabled = false;
		}
		
		public function destroy():void {
			_vel = null;
			_acc = null;
			_origin = null;
			_maxSpeed = null;
			_bounds = null;
			_boundMode = null;
			
			if (parent) parent.remove(this);
			
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
		public function get velX():Number { return _vel.x; }
		public function set velX(value:Number):void { _vel.x = value;
			if (shape != null) shape.vel.x = value;
		}
		/** The velocity of the asset. */
		public function get velY():Number { return _vel.y; }
		public function set velY(value:Number):void { _vel.y = value;
			if (shape != null) shape.vel.y = value;
		}
		
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
		
		/** The left graphic bound of the asset. */
		public function get gLeft():Number		{ return x + (graphic == null ? 0 : graphic.left   ); }
		/** The right graphic bound of the asset. */
		public function get gRight():Number		{ return x + (graphic == null ? 0 : graphic.right  ); }
		/** The top graphic bound of the asset. */
		public function get gTop():Number		{ return y + (graphic == null ? 0 : graphic.top    ); }
		/** The bottom graphic bound of the asset. */
		public function get gBottom():Number	{ return y + (graphic == null ? 0 : graphic.bottom ); }
		
		public function set gLeft(value:Number):void	{ x = value - (_shape == null ? 0 : gLeft   ); }
		public function set gRight(value:Number):void	{ x = value - (_shape == null ? 0 : gRight  ); }
		public function set gTop(value:Number):void		{ y = value - (_shape == null ? 0 : gTop    ); }
		public function set gBottom(value:Number):void	{ y = value - (_shape == null ? 0 : gBottom ); }
		
		/** The type of binding used in regards to its stage bounds. (see: relic.BoundMode)
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
		
		public function get gShape():Shape {
			if (graphic == null) return null;
			return graphic.shape;
		}
		
		/** True once the asset enters the bounds. */
		public function get spawned():Boolean { return _spawned; }
		//public function set spawned(value:Boolean):void { _spawned = value; }
		
		/** Used internally for garbage collection. */
		public function get trash():Boolean { return _trash; }
		public function set trash(value:Boolean):void { _trash = value; }
		
		/** If true, the containing AssetManager will automatically call update. */
		public function get live():Boolean { return _live; }
		public function set live(value:Boolean):void { _live = value; }
		
		public function get graphic():IDisplay { return _graphic; }
		public function set graphic(value:IDisplay):void {
			if (graphic != null) {
				graphic.asset = null;
				//if (stage != null)
					//graphic.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			}
			var _mouseEnabled:Boolean = mouseEnabled;
			if (_mouseEnabled && _graphic)
				
				mouseEnabled = false;
			_graphic = value;
			if (graphic != null) {
				if (_mouseEnabled) mouseEnabled = true;
				initAddedGraphic()
				
			}
			//if (stage != null)
				//graphic.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
		}
		
		override public function toString():String {
			return '[' + getQualifiedClassName(this).split('::').pop() + ': ' + id + ']';
		}
		
		// --- --- --- DISPLAY DELEGATES (1 WAY) --- --- ---
		
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		public function set mouseEnabled(value:Boolean):void { _mouseEnabled = value;
			if (graphic != null && value != graphic.mouseEnabled) {
				
				if (value)	addMouseListeners();
				else		removeMouseListeners();
				
			}
		}
		
		public function get x():Number { return _pos.x; }
		public function set x(value:Number):void { _pos.x = value;
			if (_graphic != null) graphic.x = value;
			if (isNaN(value)) throw new ArgumentError("x cannot be Nan");
		}
		
		public function get y():Number { return _pos.y; }
		public function set y(value:Number):void { _pos.y = value;
			if (_graphic != null) graphic.y = value;
			if (isNaN(value)) throw new ArgumentError("y cannot be Nan");
		}
		
		public function get parallax():Number { return _parallax.x; }
		public function set parallax(value:Number):void { _parallax.x = _parallax.y = value;
			
			if (graphic != null) graphic.parallaxX = graphic.parallaxY = value;
		}
		
		public function get parallaxX():Number { return _parallax.x; }
		public function set parallaxX(value:Number):void { _parallax.x = value;
			
			if (graphic != null) graphic.parallaxX = value;
		}
		
		public function get parallaxY():Number { return _parallax.y; }
		public function set parallaxY(value:Number):void { _parallax.y = value;
		
			if (graphic != null) graphic.parallaxY = value;
		}
		
		public function get width():Number { return graphic.width; }
		public function set width(value:Number):void { _width = value;
			if(shape != null)
			if (graphic != null) graphic.width = value;
		}
		
		public function get height():Number { return graphic.height; }
		public function set height(value:Number):void { _height = value;
			if (graphic != null) graphic.height = value;
		}
		
		public function get size():Number { return width; }
		public function set size(value:Number):void { width = height = value; }
		
		public function get columns():int { return _columns; }
		public function set columns(value:int):void { _columns = value;
			
			if (graphic != null) _graphic.columns = value;
		}
		
		public function get rows():int { return _rows; }
		public function set rows(value:int):void { _rows = value;
			
			if (graphic != null) _graphic.rows = value;
		}
		
		public function get tileMap():Array {
			if (graphic != null) graphic.tileMap;
			return _tileMap;
		}
		public function set tileMap(value:Array):void { _tileMap = tileMap;
			
			if(value != null){
				columns = _tileMap.length;
				rows = _tileMap[0].length;
			}
			
			if (graphic != null) graphic.tileMap = value;
		}
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value;
			if (_graphic != null) graphic.alpha = value;
		}
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value;
			if (_graphic != null) graphic.visible = value;
		}
		
		public function get debugDraw():Boolean { return _debugDraw; }
		public function set debugDraw(value:Boolean):void { _debugDraw = value;
			
			if (graphic != null) graphic.debugDraw = value;
		}
		
		// --- --- --- USELESS GETTERS / SETTERS --- --- ---
		
		public function get parent():IAssetHolder { return _parent; }
		public function set parent(value:IAssetHolder):void { _parent = value; }
		
		public function get stage():Stage {
			
			if (parent == null) return null;
			return parent.stage;
		}
		
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }
		
	}

}