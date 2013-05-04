package fall.states {
	import fall.art.Platform;
	import krakel.KrkState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkState {
		public var platforms:FlxGroup;
		
		public var lastY:int;
		
		override public function create():void {
			super.create();
			
			
			
			lastY = 0;
		}
		
		override public function update():void {
			super.update();
			while (FlxG.camera.y + FlxG.height > lastY) {
				addPlatforms();
			}
			
			FlxG.camera.y += 10;
		}
		
		private function addPlatforms():void {
			var platform:Platform;
			for (var x:int = 0; x + Platform.WIDTH < FlxG.width; x += Platform.WIDTH) {
				platform = platforms.recycle(Platform) as Platform;
				platform.x = x;
				platform.y = lastY;
			}
		}
		
		override public function destroy():void {
			super.destroy();
		}
	}

}