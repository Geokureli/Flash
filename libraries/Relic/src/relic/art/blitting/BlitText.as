package relic.art.blitting {
	import flash.events.Event;
	import relic.StretchMode;
	/**
	 * ...
	 * @author George
	 */
	public class BlitText extends Blit {
		private var _text:String;
		
		public function BlitText(font:SpriteSheet = null, text:String = null) {
			super(font);
			this.text = text;
			stretchMode = StretchMode.TILE;
		}
		
		override protected function getNewTileFrame(xIndex:int, yIndex:int):int {
			if (xIndex >= text.length) return font.getCharFrame(' ');
			return font.getCharFrame(text.charAt(xIndex));
		}
		
		override protected function init(e:Event):void {
			columns = text.length;
			super.init(e);
		}
		
		override public function preUpdate():void {
			super.preUpdate();
		}
		
		public function get text():String { return _text; }
		public function set text(value:String):void { _text = value; }
		
		public function get font():FontSheet { return child as FontSheet; }
	}

}