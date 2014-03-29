package astley.art.ui {
	import astley.data.BestSave;
	import astley.data.Prize;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import krakel.helpers.BitmapHelper;
	import krakel.KrkNest;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/**
	 * ...
	 * @author George
	 */
	public class ScoreBoard extends KrkNest {
		
		[Embed(source = "../../../../res/astley/graphics/board.png")] static private const BOARD_TEMPLATE:Class;
		[Embed(source = "../../../../res/astley/graphics/text/txt_score.png")] static private const TXT_SCORE:Class;
		[Embed(source = "../../../../res/astley/graphics/text/txt_best.png")] static private const TXT_BEST:Class;
		[Embed(source = "../../../../res/astley/graphics/text/txt_medal.png")] static private const TXT_MEDAL:Class;
		[Embed(source = "../../../../res/astley/graphics/text/txt_new.png")] static private const TXT_NEW:Class;
		[Embed(source = "../../../../res/astley/graphics/medals.png")] static private const MEDALS:Class;
		
		
		public var width:int;
		public var height:int;
		
		private var _medal:FlxSprite;
		private var _scoreTxt:ScoreText;
		private var _bestTxt:ScoreText;
		private var _new:FlxSprite;
		private var _scoreSetCallback:Function;
		
		public function ScoreBoard(width:int = 128, height:int = 80) {
			super(0, 0);
			
			this.width = width;
			this.height = height;
			
			_score = 0;
			_best = BestSave.best;
			
			// --- CREATE BACK BOARD
			var board:FlxSprite = new FlxSprite();
			board.makeGraphic(width, height, 0, true);
			BitmapHelper.apply9GridTo(
				new BOARD_TEMPLATE().bitmapData,
				board.pixels,
				new Rectangle(5, 7, 1, 1)
			);
			board.pixels = board.pixels;// <-- redraw
			add(board);
			
			// --- TEXT
			add(new FlxSprite(24, 12, TXT_MEDAL));
			add(new FlxSprite(90, 12, TXT_SCORE));
			add(_scoreTxt = new ScoreText(90, 20));
			_scoreTxt.align = FlxBitmapFont.ALIGN_RIGHT;
			add(_new = new FlxSprite(94-19, 48-1, TXT_NEW));
			add(new FlxSprite(94, 48, TXT_BEST));
			add(_bestTxt = new ScoreText(90, 56));
			_bestTxt.align = FlxBitmapFont.ALIGN_RIGHT;
			_bestTxt.text = _best.toString();
			
			// --- MEDAL
			add(_medal = new FlxSprite(24, 32));
			_medal.loadGraphic(MEDALS, true, false, 24);
			_medal.addAnimation(Prize.NONE, [0]);
			_medal.addAnimation(Prize.BRONZE, [1]);
			_medal.addAnimation(Prize.SILVER, [2]);
			_medal.addAnimation(Prize.GOLD, [3]);
			_medal.addAnimation(Prize.PLATINUM, [4]);
		}
		
		public function setMedal(prize:String):void {
			
			_new.visible = false;
			_medal.play(prize);
		}
		
		public function setData(score:int, callback:Function):void {
			var duration:Number = score / 10;
			
			_scoreSetCallback = callback;
			
			TweenMax.to(this, duration, { score:score, ease:Linear.easeNone, onComplete:onRollupComplete } ); 
		}
		
		private function onRollupComplete():void {
			if (_new.visible) 
				BestSave.best = _best;
			
			if (_scoreSetCallback != null) {
				
				_scoreSetCallback();
				_scoreSetCallback = null;
			}
		}
		
		private var _score:int;
		public function get score():int { return _score; }
		public function set score(value:int):void {
			_score = value;
			
			_scoreTxt.text = value.toString();
			if (value > best) {
				
				best = value;
				_new.visible = true;
			}
			
		}
		
		private var _best:int;
		public function get best():int { return _best; }
		public function set best(value:int):void {
			_best = value;
			
			_bestTxt.text = value.toString();
		}
	}

}