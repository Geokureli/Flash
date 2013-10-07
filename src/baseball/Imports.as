package baseball {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//import krakel.audio.SoundManager;
	import krakel.helpers.BitmapHelper;
	import krakel.KrkSound;
	/**
	 * ...
	 * @author George
	 */
	public class Imports {
		
		[Embed(source = "../../res/baseball/levels/level_tmottbg.xml", mimeType = "application/octet-stream")] static private var TMOTTBG_LEVEL:Class;
		[Embed(source = "../../res/baseball/levels/level_test.xml", mimeType = "application/octet-stream")] static private var TEST_LEVEL:Class;
		
		[Embed(source = "../../res/baseball/audio/songs/tmottbg.mp3")] static private const TMOTTBG:Class;
		[Embed(source = "../../res/baseball/audio/songs/menu_theme.mp3")] static private const MENU_THEME:Class;
		[Embed(source = "../../res/baseball/audio/sfx/onBeat.mp3")] static private const TICK_EMBED:Class;
		[Embed(source = "../../res/baseball/audio/sfx/offBeat.mp3")] static private const TOCK_EMBED:Class;
		
		[Embed(source = "../../res/baseball/sprites/scalerButton.png")] static private const BTN_TEMPLATE:Class;
		
		static public var BUTTON:BitmapData;
		
		static private const songs:Object = { };
		static private const levels:Object = { };
		static private const buttons:Object = { };
		
		static public var TICK:KrkSound, TOCK:KrkSound;
		
		{	// --- STATIC INIT
			
			//SoundManager.Add("menu", MENU_THEME, 1, true);
			
			TICK = new KrkSound().embed(TICK_EMBED);
			TOCK = new KrkSound().embed(TOCK_EMBED);
			songs["menu"] = MENU_THEME;
			songs["tmottbg"] = TMOTTBG;
			levels["tmottbg"] = new XML(new TMOTTBG_LEVEL());
			levels["test"] = new XML(new TEST_LEVEL());
			BUTTON = new BTN_TEMPLATE().bitmapData;
		}
		static public function getLevel(name:String):XML {
			if (name == null)
				return <level bpm="120" speed="10" offset="0" meter="4"/>;
			return levels[name];
		}
		static public function getSong(name:String):Class { return songs[name]; }
		static public function getButtonGraphic(width:int, height:int, frames:int = 4):BitmapData {
			var id:String = width + ',' + height;
			if (id in buttons) return buttons[id];
			var graphic:BitmapData = new BitmapData(width * frames, height);
			buttons[id] = graphic;
			var srcRect:Rectangle = BUTTON.rect.clone();
			var dest:Rectangle = graphic.rect.clone();
			
			srcRect.width *= 1/4;
			dest.width *= 1/frames;
			for (var i:int = 0; i < frames; i++) {
				BitmapHelper.apply9GridTo(
					BUTTON,
					graphic,
					new Rectangle(int(BUTTON.width / 2 / 4), int(BUTTON.height / 2), 1, 1),
					srcRect,
					dest
				);
				srcRect.x = srcRect.right;
				dest.x = dest.right;
			}
			return graphic;
		}
		
	}

}