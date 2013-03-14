package relic.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author George
	 */
	public class SoundManager {
		static private var sounds:Object;
		static private var songs:Object;
		static private var channels:Object;
		{
			sounds = { };
			songs = { };
			channels = { };
		}
		
		static public function addSound(name:String, sound:Sound):void {
			sounds[name] = sound;
		}
		static public function play(name:String, startTime:Number = 0):void {
			if (name in sounds)
				(sounds[name] as Sound).play(startTime);
			else if (name in songs) {
				stop(name);
				var channel:SoundChannel = (songs[name] as Sound).play(startTime);
				channels[name] = channel;
				channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			} else throw new ArgumentError("No sound found with the name: " + name + '.');
		}
		
		static private function soundComplete(e:Event):void {
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
		}
		static public function stop(name:String):void {
			if(channels[name] != null)
				channels[name].stop();
			channels[name] = null;
		}
		static public function addMusic(name:String, song:Sound):void {
			songs[name] = song;
		}
		
		static public function hasMusic(song:String):Boolean {
			return song in songs
		}
	}

}