package  {
	import krakel.ads.KongBox;
	/**
	 * ...
	 * @author George
	 */
	public class KongLoader extends Preloader {
		
		public function createAdBox():void {
			//_min = 10000;
			addChild(new KongBox());
		}
	}

}