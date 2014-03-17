package astley.art {
	/**
	 * ...
	 * @author George
	 */
	import astley.art.ScoreBoard;
	import astley.art.ScoreText;
	import astley.data.Prize;
	import astley.states.ReplayState;
	import astley.states.RollinState;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import krakel.KrkNest;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;

	public class DeathUI extends KrkNest {
		
		[Embed(source = "../../../res/astley/graphics/game_over.png")] static private const GAME_OVER2:Class;
		[Embed(source = "../../../res/astley/graphics/give_up.png")] static private const GIVE_UP2:Class;
		[Embed(source = "../../../res/astley/graphics/pres_any_key.png")] static private const RETRY:Class;
		
		private var _gameOver:FlxSprite;
		private var _giveUp:FlxSprite;
		private var _retry:FlxSprite;
		private var _timerTxt:ScoreText;
		private var _board:ScoreBoard;
		private var _blinkTimer:FlxTimer;
		private var _timer:FlxTimer;
		private var _callback:Function;
		
		public var width:int;
		public var height:int;
		public var onTimeOut:Function;
		public var canRestart:Boolean;
		
		public function DeathUI() {
			super(2);
			
			add(_gameOver = new FlxSprite(0, 0, GAME_OVER2));
			add(_giveUp = new FlxSprite(16, 0, GIVE_UP2));
			add(_board = new ScoreBoard());
			add(_timerTxt = new ScoreText(48, 176, true));
			add(_retry = new FlxSprite(15, 196, RETRY));
			
			_timer = new FlxTimer();
			_blinkTimer = new FlxTimer();
			
			width = _board._x + _board.width;
			height = _board.height;
			_board.x = -12;
		}
		
		public function startTransition(score:int, callback:Function):void {
			
			_callback = callback;
			canRestart = false;
			_board.score = 0;
			_board.setMedal(Prize.getPrize(score));
			
			_gameOver.y = -_gameOver.height;
			_giveUp.y = -_giveUp.height;
			_board.y = -_board.height;
			_timerTxt.visible = false;
			_retry.visible = false;
			TweenMax.to(_board, .75, { y:70, ease:Back.easeOut, onComplete:onBoardIn, onCompleteParams:[score] } );
		}
		
		public function startTransitionOut():void {
			TweenMax.allTo([_board, _gameOver], RollinState.MIN_RESET_TIME, { y:'-' + (_board.height + _board.y), ease:Back.easeIn }, .25 );
		}
		
		private function onBoardIn(score:int):void {
			_gameOver.y = _board.y;
			_giveUp.y = _board.y + _board.height - _giveUp.height;
			
			TweenMax.to(_gameOver, .5, { y:'-' + _gameOver.height, ease:Back.easeOut, onComplete:_callback } );
			_callback = null;
			_board.setData(score, onScoreSet);
		}
		
		private function onScoreSet():void {
			
			TweenMax.to(_giveUp, .5, { y:'+' + _giveUp.height, ease:Back.easeOut, onComplete:startTimer } );
		}
		
		private function startTimer():void {
			
			canRestart = true;
			_retry.visible = true;
			_timerTxt.visible = true;
			_timerTxt.text = "10";
			_timer.start(1, 11, updateTimerTxt);
			
		}
		
		private function updateTimerTxt(timer:FlxTimer):void {
			
			var count:int = _timer.loopsLeft-1;
			_timerTxt.text = count.toString();
			if (count == 3)
				_blinkTimer.start(.1, 10 * 4, swapTextColor);
			
			else if (count == -1) {
				
				_timerTxt.text = '0';
				onGiveUp();
			}
		}
		
		public function killTimer():void {
			
			_timer.stop();
			_blinkTimer.stop();
		}
		
		private function swapTextColor(timer:FlxTimer):void {
			
			_timerTxt.color ^= 0xFFFF;
		}
		
		private function onGiveUp():void {
			
			FlxG.fade(0xffff0000, 2, onFadeOut, true);
		}
		
		private function onFadeOut():void {
			
			FlxG.switchState(new ReplayState());
		}
	}
}