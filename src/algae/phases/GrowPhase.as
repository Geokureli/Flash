package algae.phases {
	import algae.AlgaeMap;
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author George
	 */
	public class GrowPhase extends Phase {
		
		public function GrowPhase(target:FlxBasic) {
			super(target);
			title = "Sprouting";
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			for (var i:int = 0; i < UIMap.totalTiles; i++) {
				// --- GROW SPORES
				if (seaweed.getTileByIndex(i) == AlgaeMap.BROWN_SEED){
					seaweed.setTileByIndex(i, AlgaeMap.BROWN_PLANT);
					heightMap.setTileByIndex(i, 1);
				}
				
				if (seaweed.getTileByIndex(i) == AlgaeMap.RED_SEED){
					seaweed.setTileByIndex(i, AlgaeMap.RED_PLANT);
					heightMap.setTileByIndex(i, 1);
				}
				
				if (seaweed.getTileByIndex(i) == AlgaeMap.GREEN_SEED)
					seaweed.setTileByIndex(i, AlgaeMap.GREEN_PLANT);
				
				// --- RAISE GROWTH
				if (UIMap.getTileByIndex(i) > 0) {
					heightMap.setTileByIndex(i, heightMap.getTileByIndex(i) + 1);
					UIMap.setTileByIndex(i, 0);
				}
			}
			end();
		}
		
	}

}