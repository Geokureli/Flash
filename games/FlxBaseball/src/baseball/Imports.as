package baseball {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import krakel.audio.SoundManager;
	import krakel.helpers.BitmapHelper;
	/**
	 * ...
	 * @author George
	 */
	public class Imports {
		
		[Embed(source = "../../res/levels/level_tmottbg.xml", mimeType = "application/octet-stream")] static private var TMOTTBG_LEVEL:Class;
		
		[Embed(source = "../../res/audio/songs/tmottbg.mp3")] static private const TMOTTBG:Class;
		[Embed(source="../../res/sprites/scalerButton.png")]static private const BTN_TEMPLATE:Class;
		
		static public var BUTTON:BitmapData;
		
		static private const songs:Object = { };
		static private const levels:Object = { };
		static private const buttons:Object = { };
		
		{
			songs["tmottbg"] = TMOTTBG;
			levels["tmottbg"] = new XML(new TMOTTBG_LEVEL());
			BUTTON = new BTN_TEMPLATE().bitmapData;
		}
		static public function getLevel(name:String):XML {
			if (name == null)
				return <level bpm="120" speed="10" offset="0" meter="4"/>;
			return levels[name];
		}
		static public function getSong(name:String):Class { return songs[name]; }
		static public function getButtonGraphic(width:int, height:int):BitmapData {
			var id:String = width + ',' + height;
			if (id in buttons) return buttons[id];
			var graphic:BitmapData = new BitmapData(width * 4, height);
			buttons[id] = graphic;
			var srcRect:Rectangle = BUTTON.rect.clone();
			var dest:Rectangle = graphic.rect.clone();
			
			srcRect.width *= .25;
			dest.width *= .25;
			for (var i:int = 0; i < 4; i++) {
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