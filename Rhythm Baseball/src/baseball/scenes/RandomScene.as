package baseball.scenes {
	import baseball.art.obstacles.Bomb;
	import baseball.art.Obstacle;
	import baseball.beat.BeatKeeper;
	import flash.events.Event;
	import relic.art.Scene;
	import relic.audio.SoundManager;
	import relic.data.Global;
	import relic.data.Random;
	
	/**
	 * ...
	 * @author George
	 */
	public class RandomScene extends GameScene {
		static public const TYPES:Array = ["ball", "block", "rock", "gap"];
		
		private var beatCount:int;
		private var hasSong:Boolean;
		
		public function RandomScene() { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			beatCount = 0;
		}
		override protected function setLevelProperties():void {
			super.setLevelProperties();
			hasSong = false;
			if ("userLevel" in Global.VARS) {
				level = Global.VARS.userLevel;
			} else {
				level = <level bpm="80" speed="15"/>;
			}
			if ("song" in Global.VARS) {
				song = Global.VARS.song;
				hasSong = true;
			}
		}
		override protected function init(e:Event):void {
			for (var i:int = 0; i < 10; i++)
				addRandomObstacle();
			super.init(e);
		}
		override public function update():void {
			bombTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / (Bomb.SPEED + Obstacle.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / Obstacle.SCROLL / stage.frameRate;
			
			super.update();
			if(!hasSong)
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
			BeatKeeper.beatsPerMinute = Number(level.@bpm);
			Obstacle.SCROLL = -Number(level.@speed);
		}
	}

}