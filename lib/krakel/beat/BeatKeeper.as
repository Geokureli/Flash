package krakel.beat {
	//import baseball.data.events.BeatEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import krakel.KrkSound;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class BeatKeeper extends FlxBasic {
		static public var frameRate:int = 30,
							time:int;
		
		static private var startTime:int,
							frame:int,
							songOffset:int,
							pauseTime:int;
		
		static public var beatsPerMinute:Number,
							beat:Number,
							nextBeat:Number,
							volume:Number;
		
		static private var soundBeats:Vector.<FlxSound>;
		static private var lastSound:FlxSound,
							song:KrkSound;
		
		static public var beatCallback:Function;
		static public var beatWatchers:Vector.<BeatWatcher>;
		
		static private var isRunning:Boolean,
							songStarted:Boolean,
							paused:Boolean;
		
		public function BeatKeeper(){
			isRunning = false;
			beatWatchers = new Vector.<BeatWatcher>();
			startTime = 0;
			beat = 0;
			frame = 0;
			songStarted = false;
		}
		
		static public function start(startBeat:Number = 0):void {
			startTime = getTimer() - startBeat * 60000 / beatsPerMinute;
			beat = startBeat;
			nextBeat = int(beat * 4) / 4 + .25;
			songStarted = false;
			isRunning = true;
		}
		
		static public function stop():void {
			isRunning = false;
			if (song != null) song.stop();
			if (lastSound != null) lastSound.stop();
		}
		
		override public function update():void {
			if (isRunning) {
				
				time = getTimer() - startTime;
				
				if (song != null && !songStarted && time > songOffset) {
					song.position = time-songOffset;
					song.play();
					songStarted = true;
				}
				
				if (songStarted) {
					time = song.position + songOffset;
					trace(song.position);
				}
				beat = time / 60000 * beatsPerMinute;
				if (beat > nextBeat) { 
					
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
		static public function syncWithSong(sound:KrkSound, offset:int):void {
			song = sound;
			songOffset = offset;
		}
		static public function stopSync():void {
			song = null;
			songOffset = 0;
		}
		
		static private function onSongOver(e:Event):void { stopSync(); }
		
		static public function pixelsPerBeat(frameSpeed:Number):Number{
			return frameSpeed * frameRate * 60 / beatsPerMinute;
		}
		static public function pixelsPerFrame(beatSpeed:Number):Number{
			return beatSpeed / frameRate / 60 * beatsPerMinute;
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
			beat = -1000;
			stopSync();
			
			while (beatWatchers.length > 0)
				beatWatchers.pop().destroy();
		}
		
		static public function pause():void {
			if (isRunning) {
				if (song != null) song.pause();
				if (lastSound != null) lastSound.pause();
				pauseTime = getTimer();
				paused = true;
			}
		}
		static public function unpause():void {
			if (paused) {
				paused = false;
				if (lastSound != null) lastSound.resume();
				if (song != null) song.resume();
				startTime += getTimer() - pauseTime;
			}
		}
	}
}