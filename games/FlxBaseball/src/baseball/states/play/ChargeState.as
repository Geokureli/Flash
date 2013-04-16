package baseball.states.play {
	import baseball.art.Obstacle;
	import krakel.beat.BeatKeeper;
	import krakel.helpers.Random;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class ChargeState extends GameState {
		
		[Embed(source="../../../../res/audio/sfx/onBeat.mp3")] static private const ON_BEAT:Class;
		[Embed(source="../../../../res/audio/sfx/offBeat.mp3")] static private const OFF_BEAT:Class;
		
		
		// --- --- --- --- --- NOTE SAMPLES --- --- --- --- ---
		[Embed(source="../../../../res/audio/sfx/notes/F5.mp3")]	static private const  F:Class;
		//[Embed(source="../../../../res/audio/sfx/notes/F#5.mp3")]	static private const _F:Class;
		[Embed(source="../../../../res/audio/sfx/notes/G5.mp3")]	static private const  G:Class;
		//[Embed(source="../../../../res/audio/sfx/notes/G#5.mp3")]	static private const _G:Class;
		[Embed(source="../../../../res/audio/sfx/notes/A5.mp3")]	static private const  A:Class;
		[Embed(source="../../../../res/audio/sfx/notes/A#5.mp3")]	static private const _A:Class;
		//[Embed(source="../../../../res/audio/sfx/notes/B5.mp3")]	static private const  B:Class;
		//[Embed(source="../../../../res/audio/sfx/notes/C6.mp3")]	static private const _C:Class;
		
		
		static public const TYPES:Array = ["bomb", "block", "rock", "gap"];
		
		private var beatCount:int;
		
		public function ChargeState() {
			super(<level bpm="80" speed="15" meter="4"><assets/></level>);
			
			beatCount = 0;
			
			for (var i:int = 0; i < 10; i++)
				addRandomObstacle();
				
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
			//var on:FlxSound = new FlxSound().loadEmbedded(ON_BEAT);
			//var off:FlxSound = new FlxSound().loadEmbedded(OFF_BEAT);
			BeatKeeper.setMetronome([
				new FlxSound().loadEmbedded(_A), null,
				new FlxSound().loadEmbedded( F), null,
				new FlxSound().loadEmbedded( G), null,
				new FlxSound().loadEmbedded( A), null
			]);
		}
		
		override public function update():void {
			super.update();
			
			if (beatCount-BeatKeeper.beat < 10)
				addRandomObstacle();
		}
		
		override protected function updateMain():void {
			super.updateMain();
			BeatKeeper.beatsPerMinute += 2 / FlxG.framerate;
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
		}
		
		private function addRandomObstacle():XML {
			var name:String = randomName;
			var node:XML = <{name} beat={beatCount}/>;
			//trace(level.assets[0]);
			level.assets[0].appendChild(node);
			beatCount++;
			return node;
		}
		private function get randomName():String {
			 return TYPES[Random.randomIndex(TYPES)];
		}
	}

}