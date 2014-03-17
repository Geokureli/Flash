package astley.art {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import krakel.KrkBitmapFont;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/**
	 * ...
	 * @author George
	 */
	public class ScoreText extends KrkBitmapFont {
		
		[Embed(source = "../../../res/astley/graphics/numbers_10.png")] static private const FONT:Class;
		
		static private const SHADOW_POINT:Point = new Point(1, 1);
		
		public function ScoreText(x:int = 0, y:int = 0, shadow:Boolean = false) {
			super(FONT, 8, 10, "0123456789", 10);
			
			this.x = x;
			this.y = y;
			
			var rect:Rectangle = grabData['1'.charCodeAt(0)];
			rect.x++;
			rect.width -= 2;
			padding.x = -1;
			text = '0';
		}
		
		override public function draw():void {
			if(cameras == null)
				cameras = FlxG.cameras;
			
			var camera:FlxCamera;
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
			{
				camera = cameras[i++];
				if(!onScreen(camera))
					continue;
					
				_point.x = x - int(camera.scroll.x * scrollFactor.x) - offset.x + 1;
				_point.y = y - int(camera.scroll.y * scrollFactor.y) - offset.y + 1;
				_point.x += (_point.x > 0) ? 0.0000001 : -0.0000001;
				_point.y += (_point.y > 0) ? 0.0000001 : -0.0000001;
				_flashPoint.x = _point.x;
				_flashPoint.y = _point.y;
				camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			super.draw();
		}
		
		override public function set text(value:String):void {
			super.text = int(value).toString();
		}
	}

}