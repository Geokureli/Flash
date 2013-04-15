package baseball.art {
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import krakel.beat.BeatKeeper;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author George
	 */
	public class Obstacle extends FlxSprite {
		static public const GLOW_FILTERS:Vector.<BitmapFilter> = Vector.<BitmapFilter>([
			new GlowFilter(0xFFFFFF, 1, 4, 4, 8, 1, true),
			new GlowFilter(0x000000, 1, 2, 2, 4, 1, true)
		]);
		static public const NO_FILTERS:Vector.<BitmapFilter> = new Vector.<BitmapFilter>();
		
		static public var HERO:FlxPoint = new FlxPoint();
		static public var SCROLL:Number;
		
		private var _glow:Boolean;
		
		private var filters:Vector.<BitmapFilter>;
		
		public var beat:Number;
		public var isRhythm:Boolean,
					isEditor:Boolean;
		
		public function Obstacle(y:Number = 0, Simplegraphic:Class = null) {
			super(1000, HERO.y + y, Simplegraphic);
			isRhythm = true;
			isEditor = false;
			_glow = false;
			filters = NO_FILTERS;
		}
		override public function update():void {
			super.update();
			
			if(isRhythm){
				x = HERO.x + BeatKeeper.toBeatPixels(SCROLL) * (BeatKeeper.beat - beat);
				if (x < -width*2 && !isEditor)
					kill();
			}
		}
		override protected function calcFrame():void {
			super.calcFrame();
			
			var p:Point = new Point();
			for each(var filter:BitmapFilter in filters)
				framePixels.applyFilter(framePixels, framePixels.rect, p, filter);
		}
		public function pass():void { }
		override public function revive():void {
			super.revive();
			isRhythm = true;
		}
		
		public function get glow():Boolean { return _glow; }
		public function set glow(value:Boolean):void {
			if (_glow != value) {
				dirty = true;
				filters = value ? GLOW_FILTERS : NO_FILTERS;
				_glow = value;
			}
		}
	}

}