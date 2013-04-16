package relic.collision {
	import relic.art.TileSet;
	import relic.Asset;
	import relic.events.CollisionEvent;
	import relic.shapes.Box;
	import relic.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class CollisionWatch {
		
		private var attackers:Vector.<Asset>,
					victims:Vector.<Asset>;
		
		private var pairs:Object;
		private var args:Object;
		
		private var listener:Function;
		
		private var rebound:Boolean;
		
		public function CollisionWatch (group1:Vector.<Asset>, group2:Vector.<Asset>, rebound:Boolean, listener:Function, params:Object) {
			this.attackers = group1;
			this.victims = group2;
			this.listener = listener;
			this.rebound = rebound;
			pairs = { };
		}
		public function update():void {
			var data:CollisionData;
			for each(var attacker:Asset in attackers) {
				for each(var victim:Asset in victims) {
					if (attacker != victim) {
						if (victim is TileSet) {
							var swap:Asset = victim;
							victim = attacker;
							attacker = swap;
						}
						data = attacker.isTouching(victim);
							
						if (checkArguments(attacker, victim) && data != null) {
							
							if (!(attacker.id in pairs)) {
								dispatchEvent(CollisionEvent.ENTER, attacker, victim, data);
								// --- CREATE LIST
								if (pairs[attacker.id] == null)
									pairs[attacker.id] = new Vector.<Asset>();
								// --- ADD PAIR
								pairs[attacker.id].push(victim);
							}
							
							dispatchEvent(CollisionEvent.OVERLAP, attacker, victim, data);
						} else if (attacker.id in pairs) {
							var i:int = pairs[attacker.id].indexOf(victim);
							if ( i != -1) {
								dispatchEvent(CollisionEvent.LEAVE, attacker, victim, data);
								pairs[attacker.id].splice(i, 1);
							}
						}
					}
				} 
			} 
			for (var a:String in pairs) {
				
			}
		}
		
		private function checkArguments(attacker:Asset, victim:Asset):Boolean {
			if (args == null) return true;
			var victimArgs:Object = args;
			if ("attacker" in args) {
				
				victimArgs = args.victim;
				
				for (var i:String in args.attacker)
					if (!(i in attacker) || attacker[i] != args.attacker)
						return false;
			}
			
			for (i in victimArgs)
				if (!(i in victim) || victim[i] != args.victim)
					return false;
			
			return true;
		}
		
		protected function dispatchEvent(type:String, attacker:Asset, victim:Asset, data:CollisionData):void {
			var e:CollisionEvent = new CollisionEvent(type, attacker, victim);
			
			if (listener != null)
				listener(e);
			
			attacker.dispatchEvent(e);
			victim.dispatchEvent(e);
		}
		
		static public function ResolveBoxes(attacker:Asset, victim:Asset, projection:Vec2):void{
			
			attacker.x = attacker.last.x;
			attacker.y = attacker.last.y;
			victim.x = victim.last.x;
			victim.y = victim.last.y;
		}
		
	}
	
}