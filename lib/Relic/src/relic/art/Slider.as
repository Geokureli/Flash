package relic.art {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import relic.data.helpers.MathHelper;
	/**
	 * ...
	 * @author George
	 */
	public class Slider extends Asset {
		private var _min:Number,
					_max:Number,
					_interval:Number,
					_tickInterval:Number,
					_width:Number,
					_value:Number;
					
		private var _prefix:String,
					_suffix:String;
					
		private var drag:Dragger;
					
		private var _allowTextEdit:Boolean;
		private var _enabled:Boolean;
		
		public var txt_label:Text,
					txt_value:Text;
		
		public var dragInterval:Number;
		public var precision:int;
		
		public function Slider(min:Number = 0, max:Number = 10, interval:Number = 1, tickInterval:Number = 2) {
			_value = _min = min;
			_max = max;
			dragInterval = _interval = interval;
			_tickInterval = tickInterval;
			super();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			_prefix = _suffix = "";
			_allowTextEdit = false;
			_width = 100;
			Text.DEFAULT_FORMAT.align = TextFormatAlign.CENTER;
			addChild(txt_label = new Text(" "));
			addChild(txt_value = new Text(min.toString()));
			txt_value.width  = txt_label.width  = _width;
			txt_value.height = txt_label.height = 20;
			txt_value.y = -25;
			txt_label.y = 10;
			addChild(drag = new Dragger());
			draw();
		}
		override protected function addListeners():void {
			super.addListeners();
			drag.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
		}
		override protected function removeListeners():void {
			super.removeListeners();
			drag.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
			allowTextEdit = false;
		}
		
		protected function draw():void {
			
			txt_value.width  = txt_label.width  = _width * .75;
			graphics.clear();
			graphics.lineStyle(1);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(_width, 0);
			
			graphics.moveTo(0, -15);
			graphics.lineTo(0,  15);
			
			graphics.moveTo(_width, -15);
			graphics.lineTo(_width,  15);
			if (_tickInterval > 0) {
				var space:Number = _width / totalTicks;
				for (var x:Number = space; x < _width; x += space) {
					graphics.moveTo(x, -5);
					graphics.lineTo(x, 5);
				}
			}
			
			txt_value.x = txt_label.x = (_width-txt_label.width)/2;
		}
		
		private function mouseHandle(e:MouseEvent):void {
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
					break;
				case MouseEvent.MOUSE_MOVE:
					drag.x = e.stageX-x;
					if (drag.x < 0)
						drag.x = 0;
					
					if (drag.x > _width)
						drag.x = _width;
						
					// --- UPDATE TEXT
					if(dragInterval > 0 && dragInterval != _interval)
						value = MathHelper.roundTo(drag.x * (max - min) / _width + min, dragInterval);
					else value = drag.x * (max - min) / _width + min;
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
					if(dragInterval > 0 && dragInterval != _interval)
						value = MathHelper.roundTo(drag.x * (max - min) / _width + min, dragInterval);
					else value = drag.x * (max - min) / _width + min;
					dispatchEvent(new Event(Event.CHANGE));
					break;
			}
		}
		
		public function get min():Number { return _min; }
		public function set min(value:Number):void { _min = value; draw(); }
		
		public function get max():Number { return _max; }
		public function set max(value:Number):void { _max = value; draw(); }
		
		public function get interval():Number { return _interval; }
		public function set interval(value:Number):void { _interval = value; draw(); }
		
		public function get tickInterval():Number { return _tickInterval; }
		public function set tickInterval(value:Number):void { _tickInterval = value; draw(); }
		
		public function get totalTicks():Number { 
			if (_tickInterval == 0) return 0;
			return (max - min) / _tickInterval;
		}
		public function set totalTicks(value:Number):void {
			if (value == 0) tickInterval = 0;
			tickInterval = (max - min) / value;
		}
		
		public function get value():Number { return _value; }
		public function set value(value:Number):void {
			if (value < min) value = min;
			if (value > max) value = max;
			if(interval > 0)
				value = MathHelper.roundTo(value-min, interval) + min;
			_value = value;
			if (allowTextEdit)
				txt_value.text = precision > 0 ? value.toPrecision(precision) : value.toString();
			else txt_value.text = _prefix + (precision > 0 ? value.toPrecision(precision) : value.toString()) + _suffix;
			drag.x = (value-min) / (max - min) * _width;
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			_width = value;
			draw();
			//super.width = value;
		}
		
		public function get label():String { return txt_label.text; }
		public function set label(value:String):void { txt_label.text = value; }
		
		public function get valuePrefix():String { return _prefix; }
		public function set valuePrefix(value:String):void {
			_prefix = value;
			this.value = this.value;// --- UPDATE TEXT
		}
		
		public function get valueSuffix():String { return _suffix; }
		public function set valueSuffix(value:String):void {
			_suffix = value;
			this.value = this.value;// --- UPDATE TEXT
		}
		
		public function get allowTextEdit():Boolean { return _allowTextEdit; }
		public function set allowTextEdit(value:Boolean):void {
			_allowTextEdit = value;
			txt_value.border = txt_value.background = txt_value.selectable = txt_value.numMode = value;
			txt_value.type = (value ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
			if (value)
				txt_value.addEventListener(Event.CHANGE, onInputChange);
			else txt_value.removeEventListener(Event.CHANGE, onInputChange);
		}
		
		//public function get enabled():Boolean { return _enabled; }
		override public function set enabled(value:Boolean):void {
			if (value == super.enabled) return;
			if (value) {
				addListeners();
				allowTextEdit = _allowTextEdit;
			} else {
				var textEdit:Boolean = _allowTextEdit;
				removeListeners();
				_allowTextEdit = textEdit;
			}
			super.enabled = value;
		}
		
		private function onInputChange(e:Event):void {
			if (e.currentTarget.text.indexOf('.') < e.currentTarget.text.length - 1) {
				var value:Number = Number(e.currentTarget.text);
				if (value >= min)
					this.value = value;
				
				dispatchEvent(new Event(Event.CHANGE));
			}
			e.stopImmediatePropagation();
		}
		
	}

}
import flash.display.Sprite;
class Dragger extends Sprite{
	public function Dragger() {
		graphics.lineStyle(1);
		graphics.beginFill(0xFFFFFF);
		graphics.drawRect( -5, -10, 10, 20);
	}
}