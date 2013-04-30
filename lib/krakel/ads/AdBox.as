package krakel.ads {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class AdBox extends MovieClip {
		
		static public var instance:AdBox;
		
		public var _width:Number, _height:Number;
		
		public function AdBox() {
			super();
			instance = this;
			name = "adBox";
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			_width = stage.stageWidth;
			_height = stage.stageHeight;
		}
		
		public function preloaderAd(onComplete:Function):void {}
		
		protected function loadDock(position:String):void {}
		
		protected function interLevelAd(onComplete:Function):void {}
		
		public function sendVar(target:String, value:int):void {}
		
		public function clickAwayAd(onComplete:Function):void {}
		
		static public function createDock(position:String = "top"):void {
			trace("AdBox: Dock created");
			if (instance != null)
				instance.loadDock(position);
		}
		
		static public function showPreLoaderAd(onComplete:Function = null):void {
			trace("AdBox: preloader ad shown");
			if (instance == null) {
				if (onComplete != null) onComplete();
				return;
			}
			instance.preloaderAd(onComplete);
		}
		
		static public function showInterLevelAd(onComplete:Function = null):void {
			trace("AdBox: inter level ad shown");
			if (instance == null) {
				if (onComplete != null) onComplete();
				return;
			}
			instance.interLevelAd(onComplete);
		}
		static public function showClickAwayAd(onComplete:Function = null):void {
			trace("AdBox: click-away ad shown");
			if (instance == null) {
				if (onComplete != null) onComplete();
				return;
			}
			instance.clickAwayAd(onComplete);
		}
		
		static public function sendVar(target:String, value:int):void {
			trace("AdBox: " + target + " = " + value);
			if (instance != null)
				instance.sendVar(target, value);
		}
		
	}

}