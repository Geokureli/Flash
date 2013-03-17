package relic.art {
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.BitmapData
	/**
	 * ...
	 * @author George
	 */
	public class Button extends Asset {
		public var states:ButtonStates;
		public var isToggle:Boolean;
		private var _selected:Boolean;
		public function Button() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			states = new ButtonStates();
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
				currentAnimation = "over";
			else currentAnimation = "up";
		}
		
		override public function get currentAnimation():String { return super.currentAnimation; }
		override public function set currentAnimation(value:String):void {
			if (states[value] == null){
				trace("Button state: " + value + " could not be found.");
				return;
			}
			_currentAnimation = value;
			bm.bitmapData = states[value];
		}
		
		public function get upState():BitmapData { return states.up; }
		public function set upState(value:BitmapData):void {
			states.up = value;
			if (currentAnimation == null) currentAnimation = "up";
		}
		public function get downState():BitmapData { return states.down; }
		public function set downState(value:BitmapData):void { states.down = value; }
		public function get overState():BitmapData { return states.over; }
		public function set overState(value:BitmapData):void { states.over = value; }
		public function get selectedState():BitmapData { return states.selected; }
		public function set selectedState(value:BitmapData):void { states.selected = value; }
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			currentAnimation = (value ? "selected" : "up");
			_selected = value;
		}
	}
}
import flash.display.BitmapData;
class ButtonStates {
	public var up:BitmapData, down:BitmapData, over:BitmapData, selected:BitmapData;
}