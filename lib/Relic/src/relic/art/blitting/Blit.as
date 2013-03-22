package relic.art.blitting {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.Animation;
	import relic.art.Asset;
	import relic.art.IDisplay;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.events.AnimationEvent;
	import relic.data.events.AssetEvent;
	import relic.data.helpers.BitmapHelper;
	import relic.data.helpers.Random;
	import relic.data.shapes.Box;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	import relic.data.xml.IXMLParam;
	import relic.data.xml.XMLParser;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blit extends EventDispatcher implements IDisplay {
		
		protected var position:Point;
		
		private var _rows:int, _columns:int;
		
		private var _alpha:Number;
		
		private var _shape:Shape;
		
		private var _visible:Boolean,
					_finiteRows:Boolean,
					_finiteColumns:Boolean,
					_parallaxX:Boolean,
					_parallaxY:Boolean;
		
		private var _asset:Asset;
		
		private var _image:BitmapData;
		
		protected var tileMap:Vector.<Vector.<int>>;
		
		protected var defaultFrame:int;

		public var parallax:Point;
		
		public function Blit() {
			setDefaultValues();
			addEventListener(Event.ADDED_TO_STAGE, init);
			addListeners();
		}
		
		protected function setDefaultValues():void {
			position = new Point();
			parallax = new Point(1, 1);
			_visible = 
				_finiteColumns =
				_finiteRows = true;
			_columns = _rows = 1;
			defaultFrame = 0;
		}
		protected function addListeners():void { }
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (image != null) setGraphicBounds();
			setTileData();
		}
		public function setParameters(params:Object):IXMLParam {
			if (params is XML){
				XMLParser.setProperties(this, params as XML);
			} else for (var i:String in params)
				this[i] = params[i];
			return this;
		}
		protected function setGraphicBounds():void {
			var rect:Rectangle = this.rect;
			if (shape == null && rect != null)
				shape = new Box(rect.x, rect.y, rect.width, rect.height);
		}
		public function preUpdate():void{}
		public function update():void {
		}
		
		public function draw():void {
			var p:Point = new Point(position.x * parallax.x, position.y * parallax.y);
			
			if (columns == 1 && rows == 1)
				drawTile(position, 0, 0);
				
			else {
				var left:int = 0;	var right :int = columns;
				var top:int = 0;	var bottom:int = rows;
				if (!_finiteColumns){
					
					left = int((asset.bounds.left - asset.gLeft * parallax.x) / rect.width);
					while (left * rect.width + asset.gLeft * parallax.x > asset.bounds.left) left--;
					
					right = int((asset.bounds.right - asset.gRight * parallax.x) / rect.width);
					while (right * rect.width + asset.gRight * parallax.x < asset.bounds.right) right ++;
					p.x += left * rect.width;
					right++;
				}
				if (!_finiteRows){
					
					top = int((asset.bounds.top - asset.gTop * parallax.y) / rect.height);
					while (top * rect.height + asset.gTop * parallax.y > asset.bounds.top) top--;
					
					bottom = int((asset.bounds.bottom - asset.gBottom * parallax.y) / rect.height);
					while (bottom * rect.height + asset.gBottom * parallax.y < asset.bounds.bottom) bottom++;
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
		}
		protected function setTileData():void {
			if (image == null) return;
			if (!_finiteColumns)	_columns	= asset.bounds.right  / rect.width;
			if (!_finiteRows)		_rows 		= asset.bounds.bottom / rect.height;
			if (image is SpriteSheet) {
				
				tileMap = new Vector.<Vector.<int>>();
				
				for (var i:int = 0; i < columns; i++) {
					tileMap.push(new Vector.<int>());
					for (var j:int = 0; j < rows; j++)
						tileMap[i].push(Random.random(numFrames));
				}
			}
		}
		protected function drawTile(position:Point, xIndex:int, yIndex:int):void {
			if (image != null) {
				if (image is SpriteSheet) {
					(image as SpriteSheet).drawFrame(getTile(
						((xIndex % columns) + columns) % columns,
						((yIndex % rows) + rows) % rows
					), map.bitmapData, position);
				} else
					BitmapHelper.drawTo(image, map.bitmapData, position);
			}
		}
		
		protected function getTile(x:int, y:int):int {
			return tileMap[x][y];
		}
		
		public function destroy():void {
			position = null;
			
			asset = null;
		}
		
		/* INTERFACE relic.art.IDisplay */
		
		public function get needsRedraw():Boolean { return _visible; }
		
		public function get x():Number { return position.x; }
		public function set x(value:Number):void { position.x = value; }
		
		public function get y():Number { return position.y; }
		public function set y(value:Number):void { position.y = value; }
		
		
		/** The left collision bound of the asset. */
		public function get left():Number	{ return _shape == null ? 0 : _shape.left; }
		/** The right collision bound of the asset. */
		public function get right():Number	{ return _shape == null ? 0 : _shape.right; }
		/** The top collision bound of the asset. */
		public function get top():Number	{ return _shape == null ? 0 : _shape.top; }
		/** The bottom collision bound of the asset. */
		public function get bottom():Number	{ return _shape == null ? 0 : _shape.bottom; }
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
		
		public function get shape():Shape { return _shape; }
		public function set shape(value:Shape):void { _shape = value; }
		
		public function get image():BitmapData { return _image; }
		public function set image(value:BitmapData):void { _image = value; }
		
		public function get rect():Rectangle {
			if (_image is SpriteSheet) return (image as SpriteSheet).getFrame(defaultFrame).rect;
			return _image.rect;
		}
		
		public function get numFrames():int { 
			if (_image is SpriteSheet) return (image as SpriteSheet).numFrames;
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
		public function set columns(value:int):void {
			_columns = value;
			_finiteColumns = true;
			if(value < 1) {
				if (stage != null)
					_columns = asset.bounds.bottom / rect.width;
				
				_finiteColumns = false; 
			}
		}
		
		public function get rows():int { return _rows; }
		public function set rows(value:int):void {
			_rows = value;
			_finiteRows = true; 
			if (value < 1) {
				if (stage != null)
					_rows = asset.bounds.right / rect.height;
				
				_finiteRows = false; 
			}
		}
		
	}
}