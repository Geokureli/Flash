package baseball.art {
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.flixel.FlxButton;
	
	/**
	 * ...
	 * @author George
	 */
	public class Button extends FlxButton {
		protected var overlay:BitmapData;
		protected var overlayPoint:Point;
		public var name:String;
		public function Button(
			x:int = 0,
			y:int = 0,
			graphic:BitmapData = null,
			overlay:BitmapData = null,
			onClick:Function = null) {
			super(x, y, null, onClick);
			
			this.overlay = overlay;
			
			if (graphic != null) {
				pixels = graphic;
				frameWidth = width = pixels.width/4;
				frameHeight = height = pixels.height;
				resetHelpers();
				if (overlay != null)
					overlayPoint = new Point(
						int((frameWidth  - overlay.width ) / 2),
						int((frameHeight - overlay.height) / 2)
					);
			}
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			
			if(!exists || !visible || !active || (status != PRESSED))
				return;
			
			super.onMouseUp(event);
			on = !on;
		}
		override protected function calcFrame():void {
			super.calcFrame();
			if (overlay != null)
				framePixels.copyPixels(overlay, overlay.rect, overlayPoint, null, null, true);
		}
	}

}