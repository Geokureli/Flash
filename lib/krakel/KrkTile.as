package krakel {
	import krakel.helpers.StringHelper;
	import krakel.xml.XMLParser;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkTile extends FlxTile {
		
		public var data:XML;
		
		public var type:String;
		public var scheme:KrkScheme;
		public var kills:Boolean;
		public var frameTimer:Number;
		
		private var _frames:Vector.<uint>;
		private var timer:FlxTimer;
		private var indices:Vector.<uint>;
		private var _frame:int;
		
		public function KrkTile(tile:FlxTile) {
			super(tile.tilemap, tile.index, tile.width, tile.height, tile.visible, tile.allowCollisions);
			
			callback = tile.callback == null
					? defaultCallback
					: tile.callback;
			
			index = tile.index;
			filter = tile.filter;
			tile.destroy();
			
			frameTimer = 0;
		}
		
		public function setParameters(data:XML):void {
			allowCollisions = FlxObject.ANY;
			
			if (data.@cloud == "true") {
				allowCollisions = CEILING;
				delete data.@cloud;
			}
			XMLParser.setProperties(this, data);
			
			if (_frames != null) {
				_frame = _frames[0];
				var indices:Array = tilemap.getTileInstances(index);
				if(indices != null)
					this.indices = Vector.<uint>(indices);
			}
			
			if (frameTimer > 0) {
				timer = new FlxTimer();
				timer.start(frameTimer, 2, nextFrame);
			}
			
		}
		
		protected function nextFrame(timer:FlxTimer):void {
			timer.loops++;
			
			var lastFrame:int = _frame;
			
			if (_frames.length > 1)
				frame = _frames[(_frames.indexOf(frame) + 1) % _frames.length];
		}
		
		protected function defaultCallback(tile:KrkTile, obj:KrkSprite):void { hitObject(obj); }
		public function hitObject(obj:FlxObject):void {
			x = (mapIndex % tilemap.widthInTiles) * width;
			y = (mapIndex / tilemap.heightInTiles) * height;
			if (kills) obj.kill();
		}
		
		protected function setIndex(index:Number):void {
			var column:uint	= mapIndex % tilemap.widthInTiles;
			var row:uint	= mapIndex / tilemap.widthInTiles;
			tilemap.setTile(column, row, 0);
		}
		
		override public function update():void {
			super.update();
		}
		
		public function get currentPos():FlxPoint {
			return new FlxPoint(
				(mapIndex % tilemap.widthInTiles) * width, 
				(mapIndex / tilemap.heightInTiles) * height
			);
		}
		
		public function get edges():uint { return allowCollisions; }
		public function set edges(value:uint):void { allowCollisions = value; }
		
		public function get frame():uint { return _frame; }
		public function set frame(value:uint):void {
			if (value == _frame) return;
			_frame = value;
			
			for each (var tile:uint in indices)
				tilemap.setTileByIndex(tile, value);
		}
		
		public function get frames():String { return _frames.join(','); }
		public function set frames(value:String):void {
			
			_frames = new <uint>[];
			for each(var i:String in value.split(StringHelper.COMMAS))
				_frames.push(i == "#" ? index : int(i));
			
		}
		
		override public function destroy():void {
			super.destroy();
			type = null;
		}
		
		override public function toString():String {
			if (type == null) return super.toString();
			return "Tile: " + type;
		}
	}

}