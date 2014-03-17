package krakel.art {
	import flash.geom.Point;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkRepeatingTile extends FlxSprite {
		public var columns:int, rows:int;
		public var wrapX:Boolean,
					wrapY:Boolean;
		
		public function KrkRepeatingTile(x:Number, y:Number, graphic:Class = null, columns:int = 1, rows:int = 1) {
			super(x, y, graphic);
			this.rows = rows;
			this.columns = columns;
		}
		override public function postUpdate():void {
			super.postUpdate();
		}
		override public function draw():void {
			
			if (columns == -1)
				x %= frameWidth;
			
			if (rows == -1)
				y %= frameHeight;
			
			if (_flickerTimer != 0) {
				_flicker = !_flicker;
				if (_flicker) return;
			}
			
			if(dirty)	//rarely 
				calcFrame();
			
			if(cameras == null)
				cameras = FlxG.cameras;
			var camera:FlxCamera;
			
			var i:uint = 0;
			var l:uint = cameras.length;
			while (i < l) {
				
				camera = cameras[i++];
				//if (!onScreen(camera)) {
					//trace("skip: " + x, frameWidth)
					//continue;
				//}
				
				_point.x = x - int(camera.scroll.x * scrollFactor.x) - offset.x;
				_point.y = y - int(camera.scroll.y * scrollFactor.y) - offset.y;
				_point.x += _point.x > 0 ? 0.0000001 : -0.0000001;
				_point.y += _point.y > 0 ? 0.0000001 : -0.0000001;
				
				//if ((angle == 0 || _bakedRotation > 0) && scale.x == 1 && scale.y == 1 && blend == null) {
					//Simple render
					
					_flashPoint.x = _point.x;
					_flashPoint.y = _point.y;
					
					var p:Point = _flashPoint.clone();
					var max:Point = new Point(columns, rows);
					var min:Point = new Point();
					
					if (columns == -1) {
						// --- LEFT-MOST
						if (p.x < -frameWidth)
							p.x %= frameWidth;
						else if(p.x > 0)
							p.x = ((p.x % frameWidth) - frameWidth) % frameWidth;
						// --- MAX COLUMNS	
						max.x = Math.ceil(camera.buffer.width / frameWidth);
					} else max.x += int(p.x / frameWidth);
					
					min.x = Math.floor(p.x / frameWidth);
					
					if (p.x + (max.x - min.x - 1) * frameWidth >= camera.buffer.width)
						max.x = min.x + Math.ceil((camera.buffer.width - p.x) / frameWidth);
					
					
					if (rows == -1) {
						// --- LEFT-MOST
						if (p.y < -frameHeight)
							p.y %= frameHeight;
						else if(p.y > 0)
							p.y = ((p.y % frameHeight) - frameHeight) % frameHeight;
						// --- MAX COLUMNS	
						max.y = Math.ceil(camera.buffer.height / frameHeight);
					} else max.y += int(p.y / frameHeight);
					
					min.y = Math.floor(p.y / frameHeight);
					
					if (p.y + (max.y - min.y - 1) * frameHeight >= camera.buffer.height)
						max.y = min.y + Math.ceil((camera.buffer.height - p.y) / frameHeight);
					
					var ip:Point = new Point();
					var drawPos:Point = p.clone();
					
					for (ip.x = min.x; ip.x < max.x; ip.x++) {
						for (ip.y = min.y; ip.y < max.y; ip.y++) {
							camera.buffer.copyPixels(framePixels, _flashRect, drawPos, null, null, true);
							drawPos.y += _flashRect.height;
						}
						drawPos.x += _flashRect.width;
						drawPos.y = p.y;
					}
				//} else {
					//Advanced render
					//_matrix.identity();
					//_matrix.translate( -origin.x, -origin.y);
					//_matrix.scale(scale.x, scale.y);
					//if ((angle != 0) && (_bakedRotation <= 0))
						//_matrix.rotate(angle * 0.017453293);
					//_matrix.translate(_point.x + origin.x, _point.y + origin.y);
					//camera.buffer.draw(framePixels, _matrix, null, blend, null, antialiasing);
				//}
				//_VISIBLECOUNT++;
				if (FlxG.visualDebug && !ignoreDrawDebug)
					drawDebug(camera);
			}
		}
	}
}