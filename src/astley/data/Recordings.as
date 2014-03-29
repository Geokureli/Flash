package astley.data {
	import astley.art.ReplayRick;
	import org.flixel.system.FlxReplay;
	/**
	 * ...
	 * @author George
	 */
	public class Recordings {
		
		static private const _replays:Vector.<String> = new <String>[];
		
		static public function addRecording(recorder:FlxReplay):void {
			
			_replays.push(recorder.save());
		}
		
		static public function getLatest():String {
			
			return _replays[_replays.length - 1];
		}
		
		static public function getReplay():String {
			
			if (_replays.length == 0)
				return null;
			
			return _replays.pop();
		}
	}
}