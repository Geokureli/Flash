package  {
	import com.newgrounds.components.FlashAd;
	/**
	 * ...
	 * @author George
	 */
	public class NGPreloader extends Preloader {
		public var ngAd:FlashAd;
		override public function createAdBox():void {
			addChild(ngAd = new FlashAd());
			ngAd.x = (stage.stageWidth - ngAd.width) / 2;
			ngAd.y = (stage.stageHeight - ngAd.height) / 2;
			//trace(ngAd.width, ngAd.height); // 310.8 293.65
		}
		override protected function destroy():void {
			super.destroy();
			if(ngAd != null) removeChild(ngAd);
			ngAd = null;
		}
	}

}