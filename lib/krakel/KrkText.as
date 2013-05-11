package krakel {
	import flash.text.TextFormat;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkText extends FlxText {
		
		public function KrkText(x:Number = 0, y:Number = 0, width:uint = 1, text:String=null, embed:Boolean=true) {
			super(x, y, width, text, embed);
		}
		override public function preUpdate():void {
			if (pixels.width != width) resetWidth();
			super.preUpdate();
			
		}
		private function resetWidth():void {
			makeGraphic(width, 1, 0);
			_textField.width = width;
			_regen = true;
		}
		
	}

}