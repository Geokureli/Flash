package krakel.ads {
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	/**
	 * ...
	 * @author George
	 */
	public class KongBox extends AdBox {
		public var kongregate:*;
		public function KongBox() {
			super();
			
		}
		override protected function onAdded(e:Event):void {
			super.onAdded(e);
			// Pull the API path from the FlashVars
			//var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
			
			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = //paramObj.kongregate_api_path || 
			  "http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
			
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			this.addChild(loader);
		}
		// This function is called when loading is complete
		private function loadComplete(event:Event):void
		{
			// Save Kongregate API reference
			kongregate = event.target.content;
			
			// Connect to the back-end
			kongregate.services.connect();
			
			// You can now access the API via:
			//kongregate.services
			// kongregate.user
			// kongregate.scores
			// kongregate.stats
			// etc...
		}
		
		override public function preloaderAd(onComplete:Function):void {
			if (onComplete != null) onComplete();
		}
		
		override public function sendVar(target:String, value:int):void {
			kongregate.stats.submit(target, value);
		}
	}

}