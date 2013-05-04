package krakel.ads {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author George
	 */
	public class HighScore extends Sprite {
		
		static private var instance:HighScore;
		
		public function HighScore() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function submit(value:int, args:Object = null):void { }
		
		public function unlockAchievement(name:String, args:Object = null):void { }
		
		static public function submitScore(value:int, args:Object = null):void {
			instance.submit(value, args);
		}
		static public function unlockAchievement(name:String, args:Object = null):void {
			instance.unlockAchievement(name, args);
		}
	}

}