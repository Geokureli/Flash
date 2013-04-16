package relic.art.blitting {
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author George
	 */
	public class FontSheet extends SpriteSheet {
		public var chars:String;
		
		public function FontSheet(graphic:BitmapData) { super(graphic); }
		
		public function setChars(chars:String, group:String = null):void {
			
			for (var i:int = 0; i < chars.length; i++)
				addAnimation(group, chars.charAt(i), [i]);
				
			this.chars = chars
		}
		
		public function getCharFrame(char:String):int { return chars.indexOf(char); }
	}

}