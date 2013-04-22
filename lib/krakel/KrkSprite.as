package krakel {
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author George
	 */
	public class KrkSprite extends FlxSprite{
		
		public function KrkSprite(x:Number = 0, y:Number = 0, graphic:Class = null) {
			super(x, y, graphic);
		}
		
		override public function draw():void {
			var flicker:Boolean = _flicker;
			color = 0xFFFFFF;
			if (_flickerTimer != 0 && flicker) {
				color = 0xFF4040;
				_flicker = true;
			}
			super.draw();
			
			_flicker = !flicker;
		}
	}

}