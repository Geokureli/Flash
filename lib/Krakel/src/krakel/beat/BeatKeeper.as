package krakel.beat {
	//import baseball.data.events.BeatEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class BeatKeeper {
		static private var startTime:int;
		static public var beatsPerMinute:Number, frameRate:int = 30;
		static public var beat:Number;
		static public var time:int;
		static private var nextBeat:Number,
							volume:Number;
		static private var soundBeats:Vector.<FlxSound>;
		static private var frame:int, songOffset:int;
		static private var songChannel:SoundChannel;
		static private var lastSound:SoundChannel;

		static public function init(startBeat:Number = 0):void {
			startTime = getTimer() - startBeat * 60000 / beatsPerMinute;
			beat = startBeat;
			nextBeat = int(beat * 4) / 4 + .25;
			frame = 0;
		}
		static public function update():void {
			time = getTimer() - startTime;
			//if(songChannel != null){
				//time = songChannel.position + songOffset;
				//time = time / 2;
			//}
			beat = time / 60000 * beatsPerMinute;
			//if (soundBeats != null && beat > nextBeat >= 1) {
				//var sound:String = soundBeats[(((nextBeat * 4) % soundBeats.length) + soundBeats.length) % soundBeats.length];
				//if (sound != null) {
					//if(lastSound != null) lastSound.stop();
					//lastSound = SoundManager.play(sound, -1, -1, volume);
				//}
				//nextBeat += .25;
			//}
			frame++;
		}
		static public function destroy():void { soundBeats = null; }
		static public function clearMetronome():void { soundBeats = null; }
		static public function setMetronome(sndArr:Array, volume:Number = 1):void {
			soundBeats = Vector.<String>(sndArr);
			BeatKeeper.volume = volume;
		}
		static public function setSimpleMetronome(measure:int, onBeat:String, offBeat:String = null, volume:Number = 1):void {
			var sndArr:Array = [onBeat];
			for (var i:int = 1; i < measure; i++)
				sndArr.push(offBeat == null ? onBeat : offBeat);
			setMetronome(sndArr, volume);
		}
		static public function syncWithSong(song:String, offset:int):void {
			//songChannel = SoundManager.getSongChannel(song);
			//songChannel.addEventListener(Event.SOUND_COMPLETE, onSongOver);
			//songOffset = offset;
		}
		static public function stopSync():void {
			songChannel = null;
			songOffset = 0;
		}
		static private function onSongOver(e:Event):void { stopSync(); }
		static public function toBeatPixels(speed:Number):Number{
			return speed * frameRate * 60 / beatsPerMinute;
		}
		static public function toFramePixels(speed:Number):Number{
			return speed / frameRate / 60 * beatsPerMinute;
		}
	}
}
class EventListener {
	public var type:String;
	public var listener:Function;
	public function EventListener(type:String, listener:Function) {
		this.type = type;
		this.listener = listener;
	}
	
	public function destroy():void {
		type = null;
		listener = null;
	}
}