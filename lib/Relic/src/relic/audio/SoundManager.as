package relic.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author George
	 */
	public class SoundManager {
		static private var sounds:Object;
		static private var songs:Object;
		static private var channels:Object;
		static private var _currentSong:String;
		{
			sounds = { };
			songs = { };
			channels = { };
		}
		
		static public function addSound(name:String, sound:Sound, defaultParams:Object = null):void {
			sounds[name] = new SoundDescription(sound);
			sounds[name].setParameters(defaultParams);
		}
		
		static public function addMusic(name:String, song:Sound):void {
			songs[name] = song;
		}
		
		static public function play(name:String, startTime:Number = -1, loops:int = -1, volume:Number = -1, pan:Number = -2):SoundChannel {
			if (name in sounds)
				return (sounds[name] as SoundDescription).play(startTime, loops, volume, pan);
			else if (name in songs) {
				var tfm:SoundTransform = new SoundTransform(
					volume > -1 ? volume : 1,
					pan == -2 ? 0 : pan
				);
				stop(name);
				_currentSong = name;
				var channel:SoundChannel = (songs[name] as Sound).play(startTime, 0, tfm);
				channels[name] = channel;
				channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
				return channel;
			} else throw new ArgumentError("No sound found with the name: " + name + '.');
			return null;
		}
		
		static private function soundComplete(e:Event):void {
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
		}
		static public function stop(name:String):void {
			if(channels[name] != null)
				channels[name].stop();
			channels[name] = null;
		}
		static public function getSongChannel(name:String):SoundChannel { return channels[name]; }
		static public function get currentSong():SoundChannel { return channels[_currentSong]; }
		static public function get currentSongPosition():Number { return currentSong.position; }
		static public function hasMusic(song:String):Boolean { return song in songs; }
	}

}
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import relic.data.xml.IXMLParam;
class SoundDescription implements IXMLParam {
	private var transform:SoundTransform;
	public var startTime:Number;
	public var loops:int;
	public var sound:Sound;
	public function SoundDescription(sound:Sound) {
		this.sound = sound;
		transform = new SoundTransform();
	}
	public function setParameters(params:Object):void {
		for (var i:String in params) this[i] = params[i];
	}
	public function play(startTime:Number = -1, loops:int = -1, volume:Number = -1, pan:Number = -2):SoundChannel {
		if (startTime < 0) startTime = this.startTime;
		if (loops < 0) loops = this.loops;
		var transform:SoundTransform = this.transform;
		if (volume >= 0 || pan == -2) {
			transform = new SoundTransform(
				volume > -1 ? volume : this.transform.volume,
				pan == -2 ? this.transform.pan : pan
			);
		}
		return sound.play(startTime, loops, transform);
	}
	
	
	public function get volume():Number { return transform.volume; }
	public function set volume(value:Number):void { transform.volume = value; }
	
	public function get pan():Number { return transform.pan; }
	public function set pan(value:Number):void { transform.pan = value; }
}