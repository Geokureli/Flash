package krakel.audio {
	import krakel.KrkSound;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class SoundManager {
		static public var ENABLED:Boolean = true;
		
		static private const sounds:Object = {};
		
		
		static public function Add(name:String, embed:Class, volume:Number = 1, loops:Boolean = false):void {
			
			var sound:KrkSound = new KrkSound().embed(embed, loops);
			
			sounds[name] = sound;
			sound.volume = volume;
		}
		
		static public function setGroupVolume(volume:Number, group:String = null):void {
			if (group == null) group == "all";
			
		}
		static public function play(name:String, forceRestart:Boolean = false):void {
			if (ENABLED) sounds[name].play(forceRestart);
		}
		static public function pause(name:String):void {
			sounds[name].pause();
		}
		static public function resume(name:String):void {
			if (ENABLED) sounds[name].resume();
		}
		
		static public function getSound(name:String):FlxSound { return sounds[name]; }
		
	}

}