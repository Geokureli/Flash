package astley.states {
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author George
	 */
	public class Preloader extends FlxPreloader {
		
		public function Preloader() {
			className = "astley.Main";
			super();
			API.addEventListener(APIEvent.API_CONNECTED, onAPIConnected);
			API.connect(stage, "36308:18pQMkMo", "jTJxUeSYswT2ZFHh1D503723rsErDEcr");
			canExit = false;
		}
		
		private function onAPIConnected(e:APIEvent):void {
			if(e.success)
				API.logCustomEvent("The Newgrounds API connected succesfully! You can now use the API features.");
			else
				API.logCustomEvent("Unable to connect to the Newgrounds API. The error was: " + e.error);
			canExit = true;
		}
	}
}