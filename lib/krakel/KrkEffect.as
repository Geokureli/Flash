package krakel {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkEffect extends FlxSprite {
		
		public function KrkEffect() { super(); }
		override public function revive():void {
			super.revive();
			
		}
		override public function update():void {
			super.update();
			if (velocity.y >= 0) kill();
		}
	}

}