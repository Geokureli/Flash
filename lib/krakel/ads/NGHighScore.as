package krakel.ads {
	import com.newgrounds.API;
	import com.newgrounds.ScoreBoard;
	import flash.events.Event;
	/**
	 * ...
	 * @author George
	 */
	public class NGHighScore extends HighScore {
		
		public function NGHighScore(apiID:String, encryptionKey:String) {
			super();
		}
		override protected function onAdded(e:Event):void {
			super.onAdded(e);
		}
		override public function submit(value:int, args:Object = null):void {
			super.submit(value, args);
		}
		
		override public function unlockAchievement(name:String, args:Object = null):void {
			super.unlockAchievement(name, args);
			API.unlockMedal(name);
		}
	}

}