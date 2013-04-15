package zelda.assets {
	import relic.Asset;
	import relic.art.blitting.Blit;
	import relic.art.IDisplay;
	import relic.BoundMode;
	import relic.helpers.Keys;
	import relic.shapes.Box;
	
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends Asset {
		public var l:Boolean, r:Boolean, u:Boolean, d:Boolean;
		public var speed:int;
		public function Hero() { super(new Blit());} 
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			
			id = "hero";
			//graphic.stretchMode = border;
			shape = new Box(0, 0, 50, 50);
			boundMode = BoundMode.LOCK;
			
			speed = 10;
		}
		
		override protected function addListeners():void {
			super.addListeners();
			Keys.autoWatch(37, this, "l");
			Keys.autoWatch(38, this, "u");
			Keys.autoWatch(39, this, "r");
			Keys.autoWatch(40, this, "d");
		}
		
		override public function update():void {
			super.update();
			
			velX = ( r ? speed : 0 ) - ( l ? speed : 0 );
			velY = ( d ? speed : 0 ) - ( u ? speed : 0 );
		}
		
		override protected function removeListeners():void {
			super.removeListeners();
		}
		
		override public function destroy():void {
			super.destroy();
			
			
		}
	}

}