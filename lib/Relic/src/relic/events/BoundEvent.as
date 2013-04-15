package relic.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class BoundEvent extends Event {
		
		static public const SHAPE_OUT:String = "shapeOut",
							SHAPE_IN:String = "shapeIn",
							GRAPHIC_OUT:String = "graphicOut",
							GRAPHIC_IN:String = "graphicIn";
		
		public function BoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new BoundEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("BoundEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}