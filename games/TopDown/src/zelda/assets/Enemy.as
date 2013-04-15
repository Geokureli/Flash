package zelda.assets {
	import relic.art.blitting.Blit;
	import relic.Asset;
	import relic.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Enemy extends Asset {
		
		public function Enemy() { super(new Blit()); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			
			id = "enemy";
			shape = new Box(0, 0, 50, 50);
			moves = false;
		}
	}

}