package art 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Dialogue extends Sprite 
	{
		
		public function Dialogue() 
		{
			super();
		}
		
		override public function set width(value:Number):void {
			var h:Number = this.height;
			graphics.clear();
			graphics.lineStyle(1, 0xC0C0C0);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRoundRect(0, 0, value, h, 10, 10);
			graphics.endFill();
			super.width = value;
		}
		override public function set height(value:Number):void {
			var w:Number = this.width;
			graphics.clear();
			graphics.lineStyle(1, 0xC0C0C0);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRoundRect(0, 0, w, value, 10, 10);
			graphics.endFill();
			super.height = value;
		}
	}

}