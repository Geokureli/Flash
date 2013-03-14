package relic.data.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class BlitEvent extends AssetEvent {
		static public const ADDED_TO_BLITMAP:String = "addedToBlitmap";
		static public const REMOVED_TO_BLITMAP:String = "removedToBlitmap";
		
		public function BlitEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, null, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new BlitEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("BlitEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}