package astley.states {
	import astley.data.BestSave;
	import astley.data.LevelData;
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
			if (e.success) {
				
				API.logCustomEvent("The Newgrounds API connected succesfully! You can now use the API features.");
				
				if (API.getMedal("Topping the charts").unlocked) {
					
					if (API.username.toLowerCase() == "geokureli")
						API.logCustomEvent("HIGHSCORE: 131");
					else {
						
						BestSave.best = 131;
						API.postScore(LevelData.SCORE_BOARD_ID, 131);
					}
				}
			}
			else
				API.logCustomEvent("Unable to connect to the Newgrounds API. The error was: " + e.error);
			canExit = true;
		}
	}
}