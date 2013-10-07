package  {
	import com.newgrounds.API;
	import com.newgrounds.components.FlashAd;
	import krakel.ads.AdBox;
	import krakel.ads.NGBox;
	import krakel.ads.NGHighScore;
	/**
	 * ...
	 * @author George
	 */
	public class NGPreloader extends Preloader {
		
		override public function createAdBox():void {
			var ngBox:NGBox;
			addChild(ngBox = new NGBox("30980:TXueN3Nj", "Vpq42rvizfHyY13jD9975YEPQZCmVX1L"));
			ngBox.setScoreTarget("Farthest Charge", "charge");
			
			//_min = 10000;
		}
		
	}

}