package  {
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEngine;
	import worlds.PlatformWorld;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameEngine extends SPEngine {
		
		public function GameEngine() {
			super();
		}
		
		override public function init():void {
			super.init();
			SP.world = new PlatformWorld();
		}

	}

}