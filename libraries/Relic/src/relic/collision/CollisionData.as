package relic.collision {
	import relic.Asset;
	import relic.shapes.Box;
	import relic.shapes.Shape;
	import relic.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class CollisionData {
		public var attacker:Asset,
					victim:Asset;
		
		public var victimShape:Shape,
					attackerShape:Shape;
		
		public var dis:Vec2,
					projection:Vec2;
		
		public function CollisionData(attackerShape:Shape, victimShape:Shape, dis:Vec2, projection:Vec2) {
			this.attackerShape = attackerShape;
			this.victimShape = victimShape;
			this.dis = dis;
			this.projection = projection;
		}
		public function resolveOperlap():void {
			if (attackerShape is Box && victimShape is Box) 
				separateBoxes();
		}
		
		public function separateBoxes():void {
			var dif:Vec2 = new Vec2(attacker.velX - victim.velX, attacker.velY - victim.velY);
			
			if (attacker.moves && !victim.moves) {
				attacker.x -= projection.x;
				attacker.y -= projection.y;
			} else if (attacker.moves || victim.moves){
				victim.x += projection.x;
				victim.y += projection.y;
			}
				
		}
		
		public function get isX():Boolean {
			return projection.x * projection.x < projection.y * projection.y
		}
		public function chooseSeparationAxis():void {
			if (isX)	projection.y = 0;
			else		projection.x = 0;
		}
		
		public function get projX():Number { return projection.x; }
		public function set projX(value:Number):void { projection.x = value; }
		public function get projX2():Number { return projX*projX; }
		
		public function get projY():Number { return projection.y; }
		public function set projY(value:Number):void { projection.y = value; }
		public function get projY2():Number { return projY*projY; }
	}

}