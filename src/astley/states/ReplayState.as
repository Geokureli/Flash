package astley.states {
	import astley.art.ReplayRick;
	import astley.art.Rick;
	import astley.art.RickLite;
	import astley.art.Tilemap;
	import astley.art.ui.Credits;
	import astley.data.Beat;
	import astley.data.Recordings;
	import krakel.helpers.Random;
	import krakel.KrkSound;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author George
	 */
	public class ReplayState extends BaseState {
		
		[Embed(source = "../../../res/astley/audio/music/credit_intro.mp3")] static private const SONG_INTRO:Class;
		[Embed(source = "../../../res/astley/audio/music/credit_loop.mp3")] static private const SONG_LOOP:Class;
		
		static public const CROSS_FADE_TIME:Number = .245;
		static public const BUFFER_TIME:Number = .02;
		
		static private const BUFFER:Number = 5;
		
		private var _finishedGhosts:FlxGroup;
		private var _ghosts:FlxGroup;
		private var _credits:Credits;
		
		private var _songIntro:KrkSound;
		private var _songLoop:KrkSound;
		private var _timerMusic:FlxTimer;
		
		override public function create():void {
			
			//Tilemap.addPipes = false;
			super.create();
			
			_songIntro = new KrkSound().loadEmbedded(SONG_INTRO) as KrkSound;
			_songLoop = new KrkSound().loadEmbedded(SONG_LOOP, true) as KrkSound;
			_timerMusic = new FlxTimer();
			
			add(_credits = new Credits());
			
			onStart();
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			
			FlxG.worldBounds.width = FlxG.width;
			_ghosts = new FlxGroup();
			_finishedGhosts = new FlxGroup();
		}
		
		override protected function addTileMap():void {
			add(_map = new Tilemap(true));
		}
		
		override protected function addFG():void {
			super.addFG();
			
			add(_ghosts);
			
			var shroud:FlxSprite;
			add(shroud = new FlxSprite());
			shroud.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			shroud.scrollFactor.x = 0;
			shroud.alpha = .5;
		}
		
		override protected function addMG():void {
			super.addMG();
			
			
			var frameSpeed:Number = Rick.SPEED * FlxG.elapsed;
			var maxFrame:int = (FlxG.width - RickLite.WIDTH - BUFFER - HERO_SPAWN_X) / frameSpeed + 1;
			var minFrame:int = (BUFFER - HERO_SPAWN_X) / frameSpeed;
			
			var replay:String;
			var ghost:ReplayRick;
			var longest:int = 0;
			var leadGhost:ReplayRick;
			var length:int;
			do {
				replay = Recordings.getReplay();
				if (replay != null) {
					ghost = new ReplayRick(HERO_SPAWN_X, 64, replay);
					_ghosts.add(ghost);
					ghost.playSounds = false;
					length = replay.split('\n').length;
					ghost.startTime = Random.between(minFrame, maxFrame);
					
					if (length > longest) {
						
						longest = length;
						leadGhost = ghost;
					}
				} else break;
			} while (replay != null);
			
			//leadGhost.playSounds = true;
			leadGhost.startTime = 0;
			setCameraFollow(leadGhost);
			//FlxG.worldBounds.width = leadGhost.x + leadGhost.width;
		}
		
		override protected function onStart():void {
			super.onStart();
			
			_songIntro.play();
			_timerMusic.start(_songIntro.duration - BUFFER_TIME, 1, playLoop)
			
			var ghost:ReplayRick;
			var count:int = 0;
			for each(ghost in _ghosts.members) {
				
				if (ghost != null && ghost.startTime >= 0) {
					
					count++;
					ghost.reset(0, 0);
					ghost.start();
				}
			}
		}
		
		private function playLoop(timer:FlxTimer):void {
			
			_songLoop.play();
		}
		
		override public function update():void {
			super.update();
			
			for each(var ghost:ReplayRick in _ghosts.members) {
				
				if (ghost != null) {
					if (ghost.startTime < 0){
						ghost.startTime++;
						if (ghost.startTime == 0)
							ghost.start();
					}
					
					if (ghost.replayFinished)
						_finishedGhosts.add(ghost);
				}
			}
			
			FlxG.collide(_finishedGhosts, _map, onGhostHit);
			FlxG.collide(_finishedGhosts, _ground);
		}
		
		override protected function updateWorldBounds():void {
			super.updateWorldBounds();
			
			FlxG.worldBounds.x = FlxG.camera.scroll.x;
		}
		
		private function onGhostHit(ghost:ReplayRick, map:Tilemap):void {
			
			ghost.kill();
		}
	}
}