package baseball.scenes {
	import flash.events.Event;
	import relic.art.Scene;
	import relic.data.Random;
	
	/**
	 * ...
	 * @author George
	 */
	public class RandomScene extends GameScene {
		static public const TYPES:Array = ["ball", "block", "rock", "gap"];
		
		private var beatCount:int;
		
		public function RandomScene() { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			beatCount = 0;
		}
		override protected function init(e:Event = null):void {
			level = <level bpm="120" speed="10"/>;
			for (var i:int = 0; i < 10; i++) {
				addRandomObstacle();
			}
			super.init(e);
		}
		
		private function addRandomObstacle():void {
			var name:String = randomName;
			level.appendChild(<{name}>{beatCount}</{name}>);
			beatCount++;
		}
		private function get randomName():String {
			 return TYPES[Random.randomIndex[TYPES]];
		}
	}

}