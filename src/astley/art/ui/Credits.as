package astley.art.ui {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author George
	 */
	public class Credits extends FlxGroup {
		
		[Embed(source = "../../../../res/astley/levels/maps/levels/Credits.xml", mimeType = "application/octet-stream")] static private const CREDIT_DATA:Class;
		
		static public const CREDIT_START_TIME:Number = 5;
		static public const CREDIT_DELAY_TIME:Number = 1;
		
		private var _data:XML;
		private var _layers:XMLList;
		private var _currentIndex:int;
		
		public function Credits() {
			super(0);
			
			_data = new XML(new (Credits.CREDIT_DATA)());
			
			_layers = _data.layer;
			_currentIndex = 1;
			
			add(new XMLGroup(_layers.(@name.toString() == "static")[0]));
			
			new FlxTimer().start(CREDIT_START_TIME, 1, startNext);
		}
		
		private function startNext(timer:FlxTimer):void {
			var data:XMLList = _layers.(@name.toString() == "credits" + _currentIndex);
			
			if (data.length() == 0) {
				
				onCreditsEnd();
				return;
			}
			
			add(new TransitionGroup(data[0], onComplete));
			_currentIndex++;
		}
		
		private function onComplete(layer:FlxGroup):void {
			
			remove(layer);
			
			new FlxTimer().start(CREDIT_DELAY_TIME, 1, startNext);
		}
		
		private function onCreditsEnd():void {
			
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
	[Embed(source = "../../../../res/astley/graphics/text/txt_character_art.png")]		static public const characterArt:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_the_alex.png")]			static public const theAlex:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_kurelic.png")]			static public const kurelic:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_george.png")]				static public const george:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_programming.png")]		static public const programming:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_fart_sounds.png")]		static public const fartSounds:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_joe.png")]				static public const joe:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_alleruzzo.png")]			static public const alleruzzo:Class;
	
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
		characterArt:characterArt,
		theAlex:theAlex,
		kurelic:kurelic,
		george:george,
		programming:programming,
		fartSounds:fartSounds,
		joe:joe,
		alleruzzo:alleruzzo
	};
	
	//} endregion						ASSETS
	// =============================================================================
	
	public function XMLGroup(data:XML) {
		super(data.sprite.length());
		
		for each(var spriteData:XML in data.sprite) {
			
			add(create(spriteData));
		}
	}
	
	private function create(spriteData:XML):FlxSprite {
		var sprite:FlxSprite;
		
		var typeName:String = spriteData.@type.toString();
		var pos:Point = new Point(int(spriteData.@x), int(spriteData.@y));
		
		if (typeName in BUTTONS)
			sprite = new BUTTONS[typeName](pos.x, pos.y);
		else
			sprite = new FlxSprite(pos.x, pos.y, ASSETS[typeName]);
		
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
	
	public function TransitionGroup(data:XML, callback:Function) {
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