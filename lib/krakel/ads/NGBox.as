package krakel.ads {
	import com.newgrounds.API;
	import com.newgrounds.components.FlashAd;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author George
	 */
	public class NGBox extends AdBox {
		
		public var completeCallback:Function;
		
		private var apiID:String;
		private var encryptionKey:String;
		
		private var ngAd:FlashAd;
		
		public function NGBox(apiID:String, encryptionKey:String) {
			super();
			this.encryptionKey = encryptionKey;
			this.apiID = apiID;
		}
		override protected function onAdded(e:Event):void {
			super.onAdded(e);
			
			API.connect(root, apiID, encryptionKey);
		}
		override public function submit(target:String, value:int, args:Object = null):void {
			super.submit(target, value, args);
			if (target in scoreIDs) target = scoreIDs[target];
			API.postScore(target, value);
		}
		
		override public function preloaderAd(onComplete:Function):void {
			showAd(onComplete);
		}
		
		override public function clickAwayAd(onComplete:Function):void {
			showAd(null, false);
			onComplete();
		}
		
		override protected function interLevelAd(onComplete:Function):void {
			//showAd(onComplete, true, true);
			onComplete();
		}
		
		private function showAd(onComplete:Function = null, showBorder:Boolean = true, force:Boolean = false):void {
			var timeDif:uint = getTimer() - lastAdTime;
			// --- SKIP AD IF TOO FREQUENT
			if (getTimer() - lastAdTime < minAdFrequency && !force) {
				var minutes:int = timeDif / 60000;
				timeDif %= 60000;
				var seconds:int = timeDif / 1000;
				trace("ad skipped(frequency) - " + minutes + ':' + seconds);
				onComplete();
				return;
			}
			
			addChild(ngAd = new FlashAd());
			ngAd.x = (stage.stageWidth - ngAd.width) / 2;
			ngAd.y = (stage.stageHeight - ngAd.height) / 2;
			lastAdTime = getTimer();
			if (onComplete != null) {
				completeCallback = onComplete;
				ngAd.showPlayButton = true;
				ngAd.playButton.addEventListener(MouseEvent.CLICK, onClickPlay);
			} else {
				ngAd.showPlayButton = false;
			}
			ngAd.showBorder = showBorder;
		}
		override public function clean():void {
			if (ngAd == null) return;
			if (contains(ngAd)) removeChild(ngAd);
			ngAd.playButton.removeEventListener(MouseEvent.CLICK, onClickPlay);
			ngAd.removeAd();
			ngAd = null;
		}
		
		private function onClickPlay(e:MouseEvent):void {
			completeCallback();
			completeCallback = null;
		}
		
	}

}
