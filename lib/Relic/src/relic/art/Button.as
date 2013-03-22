package relic.art {
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.BitmapData
	import relic.art.blitting.Blit;
	/**
	 * ...
	 * @author George
	 */
	public class Button extends Asset {
		public var isToggle:Boolean;
		
		private var _selected:Boolean;
		
		public var sprites:SpriteSheet;
		
		public function Button() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			isToggle = false;
			_selected = false;
		}
		override protected function addListeners():void {
			super.addListeners();
			addEventListener(MouseEvent.MOUSE_OVER, rollOver);
			addEventListener(MouseEvent.MOUSE_OUT, rollOver);
		}
		
		private function rollOver(e:MouseEvent):void {
			if (states.over == null) return;
			if (e.type == MouseEvent.MOUSE_OVER)
				graphic.currentAnimation = "over";
			else currentAnimation = "up";
		}
		
		//override public function get currentAnimation():String { return super.currentAnimation; }
		//override public function set currentAnimation(value:String):void {
			//if (states[value] == null){
				//trace("Button state: " + value + " could not be found.");
				//return;
			//}
			//_currentAnimation = value;
			//bm.bitmapData = states[value];
		//}
		
		public function get upState():Animation { return states.up; }
		public function set upState(value:Animation):void {
			states.up = value;
			if (currentAnimation == null) currentAnimation = "up";
		}
		public function get downState():Animation { return states.down; }
		public function set downState(value:Animation):void { states.down = value; }
		public function get overState():Animation { return states.over; }
		public function set overState(value:Animation):void { states.over = value; }
		public function get selectedState():Animation { return states.selected; }
		public function set selectedState(value:Animation):void { states.an("selected") = value; }
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			currentAnimation = (value ? "selected" : "up");
			_selected = value;
		}
		protected function get states():Blit { return graphic as Blit; }
	}
}