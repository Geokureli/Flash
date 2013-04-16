package relic.art.blitting {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.Asset;
	import relic.art.IDisplay;
	import relic.Align;
	import relic.BoundMode;
	import relic.events.AnimationEvent;
	import relic.events.AssetEvent;
	import relic.helpers.BitmapHelper;
	import relic.helpers.MouseHelper;
	import relic.helpers.Random;
	import relic.shapes.Box;
	import relic.shapes.Shape;
	import relic.TileEdgeMode;
	import relic.Vec2;
	import relic.xml.IXMLParam;
	import relic.xml.XMLParser;
	import relic.Resources;
	import relic.StretchMode;
	import relic.TileMode;
	import relic.art.blitting.BlitDraw;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blit extends EventDispatcher implements IDisplay {
		static protected const DEBUG_SHAPE:TemplateSheet = Resources.DebugShape;
		static protected const DEBUG_GRAPHIC:TemplateSheet = Resources.DebugGraphic;
		
		protected var position:Point;
		
		protected var borderRect:Rectangle,
					lastBorderRect:Rectangle;
					
		private var _rows:int, _columns:int;
		
		protected var _shapeBorder:BitmapData,
					_graphicBorder:BitmapData;
		
		private var _alpha:Number,
					_width:Number,
					_height:Number;

		private var _shape:Shape;
		
		private var _visible:Boolean,
					_finiteRows:Boolean,
					_finiteColumns:Boolean,
					_parallaxX:Boolean,
					_parallaxY:Boolean,
					_mouseEnabled:Boolean,
					_debugDraw:Boolean;
		
		private var _asset:Asset;
		
		private var _image:BitmapData,
					_back:BitmapData;
		
		private var _tileMap:Array;
		
		protected var defaultFrame:int;
		
		private var _color:uint;
		
		private var _borderTemplate:TemplateSheet;
		
		private var _parallax:Point;
		
		private var _align:String,
					_stretch:String,
					_tileMode:String,
					_edgeMode:String;
		
		public function Blit(child:BitmapData = null) {
			setDefaultValues();
			this.child = child;
			addEventListener(Event.ADDED_TO_STAGE, init);
			addListeners();
		}
		
		protected function setDefaultValues():void {
			position = new Point();
			_parallax = new Point(1, 1);
			
			lastBorderRect = new Rectangle();
			borderRect = new Rectangle();
			
			_visible = 
				_finiteColumns =
				_finiteRows = true;
			
			_columns = _rows = 1;
			_width = _height = 0;
			
			defaultFrame = 0;
			color = 0xFFFFFF
			alpha = 1;
		}
		
		protected function addListeners():void { }
		
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (child != null) setGraphicBounds();
			if (tileMap == null) setTileData();
		}
		
		public function setParameters(params:Object):IXMLParam {
			
			if (params is XML)
				XMLParser.setProperties(this, params as XML);
			
			else for (var i:String in params)
				this[i] = params[i];
			
			return this;
		}
		
		protected function setGraphicBounds():void {
			var rect:Rectangle = this.rect;
			
			if (borderRect.width * borderRect.height)
				rect = borderRect;
			
			if (rect != null)
				shape = new Box(0, 0, borderRect.width, borderRect.height);
		}
		
		public function preUpdate():void{ checkSize(); }
		
		public function update():void { }
		
		private function checkSize():void {	
			
			if(width*height > 0 && (lastBorderRect.width != width || lastBorderRect.height != height)) {
				if (borderTemplate != null){  
					
					if (_back != null) 
						if (_back is SpriteSheet)
							(_back as SpriteSheet).destroy();
					
					setBack();
				}
				if (_graphicBorder!= null)
					_graphicBorder.dispose();
				
				_graphicBorder = new BitmapData(width, height, true, 0);
				DEBUG_GRAPHIC.drawTemplate(_graphicBorder);
				
				lastBorderRect = borderRect.clone();
				setGraphicBounds();
			}
		}
		
		private function setBack():void {
			_back = borderTemplate.createSheet(width * columns, height * rows);
		}
		
		public function draw():void {
			drawBorder();
			
			var p:Point = drawPosition;
			
			if (columns == 1 && rows == 1)
				drawTile(p, 0, 0);
				
			else {
				var left:int = 0;	var right :int = columns;
				var top:int = 0;	var bottom:int = rows;
				
				if (!_finiteColumns){
					
					left = int((asset.bounds.left - asset.gLeft * _parallax.x) / rect.width);
					while (left * rect.width + asset.gLeft * _parallax.x > asset.bounds.left) left--;
					
					right = int((asset.bounds.right - asset.gRight * _parallax.x) / rect.width);
					while (right * rect.width + asset.gRight * _parallax.x < asset.bounds.right) right ++;
					p.x += left * rect.width;
					right++;
				}
				
				if (!_finiteRows){
					
					top = int((asset.bounds.top - asset.gTop * _parallax.y) / rect.height);
					while (top * rect.height + asset.gTop * _parallax.y > asset.bounds.top) top--;
					
					bottom = int((asset.bounds.bottom - asset.gBottom * _parallax.y) / rect.height);
					while (bottom * rect.height + asset.gBottom * _parallax.y < asset.bounds.bottom) bottom++;
					p.y += top * rect.height;
					bottom++;
				}
				
				for (var c:int = left; c < right; c++) {
					for (var r:int = top; r < bottom; r++) {
						drawTile(p, c, r);
						p.y += rect.height;
					}
					p.y -= rect.height * (bottom - top);
					p.x += rect.width;
				}
			}
			if(debugDraw || Asset.DEBUG_DRAW)
				drawDebugRects();
		}
		
		protected function drawDebugRects():void {
			var rect:Rectangle;
			
			if (asset.shape) {
				if (asset.shape is Box) {
					var box:Box = asset.shape as Box;
					if (_shapeBorder == null || box.width != _shapeBorder.width || box.height != _shapeBorder.height) {
						if (_shapeBorder != null)
							_shapeBorder.dispose();
						
						_shapeBorder = new BitmapData(box.width, box.height, true, 0);
						DEBUG_SHAPE.drawTemplate(_shapeBorder);
					}
				}
				drawRect(new Point(asset.left, asset.top));
			}
			if(_graphicBorder != null)
				drawRect(position, true);
		}
		
		public function drawRect(dest:Point, isGraphic:Boolean = false):void {
			BitmapHelper.DrawTo(
				(isGraphic ? _graphicBorder : _shapeBorder),
				map.bitmapData,
				dest
			)
		}
		
		protected function get drawPosition():Point {
			var p:Point = new Point(position.x * _parallax.x, position.y * _parallax.y);
			if (rect != null) {
				var borderMode:Boolean = stretchMode == StretchMode.BORDER && borderRect == null;
				switch (align) {
					case Align.CENTER: 
						p = p.add(new Point(
							((borderMode ? 0 : borderRect.width) - rect.width) / 2, 
							((borderMode ? 0 : borderRect.height) - rect.height) / 2
						));
						break;
				}
			}
			return p;
		}
		
		protected function drawBorder():void {
			if (_back != null) {
				if (border != null)
					border.drawFrame(defaultFrame, map.bitmapData, position);
				
				else
					BitmapHelper.DrawTo(_back, map.bitmapData, position);
			}
				
				//back.drawFrame(defaultFrame, map.bitmapData, position);
		}
		
		protected function setTileData():void {
			
			if (child == null) return;
			if (!_finiteColumns)	_columns	= asset.bounds.right  / rect.width;
			if (!_finiteRows)		_rows 		= asset.bounds.bottom / rect.height;
			
			if (child is SpriteSheet) {
				
				tileMap = [];
				
				for (var i:int = 0; i < columns; i++) {
					
					tileMap.push([]);
					
					for (var j:int = 0; j < rows; j++)
						tileMap[i].push(getNewTileFrame(i, j));
				}
			}
		}
		
		protected function getNewTileFrame(xIndex:int, yIndex:int):int {
			switch(tileMode) {
				case TileMode.RANDOM: return Random.random(numFrames);
				default: return 0;
			}
		}
		
		protected function drawTile(position:Point, xIndex:int, yIndex:int):void {
			if (child != null) {
				
				var params:Object = { };
				if (color < 0xFFFFFF) params.color = color;
				if (alpha < 1) params.alpha = alpha;
				
				(child as SpriteSheet).drawFrame(getTile(xIndex, yIndex), map.bitmapData, position);
			}
		}
		
		protected function getTile(x:int, y:int):int {
			
			switch(_edgeMode) {
				
				case TileEdgeMode.WRAP:
					x = ((x % columns) + columns) % columns;
					y = ((y % rows) + rows) % rows;
					break;
				
				case TileEdgeMode.EXTEND:
					if (x > columns) x = columns - 1;
					if (x < 0) x = 0;
					if (y > rows) y = rows - 1;
					if (y < 0) y = 0;
					break;
					
				case TileEdgeMode.NONE:
					if (x > columns || x < 0 || y > rows || y < 0)
						return defaultFrame;
			}
			
			return tileMap[x][y];
		}
		
		public function destroy():void {
			
			position = _parallax = null;
			
			asset = null;
			if (shape != null) shape.destroy();
			_image = _back = null;
			
			tileMap = null;
			
			stretchMode = align = null;
			borderRect = lastBorderRect = null;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			switch(type) {
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_WHEEL:
					MouseHelper.addMouseWatch(asset, type);
					//break;
				default:
					super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			switch(type) {
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_WHEEL:
					MouseHelper.removeMouseWatch(asset, type);
					//break
				default:
					super.removeEventListener(type, listener, useCapture);
			}
		}
		
		/* INTERFACE relic.art.IDisplay */
		
		public function get needsRedraw():Boolean { return _visible; }
		
		public function get x():Number { return position.x; }
		public function set x(value:Number):void { borderRect.x = position.x = value; }
		
		public function get y():Number { return position.y; }
		public function set y(value:Number):void { borderRect.y = position.y = value; }
		
		public function get parallaxX():Number { return _parallax.x; }
		public function set parallaxX(value:Number):void { _parallax.x = value; }
		
		public function get parallaxY():Number { return _parallax.y; }
		public function set parallaxY(value:Number):void { _parallax.y = value; }
		
		public function get width():Number { return _width; }
		public function set width(value:Number):void { borderRect.width = _width = value;
			
			if (stretchMode == StretchMode.TILE && rect.width > 0)
				_columns = value / rect.width;
		}
		
		public function get height():Number { return _height; }
		public function set height(value:Number):void { borderRect.height = _height = value;
			
			if (stretchMode == StretchMode.TILE && rect.height > 0)
				_rows = value / rect.height;
		}
		
		/** The left collision bound of the asset. */
		public function get left():Number	{ return _shape == null ? 0 : _shape.left; }
		/** The right collision bound of the asset. */
		public function get right():Number	{ return _shape == null ? 0 : _shape.right; }
		/** The top collision bound of the asset. */
		public function get top():Number	{ return _shape == null ? 0 : _shape.top; }
		/** The bottom collision bound of the asset. */
		public function get bottom():Number	{ return _shape == null ? 0 : _shape.bottom; }
		
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		public function set mouseEnabled(value:Boolean):void { _mouseEnabled = value; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
		
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; } 
		
		public function get child():IBitmapDrawable { return _image; }
		public function set child(value:IBitmapDrawable):void {
			if (value is TemplateSheet) {
				back = value;
			} else{
				_image = value as BitmapData;
			
				if(value){
					width = rect.width;
					height = rect.height;
				}
			}
		}
		
		public function get back():IBitmapDrawable { return _back; }
		public function set back(value:IBitmapDrawable):void {
			if (value is TemplateSheet){
				var init:Boolean = border != value && _height * _width > 0;
				
				_borderTemplate = value as TemplateSheet;
				
				if (init) setBack();
					
			} else _back = value as BitmapData;
		}
		
		public function get image():BitmapData { return _image; }
		public function get border():SpriteSheet { return _back as SpriteSheet; }
		
		public function get sheet():SpriteSheet { return child as SpriteSheet; }
		public function set sheet(value:SpriteSheet):void { _image = value; }
		
		public function get rect():Rectangle {
			
			if (sheet != null)
				return sheet.getFrame(defaultFrame).rect;
				
			if (_image == null)
				return null;
			
			return _image.rect;
		}
		
		public function get numFrames():int { 
			if (_image is SpriteSheet) return (child as SpriteSheet).numFrames;
			return 1;
		}
		
		public function get asset():Asset { return _asset; }
		public function set asset(value:Asset):void { _asset = value; }
		
		public function get stage():Stage {
			if(asset != null) return asset.stage;
			return null;
		}
		
		protected function get map():Blitmap { return (asset.parent as BlitLayer).parent; }
		
		public function get columns():int { return _columns; }
		public function set columns(value:int):void { _columns = value;
			
			_finiteColumns = true;
			
			if(value < 1) {
			
				if (stage != null)
					_columns = asset.bounds.bottom / rect.width;
				
				_finiteColumns = false; 
			} else if (stretchMode == StretchMode.TILE)
				borderRect.width = _width = columns * rect.width;
		}
		
		public function get rows():int { return _rows; }
		public function set rows(value:int):void { _rows = value;
			
			_finiteRows = true; 
			
			if (value < 1) {
				
				if (stage != null)
					_rows = asset.bounds.right / rect.height;
				
				_finiteRows = false; 
			} else if (stretchMode == StretchMode.TILE)
				borderRect.height = _height = rows * rect.height;
		}
		
		public function get borderTemplate():TemplateSheet { return _borderTemplate; }
		public function set borderTemplate(value:TemplateSheet):void { _borderTemplate = value; }
		
		public function get align():String { return _align; }
		public function set align(value:String):void { _align = value; }
		
		public function get stretchMode():String { return _stretch; }
		public function set stretchMode(value:String):void{
			_stretch = value;
			switch(value) {
				case StretchMode.STRETCH: break;
				case StretchMode.BORDER:
					
					if (_borderTemplate == null)
						back = Resources.DefaultBorder;
					
					break;
				case StretchMode.TILE:
					
					
					break;
			}
		}
		
		public function get tileMode():String { return _tileMode; }
		public function set tileMode(value:String):void { _tileMode = value; }
		
		public function get debugDraw():Boolean { return _debugDraw; }
		public function set debugDraw(value:Boolean):void { _debugDraw = value; }
		
		public function get color():uint{ return _color; }
		public function set color(value:uint):void { _color = value; }
		
		public function get tileMap():Array { return _tileMap; }
		public function set tileMap(value:Array):void { _tileMap = value; }
		
	}
}