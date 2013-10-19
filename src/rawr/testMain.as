package rawr {
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	import mx.managers.ISystemManager;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import mx.core.IUIComponent;
	
	/**
	 * ...
	 * @author George
	 */
	public class testMain extends Sprite {//implements IUIComponent {
		
		public function testMain() {
			var obj2:TestClassStrict;
			var obj3:TestClassLoose;
			var t:int;
			var i:int;
			var obj1:Object;
			
			t = getTimer();
			for (i = 0; i < 1000000; i++) 
				obj1 = { x:0, y:0, z:0 };
			trace("object - declaration:\t", getTimer() - t);
			
			t = getTimer();
			for (i = 0; i < 1000000; i++)
				obj2 = new TestClassStrict(0, 0, 0);
			trace("strict type - declaration:\t", getTimer() - t);
			
			t = getTimer();
			for (i = 0; i < 1000000; i++)
				obj3 = new TestClassLoose(0, 0, 0);
			trace("loose type - declaration:\t", getTimer() - t);
			
			t = getTimer();
			for (i = 0; i < 10000000; i++)
				obj1.x++;
			trace("object - manipulation:\t", getTimer() - t);
			
			t = getTimer();
			for (i = 0; i < 10000000; i++)
				obj2.x++;
			trace("strict type - manipulation:\t", getTimer() - t);
			
			t = getTimer();
			for (i = 0; i < 10000000; i++)
				obj3.x++;
			trace("loose type - manipulation:\t", getTimer() - t);
		}
		
		/* INTERFACE mx.core.IUIComponent */
		
		private var _baselinePosition:Number;
		public function get baselinePosition():Number { return _baselinePosition; }
		
		private var _document:Object;
		public function get document():Object { return _document; }
		public function set document(value:Object):void { _document = value; }
		
		private var _enabled:Object;
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void { _enabled = value; }
		
		private var _explicitWidth:Number;
		public function get explicitWidth():Number { return _explicitWidth; }
		public function set explicitWidth(value:Number):void { _explicitWidth = value; }
		private var _explicitHeight:Number;
		public function get explicitHeight():Number { return _explicitHeight; }
		public function set explicitHeight(value:Number):void { _explicitHeight = value; }
		
		private var _explicitMaxWidth:Number;
		public function get explicitMaxWidth():Number { return _explicitMaxWidth; }
		private var _explicitMaxHeight:Number;
		public function get explicitMaxHeight():Number { return _explicitMaxHeight; }
		
		private var _explicitMinWidth:Number;
		public function get explicitMinWidth():Number { return _explicitMinWidth; }
		private var _explicitMinHeight:Number;
		public function get explicitMinHeight():Number { return _explicitMinHeight; }
		
		private var _focusPane:Sprite;
		public function get focusPane():flash.display.Sprite { return _focusPane; }
		public function set focusPane(value:Sprite):void { _focusPane = value; }
		
		private var _includeInLayout:Boolean;
		public function get includeInLayout():Boolean { return _includeInLayout; }
		public function set includeInLayout(value:Boolean):void { _includeInLayout = value; }
		
		private var _isPopUp:Boolean;
		public function get isPopUp():Boolean { return _isPopUp; }
		public function set isPopUp(value:Boolean):void { _isPopUp = value; }
		
		private var _maxWidth:Number;
		public function get maxWidth():Number { return _maxWidth; }
		private var _maxHeight:Number;
		public function get maxHeight():Number { return _maxHeight; }
		
		
		private var _measuredMinWidth:Number;
		public function get measuredMinWidth():Number { return _measuredMinWidth; }
		public function set measuredMinWidth(value:Number):void { _measuredMinWidth = value; }
		private var _measuredMinHeight:Number;
		public function get measuredMinHeight():Number { return _measuredMinHeight; }
		public function set measuredMinHeight(value:Number):void { _measuredMinHeight = value; }
		
		
		private var _minWidth:Number;
		public function get minWidth():Number { return _minWidth; }
		private var _minHeight:Number;
		public function get minHeight():Number { return _minHeight; }
		
		private var _owner:DisplayObjectContainer;
		public function get owner():DisplayObjectContainer { return _owner; }
		public function set owner(value:DisplayObjectContainer):void { _owner = value; }
		
		
		private var _percentWidth:Number;
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void { _percentWidth = value; }
		private var _percentHeight:Number;
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void { _percentHeight = value; }
		
		private var _systemManager:ISystemManager;
		public function get systemManager():ISystemManager { return _systemManager; }
		public function set systemManager(value:ISystemManager):void { _systemManager = value; }
		
		
		private var _tweeningProperties:Array;
		public function get tweeningProperties():Array { return _tweeningProperties; }
		public function set tweeningProperties(value:Array):void { _tweeningProperties = value; }
		

		private var _measuredWidth:Number;
		public function get measuredWidth():Number { return _measuredWidth; }
		private var _measuredHeight:Number;
		public function get measuredHeight():Number { return _measuredHeight; }
		
		public function initialize():void { }
		
		public function parentChanged(p:DisplayObjectContainer):void { }
		
		public function getExplicitOrMeasuredWidth():Number { return _explicitWidth; }
		
		public function getExplicitOrMeasuredHeight():Number { return _explicitHeight; }
		
		public function setVisible(value:Boolean, noEvent:Boolean = false):void { visible = value; }
		
		public function owns(displayObject:DisplayObject):Boolean { return false; }
		
		
		public function move(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		public function setActualSize(newWidth:Number, newHeight:Number):void {
			_explicitWidth = newWidth;
			_explicitHeight = newHeight;
		}
		
	}

}

class TestClassStrict {
	private var y:int;
	private var z:int;
	public var x:int;
	public function TestClassStrict(x:int, y:int, z:int) {
		this.z = z;
		this.y = y;
		this.x = x;
	}
}

dynamic class TestClassLoose {
	public function TestClassLoose(x:*, y:*, z:*) {
		this.z = z;
		this.y = y;
		this.x = x;
	}
}