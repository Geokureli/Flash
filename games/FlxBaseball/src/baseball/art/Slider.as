package baseball.art {
	import krakel.helpers.MathHelper;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author George
	 */
	public class Slider extends FlxGroup {
		private var _x:Number,
					_y:Number,
					_min:Number,
					_max:Number,
					_interval:Number,
					_tickInterval:Number,
					_width:Number,
					_height:Number,
					_value:Number;
		
		private var _prefix:String,
					_suffix:String,
					_label:String;
		
		private var _enabled:Boolean;
		
		public var dragInterval:Number;
		public var precision:int;
		
		public var drag:Dragger;
		public var line:Line;
		public var txt_value:Text,
					txt_label:Text;
		public var changedCallback:Function;
		
		public function Slider(min:Number = 0, max:Number = 10, interval:Number = 1, tickInterval:Number = 2) {
			super();
			
			_value = _min = min;
			_max = max;
			dragInterval = _interval = interval;
			_tickInterval = tickInterval;
			
			_prefix = _suffix = "";
			_width = 100;
			add(txt_value = new Text(value.toString()));
			txt_value.offset.y = 10;
			add(txt_label = new Text(" "));
			txt_label.offset.y = -20;
			
			add(line = new Line(_tickInterval == 0 ? 0 : (max - min) / _tickInterval));
			add(drag = new Dragger(width));
			drag.mouseReleasedCallback = onChange;
		}
		
		override public function update():void {
			super.update();
			if (drag.isDragged)
				value = MathHelper.roundTo((drag.x - x + drag.width / 2) * (_max - _min) / _width + _min, dragInterval);
		}
		private function onChange(drag:Dragger, x:int, y:int):void {
			if (changedCallback != null) changedCallback(this);
			drag.x = this.x + _width * (_value-_min) / (_max - _min) - drag.width/2;
		}
		
		public function get value():Number { return _value; }
		public function set value(value:Number):void {
			_value = value;
			txt_value.text = _prefix + value.toString() + _suffix;
			if (!drag.isDragged) {
				if (_value > _max) _value = _max;
				if (_value > _min) _value = _min;
				drag.x = this.x + _width * (_value-_min) / (_max - _min) - drag.width/2;
			}
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = txt_value.x = txt_label.x = drag.x = line.x = drag.boundsRect.x = value;
			drag.boundsRect.x = drag.x = value - drag.width / 2;
			this.value = this.value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = txt_value.y = txt_label.y = drag.y = line.y = drag.boundsRect.y = value;
		}
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width =
				txt_value.width =
				txt_label.width =
				line.width = value;
			
			drag.boundsRect.width = value + drag.width;
			
			line.drawBar();
			line.dirty = true;
			txt_value.dirty = true;
			txt_label.dirty = true;
		}
		
		public function get tickInterval():Number { return _tickInterval; }
		
		public function set tickInterval(value:Number):void {
			_tickInterval = value;
		}
		
		public function get label():String { return _label; }
		public function set label(value:String):void { txt_label.text = _label = value; }
		
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
	}

}
import org.flixel.FlxRect;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
class Dragger extends FlxExtendedSprite{
	public var boundWidth:Number;
	
	public function Dragger(dragWidth:Number) {
		super();
		makeGraphic(11, 20, 0xFF808080);
		//offset.x = this.width/2;
		offset.y = -5;
		boundWidth = dragWidth;
		enableMouseDrag(true, false, 255, new FlxRect(-width/2, 0, boundWidth + width, height));
	}
}
class Line extends FlxSprite {
	public var totalTicks:int;
	
	public function Line(ticks:int) {
		super();
		
		width = 100;
		height = 30;
		
		dirty = true;
		totalTicks = ticks;
		
		drawBar();
	}
	public function drawBar():void {		
		frameWidth = width;
		frameHeight = height;
		pixels = new BitmapData(width, height, true, 0);
		pixels.fillRect(new Rectangle(0, height/2, width, 1), 0xFF000000);	// --- H-RULE
		pixels.fillRect(new Rectangle(0, 0, 1, height), 0xFF000000);		// --- LEFT
		pixels.fillRect(new Rectangle(width-1, 0, 1, height), 0xFF000000);	// --- RIGHT
		// --- TICKS
		if (totalTicks > 0) {
			var space:Number = width / totalTicks;
			
			for (var x:Number = space; x < width; x += space) 
				pixels.fillRect(new Rectangle(x - 1, height/3, 1, height/3), 0xFF000000);
		}
	}
}
class Text extends FlxText {
	public function Text(text:String = " ", embedFont:Boolean = false) {
		super(0, 0, 100, text, embedFont);
		alignment = "center";
		color = 0;
	}
}