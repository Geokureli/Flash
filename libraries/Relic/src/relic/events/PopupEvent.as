package relic.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class PopupEvent extends Event {
		
		static public const COMPLETE:String = "complete";
		
		public var button:String;
		public var params:Object;
		
		public function PopupEvent(type:String, button:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.button = button;
			this.params = params;
		} 
		
		public override function clone():Event { 
			return new PopupEvent(type, button, params, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PopupEvent", "type", "button", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}