package krakel.beat {
	//import baseball.data.events.BeatEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	import org.flixel.FlxG;
	import krakel.KrkSound;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class BeatKeeper {
		static public var frameRate:int = 30,
							time:int;
		
		static private var startTime:int,
							frame:int,
							songOffset:int;
		
		static public var beatsPerMinute:Number,
							beat:Number,
							nextBeat:Number,
							volume:Number;
		
		
		static private var soundBeats:Vector.<FlxSound>;
		static private var lastSound:FlxSound;
		
		static public var beatCallback:Function;
		static public var beatWatchers:Vector.<BeatWatcher>;
		
		{	// --- STATIC INIT
			beatWatchers = new Vector.<BeatWatcher>();
		}
		
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
			if (beat > nextBeat >= 1) { 
				
				// --- TRIGGER BEAT EVENT
				if (beatCallback != null) beatCallback(nextBeat);
				
				for (var i:int = 0; i < beatWatchers.length; i++)
					if (beat > beatWatchers[i].beat) {
						
						beatWatchers[i].trigger();
						beatWatchers.splice(i, 1);
					}
				
				// --- METRONOME
				if (soundBeats != null) {
					
					var sound:FlxSound = soundBeats[(((nextBeat * 4) % soundBeats.length) + soundBeats.length) % soundBeats.length];
					if (sound != null) {
						if(lastSound != null) lastSound.stop();
						sound.play(true);
						lastSound = sound;
					}
				}
				
				nextBeat += .25;
			}
			frame++;
		}
		
		static public function addWatch(beat:Number, callback:Function):void {
			
			beatWatchers.push(new BeatWatcher(beat, callback));
		}
		
		static public function clearMetronome():void {
			soundBeats = null;
			lastSound = null;
		}
		
		static public function setMetronome(sndArr:Array, volume:Number = 1):void {
			soundBeats = Vector.<FlxSound>(sndArr);
			BeatKeeper.volume = volume;
		}
		
		static public function setSimpleMetronome(measure:int, onBeat:FlxSound, offBeat:FlxSound = null, skips:int = 1, volume:Number = 1):void {
			var sndArr:Array = [onBeat];
			if (offBeat == null) offBeat == onBeat;
			
			for (var i:int = 1; i < measure; i++)
				sndArr.push(i%skips == 0 ? offBeat : null);
			
			setMetronome(sndArr, volume);
		}
		//static public function syncWithSong(song:String, offset:int):void {
			//songChannel = SoundManager.getSongChannel(song);
			//songChannel.addEventListener(Event.SOUND_COMPLETE, onSongOver);
			//songOffset = offset;
		//}
		//static public function stopSync():void {
			//songChannel = null;
			//songOffset = 0;
		//}
		//static private function onSongOver(e:Event):void { stopSync(); }
		
		static public function toBeatPixels(speed:Number):Number{
			return speed * frameRate * 60 / beatsPerMinute;
		}
		static public function toFramePixels(speed:Number):Number{
			return speed / frameRate / 60 * beatsPerMinute;
		}
		static public function toSeconds(beats:Number):Number {
			return beats / beatsPerMinute * 60;
		}
		static public function toBeats(seconds:Number):Number {
			return seconds * beatsPerMinute / 60;
		}
		
		static public function destroy():void {
			clearMetronome();
			
			beatCallback = null;
			
			while (beatWatchers.length > 0)
				beatWatchers.pop().destroy();
		}
	}
}