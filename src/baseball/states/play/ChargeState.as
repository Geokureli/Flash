package baseball.states.play {
	import baseball.art.Obstacle;
	import krakel.ads.AdBox;
	import krakel.beat.BeatKeeper;
	import krakel.helpers.Random;
	import krakel.KrkSound;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author George
	 */
	public class ChargeState extends GameState {
		
		[Embed(source="../../../../res/baseball/audio/sfx/onBeat.mp3")] static private const ON_BEAT:Class;
		[Embed(source="../../../../res/baseball/audio/sfx/offBeat.mp3")] static private const OFF_BEAT:Class;
		
		// ---
		[Embed(source="C:/Windows/Fonts/StarPerv.ttf", fontFamily="StarPerv", embedAsCFF="false")] 	public	var	FONT_STAR_PERV:String;
		
		// --- --- --- --- --- NOTE SAMPLES --- --- --- --- ---
		[Embed(source="../../../../res/baseball/audio/sfx/notes/F5.mp3")]	static private const  F:Class;
		//[Embed(source="../../../../res/baseball/audio/sfx/notes/F#5.mp3")]	static private const _F:Class;
		[Embed(source="../../../../res/baseball/audio/sfx/notes/G5.mp3")]	static private const  G:Class;
		//[Embed(source="../../../../res/baseball/audio/sfx/notes/G#5.mp3")]	static private const _G:Class;
		[Embed(source="../../../../res/baseball/audio/sfx/notes/A5.mp3")]	static private const  A:Class;
		[Embed(source="../../../../res/baseball/audio/sfx/notes/A#5.mp3")]	static private const _A:Class;
		//[Embed(source="../../../../res/baseball/audio/sfx/notes/B5.mp3")]	static private const  B:Class;
		//[Embed(source="../../../../res/baseball/audio/sfx/notes/C6.mp3")]	static private const  C:Class;
		static private const notes:Object = { F:new KrkSound().embed(F), G:new KrkSound().embed(G), A:new KrkSound().embed(A), _A:new KrkSound().embed(_A) };
		static public const TYPES:Array = ["bomb", "block", "rock", "gap"];
		
		static public var farthest:int = 0;
		
		public var txt_score:FlxText,
					txt_hiScore:FlxText;
		
		private var beatCount:int;
		
		override public function create():void {
			level = <level id="charge" bpm="80" speed="15" meter="4"><assets/></level>;
			super.create();
			beatCount = 0;
			
			for (var i:int = 0; i < 10; i++)
				addRandomObstacle();
				
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
		}
		override protected function addUI():void {
			super.addUI();
			
			UI.add(txt_score = new FlxText(150, 10, 50, '0').setFormat("StarPerv", 24));
			UI.add(txt_hiScore = new FlxText(400, 10, 50, farthest.toString()).setFormat("StarPerv", 24));
			
			//outs.visible = false;
		}
		override protected function setIntroMetronome():void {
			//super();
			
			BeatKeeper.setMetronome([
				notes._A, null,
				notes.F, null,
				notes.G, null,
				notes.A, null
			]);
		}
		
		override protected function onZero(beat:Number):void {
			super.onZero(beat);
			message = "charge";
		}
		
		override public function update():void {
			super.update();
			
			if (beatCount-BeatKeeper.beat < 10)
				addRandomObstacle();
			if (BeatKeeper.beat > 0)
				txt_score.text = int(BeatKeeper.beat).toString();
		}
		
		override protected function updateMain():void {
			super.updateMain();
			BeatKeeper.beatsPerMinute += 2 / FlxG.framerate;
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
		}
		
		private function addRandomObstacle():void {
			var name:String = randomName;
			var node:XML = <{name} beat={beatCount}/>;
			//trace(level.assets[0]);
			level.assets[0].appendChild(node);
			beatCount++;
		}
		
		private function get randomName():String {
			return TYPES[Random.index(TYPES)];
		}
		override protected function out():void {
			AdBox.submitScore("charge", BeatKeeper.beat);
			super.out();
		}
		override protected function reset(timer:FlxTimer = null):void {
			if (int(BeatKeeper.beat) > farthest) {
				farthest = int(BeatKeeper.beat);
				txt_hiScore.text = farthest.toString();
			}
			BeatKeeper.beatsPerMinute = level.@bpm;
			super.reset(timer);
			//outs.value--;
		}
		
		override protected function get topUI():Array {
			return super.topUI.concat(txt_hiScore, txt_score);
		}
		
		override public function destroy():void {
			super.destroy();
			
		}
		
	}

}