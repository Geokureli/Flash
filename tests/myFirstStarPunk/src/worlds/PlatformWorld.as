package worlds {
	import com.saia.starlingPunk.SPWorld;
	import entities.Hero;
	
	/**
	 * ...
	 * @author George
	 */
	public class PlatformWorld extends SPWorld {
		private var hero:Hero;
		
		public function PlatformWorld() {
			super();
		}
		override public function begin():void {
			super.begin();
			add(hero = new Hero(50, 50));
		}
		override public function end():void {
			super.end();
		}
	}

}
