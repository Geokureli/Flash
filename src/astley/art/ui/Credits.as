package astley.art.ui {
	import astley.data.LevelData;
	import astley.data.Prize;
	import astley.data.RAInput;
	import astley.Main;
	import astley.states.RollinState;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.Score;
	import krakel.helpers.Random;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author George
	 */
	public class Credits extends FlxGroup {
		
		[Embed(
			source = "../../../../res/astley/levels/maps/levels/Credits.xml",
			mimeType = "application/octet-stream")] static private const CREDIT_DATA:Class;
		[Embed(source = "../../../../res/astley/graphics/text/press_any_key.png")] static private const TRY_AGAIN:Class;
		
		static public const CREDIT_START_TIME:Number = 5;
		static public const CREDIT_DELAY_TIME:Number = 1;
		
		private var _data:XML;
		private var _layers:XMLList;
		private var _currentIndex:int;
		private var _highScores:com.newgrounds.ScoreBoard;
		private var _mainCreditsOver:Boolean;
		private var _linksBob:TweenMax;
		private var _userNamePage:int;
		
		public function Credits() {
			super(0);
			
			_mainCreditsOver = false;
			_data = new XML(new (Credits.CREDIT_DATA)());
			
			if (API.connected) 
				parseHighScores();
			
			var staticLayer:XMLGroup = new XMLGroup(_data.layer.(@name.toString() == "static")[0])
			add(staticLayer);
			
			_linksBob = TweenMax.to(staticLayer.assets["links"], 120/107.12, { y:"-8", ease:Sine.easeInOut, repeat:-1, yoyo:true } );
		}
		
		private function parseHighScores():void {
			
			_highScores = API.getScoreBoard(LevelData.SCORE_BOARD_ID);
			_highScores.numResults = uint.MAX_VALUE;
			//API.logCustomEvent(_highScores.numResults.toString());
			_highScores.addEventListener(APIEvent.SCORES_LOADED, onScoresLoaded);
			_highScores.loadScores();
		}
		
		private function onScoresLoaded(e:APIEvent):void {
			_highScores.removeEventListener(APIEvent.SCORES_LOADED, onScoresLoaded);
			
			const X1:int = 8;
			const X2:int = 131;
			
			var allNames:XML = <scores/>;
			for each(var score:Score in _highScores.scores) {
				
				allNames.appendChild(<text x={ X1.toString() } text={ score.username.toString()  }/>);
				allNames.appendChild(<text x={ X2.toString() } text={ score.score.toString() }/>);
			}
			
			var creditsPage:int = 5;
			var y:int = 71;
			
			var leaderBoard:XML;
			var node:XML;
			var len:int = allNames.text.length();
			var username:String = API.username;
			if (FlxG.debug)
				username = "GeoKureli"
			
			for (var i:int = 0; i < len; i++) {
				
				if (i % 20 == 0) {
					
					leaderBoard = <layer name={"credits" + creditsPage} isHighScore="true"/>;
					_data.appendChild(leaderBoard);
					creditsPage++;
					y = 71
				}
				
				node = allNames.text[i];
				node.@y = y;
				leaderBoard.appendChild(node);
				if (node.@text.toString() == username)
					_userNamePage = creditsPage-1;
				
				i++;
				
				node = allNames.text[i];
				node.@y = y;
				leaderBoard.appendChild(node);
				
				y += 13;
			}
			
			_layers = _data.layer;
			_currentIndex = 1;
			new FlxTimer().start(CREDIT_START_TIME, 1, startNext);
		}
		
		private function startNext(timer:FlxTimer):void {
			var data:XMLList = _layers.(@name.toString() == "credits" + _currentIndex);
			
			if (data.length() == 0)
				return;
			
			if ("@isHighScore" in data[0] && !_mainCreditsOver)
				onCreditsEnd();
			
			if (_currentIndex == _userNamePage)
				Prize.unlockMedal(Prize.CREDIT_MEDAL);
			
			add(new TransitionGroup(data[0], onComplete));
			_currentIndex++;
		}
		
		private function onComplete(layer:FlxGroup):void {
			
			remove(layer);
			
			new FlxTimer().start(CREDIT_DELAY_TIME, 1, startNext);
		}
		
		private function onCreditsEnd():void {
			
			_mainCreditsOver = true;
			
			add(new TransitionGroup(_layers.(@name.toString() == "end")[0]));
			RAInput.enabled = true;
		}
		
		override public function update():void {
			
			if (RAInput.isButtonDown)
				FlxG.fade(Main.FADE_COLOR, Main.FADE_TIME, restartGame, true);
			
			super.update();
		}
		
		override public function destroy():void {
			super.destroy();
			
			_data = null;
			_layers = null;
			_highScores = null;
			_linksBob = null;
		}
		
		private function restartGame():void {
			
			_linksBob.kill();
			FlxG.switchState(new RollinState());
			
			RAInput.enabled = false;
		}
	}
}

import astley.art.ui.buttons.GKButton;
import astley.art.ui.buttons.MEHButton;
import astley.art.ui.buttons.RickButton;
import astley.art.ui.buttons.SongButton;
import com.greensock.easing.Strong;
import com.greensock.TweenMax;
import flash.geom.Point;
import org.flixel.FlxBasic;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxTimer;

class XMLGroup extends FlxGroup {
	
	// =============================================================================
	//{ region						ASSETS
	// =============================================================================
	
	[Embed(source = "../../../../res/astley/graphics/text/txt_thanks.png")]				static public const thanks:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_links.png")]				static public const links:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_based_on.png")]			static public const basedOn:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_flappy.png")]				static public const flappy:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_bird.png")]				static public const bird:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_dan.png")]				static public const dan:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_nguyen.png")]				static public const nguyen:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_matthew.png")]			static public const matthew:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_harris.png")]				static public const harris:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_original_concept.png")]	static public const originalConcept:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_music.png")]				static public const music:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_rick.png")]				static public const rick:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_astley.png")]				static public const astley:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_bg_tile_art.png")]		static public const bgTileArt:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_nintendo.png")]			static public const nintendo:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_loading_screen.png")]		static public const loadingScreen:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_flixel.png")]				static public const flixel:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_character_art.png")]		static public const characterArt:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_the_alex.png")]			static public const theAlex:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_kurelic.png")]			static public const kurelic:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_george.png")]				static public const george:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_programming.png")]		static public const programming:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_fart_sounds.png")]		static public const fartSounds:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_joe.png")]				static public const joe:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_alleruzzo.png")]			static public const alleruzzo:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_together_forever.png")]	static public const togetherForever:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_nggyu.png")]				static public const nggyu:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_slipping_away.png")]		static public const slippingAway:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_dont_say_goodbye.png")]	static public const dontSayGoodbye:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_written_produced.png")]	static public const writtenProduced:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_mike.png")]				static public const mike:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_stock.png")]				static public const stock:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_matt.png")]				static public const matt:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_aiken.png")]				static public const aiken:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_pete.png")]				static public const pete:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_waterman.png")]			static public const waterman:Class;
	[Embed(source = "../../../../res/astley/graphics/text/press_any_key.png")]			static public const press:Class;
	
	static private const BUTTONS:Object = {
		
		SongButton:SongButton,
		RickButton:RickButton,
		GKButton:GKButton,
		MEHButton:MEHButton
	}
	
	static private const ASSETS:Object = {
		
		thanks:thanks,
		links:links,
		basedOn:basedOn,
		flappy:flappy,
		bird:bird,
		dan:dan,
		nguyen:nguyen,
		matthew:matthew,
		harris:harris,
		originalConcept:originalConcept,
		music:music,
		rick:rick,
		astley:astley,
		bgTileArt:bgTileArt,
		nintendo:nintendo,
		loadingScreen:loadingScreen,
		flixel:flixel,
		characterArt:characterArt,
		theAlex:theAlex,
		kurelic:kurelic,
		george:george,
		programming:programming,
		fartSounds:fartSounds,
		joe:joe,
		alleruzzo:alleruzzo,
		togetherForever:togetherForever,
		nggyu:nggyu,
		slippingAway:slippingAway,
		dontSayGoodbye:dontSayGoodbye,
		writtenProduced:writtenProduced,
		mike:mike,
		stock:stock,
		matt:matt,
		aiken:aiken,
		pete:pete,
		waterman:waterman,
		press:press
	};
	
	//} endregion						ASSETS
	// =============================================================================
	
	public var assets:Object
	
	public function XMLGroup(data:XML) {
		super(data.sprite.length());
		
		assets = { };
		
		var sprite:FlxBasic;
		for each(var spriteData:XML in data.children()) {
			
			sprite = add(create(spriteData));
			
			if (spriteData.name().toString() != "text")
				assets[spriteData.@type.toString()] = sprite;
		}
	}
	
	private function create(spriteData:XML):FlxSprite {
		var sprite:FlxSprite;
		var pos:Point = new Point(int(spriteData.@x), int(spriteData.@y));
		
		if (spriteData.name().toString() == "text")
			
			sprite = new astley.art.ui.CreditText(pos.x, pos.y, spriteData.@text);
			
		else {
			
			var typeName:String = spriteData.@type.toString();
			
			if (typeName in BUTTONS)
				sprite = new BUTTONS[typeName](pos.x, pos.y);
			else
				sprite = new FlxSprite(pos.x, pos.y, ASSETS[typeName]);
		}
		
		sprite.scrollFactor.x = 0;
		sprite.scrollFactor.y = 0;
		
		return sprite;
	}
}

class TransitionGroup extends XMLGroup {
	
	
	static private const TRANSITION_TIME:Number = 2;
	static private const WAIT_TIME:Number = 2;
	static private const LATEST_STAGGER:Number = 2;
	
	private var _callback:Function;
	
	public function TransitionGroup(data:XML, callback:Function = null) {
		super(data);
		_callback = callback;
		
		startTransitionIn();
	}
	
	private function startTransitionIn():void {
		var delay:Number;
		
		var longestDelay:Number = 0;
		for each(var member:FlxSprite in members)
		{
			delay = member.y / FlxG.height * LATEST_STAGGER;
			if (delay > longestDelay)
				longestDelay = delay;
			
			TweenMax.from(member, TRANSITION_TIME, { x:FlxG.width + member.x, delay:delay, ease:Strong.easeOut } );
		}
		
		if(_callback != null)
			new FlxTimer().start(longestDelay + TRANSITION_TIME + WAIT_TIME, 1, endTransitionIn);
	}
	
	private function endTransitionIn(timer:FlxTimer):void {
		startTransitionOut();
	}
	
	private function startTransitionOut():void {
		
		var delay:Number;
		
		var longestDelay:Number = 0;
		for each(var member:FlxSprite in members)
		{
			delay = member.y / FlxG.height * LATEST_STAGGER;
			if (delay > longestDelay)
				longestDelay = delay;
			
			TweenMax.to(member, TRANSITION_TIME, { x:member.x - FlxG.width - member.width, delay:delay, ease:Strong.easeIn } );
		}
		
		new FlxTimer().start(longestDelay + TRANSITION_TIME, 1, endTransitionOut);
	}
	
	private function endTransitionOut(timer:FlxTimer):void {
		_callback(this);
	}
}