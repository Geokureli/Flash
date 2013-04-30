package krakel {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkGame extends FlxGame {
		static private const SCAN_LINE_COLOR:Number = 0x80000000;
		
		private var _trackFocus:Boolean;
		
		/**
		 * @inheritDoc
		 */
		public function KrkGame(width:Number, height:Number, state:Class, zoom:Number = 1, gameFrameRate:uint = 60, flashFrameRate:uint = 30, useSystemCursor:Boolean = false) {
			super(width, height, state, zoom, gameFrameRate, flashFrameRate, useSystemCursor);
			_trackFocus = true;
		}
		override protected function create(e:Event):void {
			super.create(e);
			useSystemCursor = true;
		}
		override protected function switchState():void {
			var prevState:FlxState = FlxG.state;
			super.switchState();
			if (prevState != null && FlxG.state is KrkState)
				(FlxG.state as KrkState).parentState = prevState;
			if(FlxG.debug) FlxG.mouse.show();
		}
		
		override protected function draw():void {
			super.draw();
			return;
			var target:BitmapData = FlxG.camera.buffer;
			for (var rect:Rectangle = new Rectangle(0, 0, target.width, 1); rect.y < target.height; rect.y += 2) {
				target.fillRect(rect, SCAN_LINE_COLOR);
			}
		}
		
		override protected function onFocusLost(FlashEvent:Event = null):void {
			if (_focus.visible) return;
			super.onFocusLost(FlashEvent);
			var state:KrkState = FlxG.state as KrkState;
			if (state != null) state.pause();
		}
		override protected function onFocus(FlashEvent:Event = null):void {
			if (!_focus.visible) return;
			super.onFocus(FlashEvent);
			var state:KrkState = FlxG.state as KrkState;
			if (state != null) state.unpause();
		}
		
		public function get trackFocus():Boolean { return _trackFocus; }
		
		public function set trackFocus(value:Boolean):void {
			if (_trackFocus == value) return;
			_trackFocus = value;
			if (value) {
				stage.addEventListener(Event.DEACTIVATE, onFocusLost);
				stage.addEventListener(Event.ACTIVATE, onFocus);
			} else {
				stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
				stage.removeEventListener(Event.ACTIVATE, onFocus);
			}
		}
	
	}

}