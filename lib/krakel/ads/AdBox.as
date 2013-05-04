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
		static public var minAdFrequency:int = 5 * 60000;// --- 5 minutes
		
		public var _width:Number, _height:Number;
		public var lastAdTime:int;
		
		
		protected var scoreIDs:Object;
		
		public function AdBox() {
			super();
			instance = this;
			name = "adBox";
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			scoreIDs = { };
			lastAdTime = int.MIN_VALUE;
		}
		
		protected function onAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			_width = stage.stageWidth;
			_height = stage.stageHeight;
		}
		
		public function preloaderAd(onComplete:Function):void {}
		
		protected function loadDock(position:String):void {}
		
		protected function interLevelAd(onComplete:Function):void {}
		
		public function submit(target:String, value:int, args:Object = null):void {}
		
		public function clickAwayAd(onComplete:Function):void {}
		
		public function clean():void {}
		/**
		 * sets a reference string that will be replaced by the target string,
		 * useful if you set up different variables on different publisher scoreboards.
		 * @param	target: The publishers variable used to display scores
		 * @param	id: The handle used to refer to it.
		 */
		public function setScoreTarget(target:String, id:String):void { scoreIDs[id] = target; }
		
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
		
		static public function cleanAds(leaveDock:Boolean = true):void {
			if (instance != null) instance.clean();
		}
		
		static public function submitScore(target:String, value:int, args:Object = null):void {
			trace("AdBox: " + target + " = " + value);
			if (instance != null)
				instance.submit(target, value);
		}
		
	}

}