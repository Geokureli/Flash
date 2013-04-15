package util 
{
	import flash.media.Sound;
	/**
	 * ...
	 * @author George
	 */
	public class SoundManager 
	{
		static private const Sounds:Object = { };
		static public function add(name:String, sound:Sound):void {
			Sounds[name] = sound;
		}
		static public function play(name:String):void {
			(Sounds[name] as Sound).play();
		}
	}

}