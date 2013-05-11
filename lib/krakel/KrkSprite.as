package krakel {
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import krakel.xml.XMLParser;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author George
	 */
	public class KrkSprite extends FlxSprite {
		static private const ZERO:Point = new Point();
		
		static private const B_W:ColorMatrixFilter = new ColorMatrixFilter([
			1/3, 1/2, 1/6, 0, 0,
			1/3, 1/2, 1/6, 0, 0,
			1/3, 1/2, 1/6, 0, 0,
			0, 0, 0, 1, 0
		]);
		
		static public const GRAPHICS:Object = { };
		
		private var _graphic:String,
					_anim:String;
		
		public var filters:Vector.<Function>;
		
		private var _scheme:KrkScheme;
		
		public function KrkSprite(x:Number = 0, y:Number = 0, graphic:Class = null) {
			super(x, y, graphic);
		}
		public function setParameters(data:XML):void {
			XMLParser.setProperties(this, data);
		}
		override public function preUpdate():void {
			super.preUpdate();
			if (scheme != null) scheme.preUpdate();
		}
		override public function update():void {
			super.update();
			if (scheme != null) scheme.update();
		}
		override public function postUpdate():void {
			super.postUpdate();
			if (scheme != null) scheme.postUpdate();
		}
		
		override public function draw():void {
			var flicker:Boolean = _flicker;
			color = 0xFFFFFF;
			if (_flickerTimer != 0 && flicker) {
				color = 0xFF4040;
				_flicker = true;
			}
			super.draw();
			
			_flicker = !flicker;
		}
		override protected function calcFrame():void {
			super.calcFrame();
			if (filters != null)
				for each(var filter:Function in filters)
					filter(framePixels);
		}
		override public function destroy():void {
			super.destroy();
			
			filters = null;
			
			if (scheme != null) scheme.destroy();
			scheme = null;
			
			_graphic = null;
			_anim = null;
		}
		
		public function get scheme():KrkScheme { return _scheme; }
		public function set scheme(value:KrkScheme):void {
			if (_scheme != null) _scheme.kill();
			_scheme = value;
			if (_scheme != null) {
				value.target = this;
				_scheme.revive();
			}
		}
		
		override public function play(AnimName:String, Force:Boolean = false):void {
			super.play(AnimName, Force);
		}
		public function get anim():String {
			if (_curAnim == null) return _anim;
			return _curAnim.name;
		}
		public function set anim(value:String):void {
			play(_anim = value);
		}
		
		public function get graphic():String { return _graphic; }
		public function set graphic(value:String):void {
			_graphic = value;
			(GRAPHICS[value] as KrkGraphic).load(this);
		}
		
		public function get edges():uint { return allowCollisions; }
		public function set edges(value:uint):void { allowCollisions = value; }
		
		public function get xScale():Number { return scale.x; }
		public function set xScale(value:Number):void {
			scale.x = value;
			offset.y = (width - (frameWidth * value)) / 2;
			width = frameWidth * value;
		}
		
		public function get yScale():Number { return scale.y; }
		public function set yScale(value:Number):void {
			scale.y = value;
			offset.y = (height - (frameHeight * value)) / 2;
			height = frameHeight * value;
		}
		
		static public function desaturate(bmd:BitmapData):void {
			bmd.applyFilter(bmd, bmd.rect, ZERO, B_W);
		}
		static public function outline(bmd:BitmapData):void {
			bmd.applyFilter(bmd, bmd.rect, ZERO, new GlowFilter(0, 1, 2, 2, 3, 1));
		}
	}

}