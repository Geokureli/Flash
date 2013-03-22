package baseball.scenes {
	import baseball.art.obstacles.Bomb;
	import baseball.art.Obstacle;
	import relic.beat.BeatKeeper;
	import baseball.data.events.BeatEvent;
	import flash.events.Event;
	import relic.art.Scene;
	import relic.audio.SoundManager;
	import relic.data.Global;
	import relic.data.helpers.Random;
	
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
		override protected function setLevelProperties():void {
			super.setLevelProperties();
			level = <level bpm="80" speed="15"><assets/></level>;
		}
		override protected function init(e:Event):void {
			for (var i:int = 0; i < 10; i++)
				addRandomObstacle();
			super.init(e);
		}
		private function playCharge():void {
			BeatKeeper.setMetronome([
				"A#", null, "F", null, "G", null, "A", null,
				"A#", null, "F", null, "G", null, "A", null,
				"B", null, "F#", null, "G#", null, "A#", null,
				"B", null, "F#", null, "G#", null, "A#", null,
				"C", null, "G", null, "A", null, "B", null
			], .25);
		}
		private function onBeat(e:BeatEvent):void {
			SoundManager.play("onBeat");
		}
		override protected function mainUpdate():void {
			bombTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / (Bomb.SPEED + Obstacle.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / Obstacle.SCROLL / stage.frameRate;
			
			super.mainUpdate();
			BeatKeeper.beatsPerMinute += 2 / stage.frameRate;
			
			//if (beatCount >= -.25) playCharge();
			
			if (beatCount-BeatKeeper.beat < 10) {
				addRandomObstacle();
			}
		}
		private function addRandomObstacle():XML {
			var name:String = randomName;
			var node:XML = <{name} beat={beatCount}/>
			level.assets[0].appendChild(node);
			beatCount++;
			return node;
		}
		private function get randomName():String {
			 return TYPES[Random.randomIndex(TYPES)];
		}
		override protected function reset():void {
			super.reset();
			trace(BeatKeeper.beatsPerMinute, BeatKeeper.beat)
			BeatKeeper.beatsPerMinute = Number(level.@bpm);
			Obstacle.SCROLL = -Number(level.@speed);
		}
	}

}