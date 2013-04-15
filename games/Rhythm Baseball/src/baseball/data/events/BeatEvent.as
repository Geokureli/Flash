package baseball.data.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class BeatEvent extends Event {
		static public const ON_BEAT:String = "onBeat";
		public function BeatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}

}