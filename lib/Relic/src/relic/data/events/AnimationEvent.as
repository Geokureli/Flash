package relic.data.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimationEvent extends Event 
	{
		static public const COMPLETE:String = "AnimComplete";
		
		public var data:Object;
		public function AnimationEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
	}

}