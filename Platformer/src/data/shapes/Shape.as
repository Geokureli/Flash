package data.shapes 
{
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author George
	 */
	public class Shape extends EventDispatcher
	{
		public var density:Number;
		public var autoCenter:Boolean;
		
		public function Shape() 
		{
			density = 1;
			autoCenter = false;
		}
		
		public function debugDraw(g:Graphics):void { }
		
		public function get left():Number { return 0; }
		public function get right():Number { return 0; }
		public function get top():Number { return 0; }
		public function get bottom():Number { return 0; }
	}

}