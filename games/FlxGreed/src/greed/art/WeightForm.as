package greed.art {
	import krakel.helpers.StringHelper;
	import krakel.KrkSprite;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	public class WeightForm extends KrkSprite {
		public var drop:Number,
					slack:Number,
					couterWeight:Number;
		
		private var counterWeightTarget:WeightForm;
		
		public function WeightForm(x:Number=0, y:Number=0, graphic:Class=null) {
			super(x, y, graphic);
			
			immovable = true;
			slack = 16;
			drop = 16;
		}
		
		override public function update():void {
			super.update();
			var mass:Number = 0;
			for each(var pair:KrkSprite in framePairs) {
				mass += pair.mass;
			}
			//trace(drop * mass);
			var targetY:Number = spawn.y + drop * mass;
			//trace(targetY, y);
			if (y + 5 < targetY) {
				y += 5;
			} else if (y - 5 > targetY) {
				y -= 5;
			} else
				y = targetY;
			
		}
		
		//override public function hitObject(obj:FlxObject):void {
			//super.hitObject(obj);
			//trace("Hit");
		//}
		//override public function separateObject(obj:FlxObject):void {
			//super.separateObject(obj);
			//trace("Separate");
		//}
		
	}

}