package astley.states {
	
	import astley.art.Cloud;
	import astley.art.DeathUI;
	import astley.art.Grass;
	import astley.art.Rick;
	import astley.art.ScoreText;
	import astley.art.Shrub;
	import astley.art.Tilemap;
	import astley.data.LevelData;
	import astley.data.RAInput;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import krakel.helpers.Random;
	import krakel.KrkSound;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author George
	 */
	public class RollinState extends BaseState {
		
		[Embed(source = "../../../res/astley/audio/music/nggyu_reversed_1_5x.mp3")] static private const SONG_REVERSED:Class;
		
		static public const MIN_RESET_TIME:Number = .5;
		static private const RESET_SCROLL_SPEED:int = 360;
		static private const RESET_ANTICIPATION:int = 120;
		
		protected var _hero:Rick;
		
		private var _scoreTxt:ScoreText;
		private var _introUI:IntroUI;
		private var _deathUI:DeathUI;
		private var _songReversed:KrkSound;
		
		private var _score:int;
		private var _running:Boolean;
		private var _isGameOver:Boolean;
		private var _isResetting:Boolean;
		
		override public function create():void {
			super.create();
			
			//FlxG.visualDebug = true;
			_songReversed = new KrkSound().embed(SONG_REVERSED);
			
			_isResetting = false;
			_isGameOver = false;
			_running = false;
			alive = false;
			
			FlxG.flash(0, .25, onFlashEnd, true);
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			
			_hero = new Rick(32, 64);
			
			//var buffer:int = (levelSize - Tilemap.PIPE_START) % Tilemap.PIPE_INTERVAL;
			//FlxG.camera.bounds = new FlxRect(0, 0, LevelData.TILE_SIZE * (Tilemap.PIPE_START + Tilemap.PIPE_INTERVAL + 2) + buffer, FlxG.height);
			
			setCameraFollow(_hero);
		}
		
		override protected function addMG():void {
			super.addMG();
			
			add(_introUI = new IntroUI());
			add(_hero);
			add(_deathUI = new DeathUI()).visible = false;
			_deathUI.onTimeOut = showEndScreen;
		}
		
		override protected function addFG():void {
			super.addFG();
			
			add(_scoreTxt = new ScoreText(0, 32, true));
			_scoreTxt.offset.x = -(FlxG.width - _scoreTxt.width) / 2 + _hero.x;
			_scoreTxt.visible = false;
			
		}
		
		private function onFlashEnd():void {
			
			alive = true;
			RAInput.enabled = true;
		}
		
		override public function update():void {
			super.update();
			
			_scoreTxt.x = _hero.x;
			score = Tilemap.getScore(_hero.x);
			
			if (_running) {
				
				if (checkHit())
					_hero.kill();
				
				if(!_hero.alive)
					onPlayerDie();
				
			} else {
				
				checkHit();
				
				if (_isGameOver && !_isResetting) {
					
					_deathUI.x = _hero.x;
					
					//if (_hero.isTouching(FlxObject.DOWN))
						//_hero.drag.x = 200
				}
				
				if (RAInput.instance.isButtonDown){
					if (_isGameOver && _deathUI.canRestart)
						startResetTransition();
					else if (!_isGameOver)
						onStart();
				}
				
				if (_hero.x > FlxG.camera.scroll.x && !_hero.onScreen(FlxG.camera))
					resetGame();
			}
		}
		
		private function checkHit():Boolean {
			
			if (FlxG.collide(_map, _ground)) return true;
			if (FlxG.collide(_map, _hero)) return true;
			return false;
		}
		
		override protected function onStart():void {
			super.onStart()
			
			_scoreTxt.visible = true;
			_hero.start();
			_running = true;
		}
		
		protected function onPlayerDie():void {
			_running = false;
			_isGameOver = true;
			_deathUI.visible = true;
			_hero.canFart = false;
			RAInput.enabled = false;
			_deathUI.startTransition(score, onEndTransitionComplete);
			_deathUI.x = _hero.x;
			_scoreTxt.visible = false;
			
			//_gameUI.visible = true;
			_song.stop();
		}
		
		private function onEndTransitionComplete():void {
			
			RAInput.enabled = true;
		}
		
		
		private function startResetTransition():void {
			
			_deathUI.killTimer();
			_isResetting = true;
			RAInput.enabled = false;
			FlxG.camera.target = null;
			// --- EXTEND CAM RANGE FOR TWEEN
			FlxG.camera.bounds.x = -FlxG.camera.bounds.width;
			FlxG.camera.bounds.width *= 2;
			
			var panAmount:int = RESET_ANTICIPATION;
			var duration:Number;
			if (score < 1) {
				
				panAmount = (_deathUI.x + _deathUI.width - FlxG.camera.scroll.x) / 2;
				TweenMax.to(
					_deathUI,
					panAmount * Math.PI / RESET_SCROLL_SPEED / 4,
					{
						x: '-' + panAmount,// --- RELATIVE
						ease:Sine.easeOut,
						onComplete:resetGame
					}
				);
			}
			
			duration = (panAmount * 4  + FlxG.camera.scroll.x) / RESET_SCROLL_SPEED;
			TweenMax.to (
				FlxG.camera.scroll,
				duration,
				{
					bezier:[
						{ x:FlxG.camera.scroll.x + panAmount },
						{ x: -RESET_ANTICIPATION },
						{ x:0 }
					],
					ease:Linear.easeNone,
					onComplete:onResetComplete
				}
			);
			
			_songReversed.position = _songReversed.getPosition(_songReversed.duration - duration);
			_songReversed.play();
		}
		
		public function startResetTweenBack():void {
			
			TweenMax.to(FlxG.camera.scroll, FlxG.camera.scroll.x / RESET_SCROLL_SPEED, { x:0, ease:Linear.easeNone, onComplete:finishResetTween } );
		}
		
		public function finishResetTween():void {
			
			var panAmount:int = RESET_ANTICIPATION;
			var duration:Number = panAmount * Math.PI / RESET_SCROLL_SPEED / 2;
			TweenMax.to(FlxG.camera.scroll, duration, { x:-panAmount, yoyo:true, repeat:1, ease:Sine.easeOut, onComplete:onResetComplete } );
		}
		
		private function onResetComplete():void {
			
			RAInput.enabled = true;
			FlxG.camera.target = _hero;
			_isResetting = false;
			FlxG.camera.bounds.x = 0;
			FlxG.camera.bounds.width *= .5;
		}
		
		protected function resetGame():void {
			
			_deathUI.visible = false;
			//_introUI.visible = true;
			_hero.moves = false;
			_hero.reset(0, 0);// --- POSITION SET INTERNALLY
			_isGameOver = false;
			_hero.canFart = true;
		}
		
		private function showEndScreen():void {
			_deathUI.killTimer();
		}
		
		private function get score():int { return _score; }
		private function set score(value:int):void {
			
			if (_score == value) return;
			
			_score = value;
			_scoreTxt.text = value.toString();
		}
	}
}

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;

class IntroUI extends FlxGroup {
	
	
	[Embed(source = "../../../res/astley/graphics/get_ready.png")] static private const GET_READY:Class;
	[Embed(source = "../../../res/astley/graphics/press_or_click.png")] static private const INSTRUCTIONS:Class;
	
	private var _instructions:FlxSprite;
	private var _getReady:FlxSprite;
	
	public function IntroUI() {
		super(2);
		
		add(centerX(_instructions = new FlxSprite(0, 160, INSTRUCTIONS)));
		//add(centerX(_instructions = new KrkText(0, 128, 150, "Press any key or click to fart")));
		//(_instructions as FlxText).setFormat("NES", 8, 0xFFFFFF, "center");
		add(centerX(_getReady = new FlxSprite(0, 32, GET_READY)));
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
}