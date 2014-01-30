package krakel {
	/**
	 * ...
	 * @author George
	 */
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	public class KrkGroup extends FlxGroup {
	
		override public function preUpdate():void {
			super.preUpdate();
			
			var basic:FlxBasic;
			var i:uint = 0;
			while (i < length) {
				
				basic = members[i++] as FlxBasic;
				if((basic != null) && basic.exists && basic.active)
					basic.preUpdate();
			}
		}
		override public function update():void {
			//super.update();
			
			var basic:FlxBasic;
			var i:uint = 0;
			while (i < length) {
				
				basic = members[i++] as FlxBasic;
				if ((basic != null) && basic.exists && basic.active) {
					//basic.preUpdate();
					basic.update();
					basic.postUpdate();
				}
			}
		}
		
		//override public function postUpdate():void {
			//super.postUpdate();
			//var basic:FlxBasic;
			//var i:uint = 0;
			//while(i < length)
			//{
				//basic = members[i++] as FlxBasic;
				//if((basic != null) && basic.exists && basic.active)
					//basic.postUpdate();
			//}
		//}
		
		override public function revive():void {
			super.revive();
			
			for each(var obj:FlxBasic in members)
				if (obj != null) obj.revive();
		}
		
		public function reset():void { }
	}
}