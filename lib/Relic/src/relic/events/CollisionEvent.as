package relic.events {
	import flash.events.Event;
	import relic.Asset;
	
	/**
	 * ...
	 * @author George
	 */
	public class CollisionEvent extends Event {
		
		static public const OVERLAP	:String = "overlap",
							COLLIDE	:String = "collide",
							ENTER	:String = "enter",// --- eew
							LEAVE	:String = "leave";
		
		public var attacker:Asset, victim:Asset;
		
		public function CollisionEvent(type:String, attacker:Asset, victim:Asset, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
			this.attacker = attacker;
			this.victim = victim;
		}
		
		public override function clone():Event {
			return new CollisionEvent(type, attacker, victim, bubbles, cancelable);
		}
		public function flip():Event {
			return new CollisionEvent(type, victim, attacker, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("CollisionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}