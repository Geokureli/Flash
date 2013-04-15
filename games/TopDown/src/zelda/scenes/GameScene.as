package zelda.scenes {
	import relic.art.blitting.BlitScene;
	import relic.art.blitting.BlitTileSet;
	import relic.art.TileSet;
	import relic.events.CollisionEvent;
	import zelda.assets.Enemy;
	import zelda.assets.Hero;
	import zelda.Imports;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameScene extends BlitScene {
		
		public function GameScene() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			XML.ignoreWhitespace = false;
		}
		
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			place(assets.add(new TileSet(new BlitTileSet(Imports.ZeldaTiles)), "tiles")).setParameters(new XML(new Imports.Level()));
			
			place(assets.add(new Hero())).setParameters( { x:200, y:100 } );
			place(assets.add(new Enemy())).setParameters( { x:400, y:100 } );
			
			assets.addOverlapWatch(a("hero"), a("tiles"), true, onCollision);
			
		}
		private function onCollision(e:CollisionEvent):void {
			
		}
	}

}