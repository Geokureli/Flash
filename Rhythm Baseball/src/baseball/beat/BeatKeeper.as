package baseball.beat 
{
	import baseball.art.RhythmAsset;
	import baseball.data.events.BeatEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author George
	 */
	public class BeatKeeper {
		static private var startTime:int;
		static public var beatsPerMinute:Number, frameRate:int = 30;
		static public var beat:Number;
		static private var dispatcher:EventDispatcher;
		static private var events:Vector.<EventListener>;

		static public function init():void {
			dispatcher = new EventDispatcher();
			events = new Vector.<EventListener>();
			startTime = getTimer() + delay;
			//beatsPerMinute = 120;
			beat = -delay / 60000 * beatsPerMinute;
		}
		static public function reset():void {
			startTime = getTimer() + delay;
			beat = -delay / 60000 * beatsPerMinute;		
		}
		static public function update():void {
			var t:int = getTimer()-startTime;
			if (int(t / 60000 * beatsPerMinute) - int(beat) >= 1)
				dispatchEvent(new BeatEvent(BeatEvent.ON_BEAT));
			beat = t / 60000 * beatsPerMinute;
		}
		static public function destroy():void {
			while (events.length > 0)
				removeEventListener(events[0].type, events[0].listener);
			events = null;
		}
		
        static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			events.push(new EventListener(type, listener));
        }
        static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
			for (var i:int = 0; i < events.length; i++) 
				if (events[i].type == type && events[i].listener == listener)
					break;
			if (i < events.length) {
				events[i].destroy();
				events.splice(i, 1);
			}
        }
        static public function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        static public function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
		static public function toBeatPixels(speed:Number):Number{
			return speed * frameRate * 60 / beatsPerMinute;
		}
		static public function toFramePixels(speed:Number):Number{
			return speed / frameRate / 60 * beatsPerMinute;
		}
		static private function get delay():int { return 2000; RhythmAsset.SCROLL}
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