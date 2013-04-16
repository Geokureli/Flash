package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.helpers.BitmapHelper;
	/**
	 * ...
	 * @author George
	 */
	public class SpriteSheet extends BitmapData {
		
		private var flip:Boolean;
		
		private var _columns:int,
					_rows:int;
		
		public var groups:Object;
		
		public var frames:Vector.<Rectangle>;
		
		public function SpriteSheet(graphic:BitmapData, flip:Boolean = false) {
			super(graphic.width, graphic.height, true, 0);
			
			copyPixels(graphic, rect, new Point());
			
			setDefaultValues();
		}
		
		protected function setDefaultValues():void {
			_columns = _rows = 1;
			groups = { };
		}
		public function createGrid(width:int = 0, height:int = 0):void {
			
			if (width == 0)
				width = height = Math.min(this.width, this.height);
			else if (height == 0)
				height = Math.min(width, this.height);
				
			frames = new Vector.<Rectangle>();
			var r:Rectangle = new Rectangle(0, 0, width, height);
			var b:BitmapData;
			
			_columns = this.width / r.width;
			_rows = this.height / r.height;
			
			for (r.y = 0; r.bottom <= this.height; r.y += r.height) {
				for (r.x = 0; r.right <= this.width; r.x += r.width) {
					frames.push(r.clone());
				}
			}
		}
		public function createDefualtAnimation(loop:Boolean = true, rate:int = 2):void {
			var frames:Array = [];
			for (var i:int = 0; i < numFrames; i++)
				frames.push(i);
				addAnimation("default", "idle", frames, loop, rate);
		}
		public function clearBG(color:int = -1):void {
			BitmapHelper.clearBG(this, color);
		}
		public function getFrame(num:int):BitmapData {
			var rect:Rectangle = frames[num];
			var bm:BitmapData = new BitmapData(rect.width, rect.height);
			drawFrame(num, bm, new Point());
			return bm;
		}
		public function hasGroup(id:String):Boolean { return id in groups; }
		
		public function addGroup(id:String, animations:Object, loop:Boolean = true, rate:int = 2):void {
			groups[id] = { };
			
			var frames:Array;
			for (var anim:String in animations) {
				var _loop:Boolean = loop;
				var _rate:int = rate;
				if ("frames" in animations[anim]) { 
					
					frames = animations[anim].frames;
					if ("loop" in animations[anim]) _loop = animations[anim].loop
					if ("rate" in animations[anim]) _rate = animations[anim].rate
				} else 
					frames = animations[anim];
				
				addAnimation(id, anim, frames, _loop, _rate);
			}
		}
		
		public function addAnimation(group:String, name:String, frames:Array, loop:Boolean = true, rate:int = 2):Animation {
			if (group == null) group = "default";
			if (!(group in groups)) groups[group] = { };
			groups[group][name] = new Animation(this, frames);
			groups[group][name].loop = loop;
			groups[group][name].rate = rate;
			return groups[group][name];
		}
		public function drawFrame(num:int, target:BitmapData, dest:Point = null):void {
			BitmapHelper.DrawTo(this, target, dest, frames != null ? frames[num] : rect);
		}
		
		public function destroy():void {
			for each(var group:Object in groups)
				for each(var anim:Animation in group)
					anim.destroy();
			
			anim = null;
			frames = null;
			dispose();
		}
		public function get numFrames():int { return frames.length; }
		
		public function get columns():int { return _columns; }
		public function get rows():int { return _rows; }
		
		override public function clone():BitmapData {
			return new SpriteSheet(this);
		}
		public function scale(value:Number):SpriteSheet {
			
			var sheet:SpriteSheet = new SpriteSheet(new BitmapData(width * value, height * value), false);
			BitmapHelper.DrawTo(this, sheet, new Point(), rect, { scale:value } );
			
			if (frames != null && frames.length > 0)
				sheet.createGrid(frames[0].width * value, frames[0].height * value);
				
			return sheet;
		}
	}

}
