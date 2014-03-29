package astley.data {
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author George
	 */
	public class BestSave {
		
		static public const SAVE_ID:String = "GRA_Best";
		static public const FRESH_START:Boolean = false;
		static public const PRETEND_ZERO:Boolean = false;
		
		static private const SAVE_FILE:FlxSave = new FlxSave();
		
		static private var _best:int;
		
		static private function STATIC_INIT():void {
			
			SAVE_FILE.bind(SAVE_ID);
			
			_best = 0;
			if ("best" in SAVE_FILE.data && (!FRESH_START || PRETEND_ZERO))
				_best = SAVE_FILE.data.best;
				
			else if (FRESH_START)
				best = 0;
		}
		
		static public function get best():int {
			
			return _best;
		}
		
		static public function set best(score:int):void {
			
			if (PRETEND_ZERO && score < _best)
				return;
			
			SAVE_FILE.data.best = _best = score;
			//SAVE_FILE.data.replay = Recordings.getLatest();
			SAVE_FILE.flush();
		}
		
		{ STATIC_INIT(); }
	}
}