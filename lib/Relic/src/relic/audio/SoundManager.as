package relic.audio 
{
	import flash.media.Sound;
	/**
	 * ...
	 * @author George
	 */
	public class SoundManager {
		static public var sounds:Object = { };
		
		static public function addSound(name:String, sound:Sound):void {
			sounds[name] = sound;
		}
		static public function play(name:String):void {
			(sounds[name] as Sound).play();
		}
		
	}

}