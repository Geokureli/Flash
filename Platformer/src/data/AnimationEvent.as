package data 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class AnimationEvent extends Event 
	{
		static public const COMPLETE:String = "AnimComplete";
		public function AnimationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);			
		}
		
	}

}