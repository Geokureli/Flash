package baseball.scenes {
	import baseball.art.obstacles.Bomb;
	import baseball.art.RhythmBlit;
	import baseball.beat.BeatKeeper;
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
			BeatKeeper.beatsPerMinute = 80;
			RhythmBlit.SCROLL = -15;
			level = <level bpm="120" speed="10"/>;
		}
		override protected function init(e:Event):void {
			for (var i:int = 0; i < 10; i++)
				addRandomObstacle();
			super.init(e);
		}
		override public function update():void {
			bombTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / (Bomb.SPEED + RhythmBlit.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / RhythmBlit.SCROLL / stage.frameRate;
			
			super.update();
			BeatKeeper.beatsPerMinute += 2 / stage.frameRate;
			if (beatCount-BeatKeeper.beat < 10) {
				addRandomObstacle();
			}
		}
		private function addRandomObstacle():XML {
			var name:String = randomName;
			var node:XML = <{name}>{beatCount}</{name}>
			level.appendChild(node);
			beatCount++;
			return node;
		}
		private function get randomName():String {
			 return TYPES[Random.randomIndex(TYPES)];
		}
		override protected function reset():void {
			super.reset();
			BeatKeeper.beatsPerMinute = 80;
			RhythmBlit.SCROLL = -15;
		}
	}

}