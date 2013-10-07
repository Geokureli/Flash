package algae.phases {
	import algae.AlgaeMap;
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author George
	 */
	public class PlayerPhase extends Phase {
		
		public var plantFrame:int,
					seedFrame:int;
		
		public function PlayerPhase(target:FlxBasic, isBrown:Boolean = true) {
			super(target);
			title = isBrown ? "Brown's turn" : "Red's turn";
			plantFrame = isBrown ? AlgaeMap.BROWN_PLANT : AlgaeMap.RED_PLANT;
			seedFrame = isBrown ? AlgaeMap.BROWN_SEED : AlgaeMap.RED_SEED;
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			quadrat.btn_continue.visible = true;
			quadrat.btn_continue.onUp = end;
		}
		
		override public function end():void {
			quadrat.btn_continue.visible = false;
			quadrat.btn_continue.onUp = null;
			
			super.end();
		}
		
		override protected function onTileClick():void {
			super.onTileClick();
			if (mouseTile == 0 && energy > 0) {
					
				if (checkNeighbors(mouseTileCoords)){
					seaweed.setTileByIndex(mouseTileIndex, seedFrame);
					energy--;
					//brown_spore.play(true);
				}
			}  else if (mouseTile == seedFrame) {
				seaweed.setTileByIndex(mouseTileIndex, 0);
				//noclick.play(true);
				energy++;
			} else if (energy > 0 && mouseTile == plantFrame
						&& heightMap.getTileByIndex(mouseTileIndex) < 3
						&& UIMap.getTileByIndex(mouseTileIndex) == 0) {
				// --- MARK FOR FUTURE GROWTH
				UIMap.setTileByIndex(mouseTileIndex, 1);
				energy--;
				//click.play(true);
			} else if (mouseTile == plantFrame && UIMap.getTileByIndex(mouseTileIndex) != 0) {
				UIMap.setTileByIndex(mouseTileIndex, 0);
				energy++;
				//click.play(true);
			} else {
				//error
			}
		}
		
		protected function checkNeighbors(tile:FlxPoint):Boolean {
			
			var up:Boolean = tile.y > 0,
				down:Boolean = tile.y + 1 < seaweed.heightInTiles,
				left:Boolean = tile.x > 0,
				right:Boolean = tile.x + 1 < seaweed.widthInTiles;
				
			// --- ADJACENT
			return (left	&& seaweed.getTile(tile.x - 1, tile.y) == plantFrame)
				|| (right	&& seaweed.getTile(tile.x + 1, tile.y) == plantFrame)
				|| (up		&& seaweed.getTile(tile.x, tile.y - 1) == plantFrame)
				|| (down	&& seaweed.getTile(tile.x, tile.y + 1) == plantFrame)
				// --- DIAGONAL
				|| (left	&& up	&& seaweed.getTile(tile.x - 1, tile.y - 1) == plantFrame)
				|| (left	&& down	&& seaweed.getTile(tile.x - 1, tile.y + 1) == plantFrame)
				|| (right	&& up	&& seaweed.getTile(tile.x + 1, tile.y - 1) == plantFrame)
				|| (right	&& down	&& seaweed.getTile(tile.x + 1, tile.y + 1) == plantFrame)
				// --- 2 AWAY WITH SEED BETWEEN
				|| (tile.x > 1 && seaweed.getTile(tile.x - 2, tile.y) == plantFrame && seaweed.getTile(tile.x - 1, tile.y) == seedFrame)
				|| (tile.x + 2 < seaweed.widthInTiles && seaweed.getTile(tile.x + 2, tile.y) == plantFrame && seaweed.getTile(tile.x + 1, tile.y) == seedFrame)
				|| (tile.y > 1 && seaweed.getTile(tile.x, tile.y - 2) == plantFrame && seaweed.getTile(tile.x, tile.y - 1) == seedFrame)
				|| (tile.y + 2 < seaweed.heightInTiles && seaweed.getTile(tile.x, tile.y + 2) == plantFrame && seaweed.getTile(tile.x, tile.y + 1) == seedFrame);
		}
		
		public function get energy():uint {
			return plantFrame == AlgaeMap.BROWN_PLANT ? energy1 : energy2;
		}
		
		public function set energy(value:uint):void {
			if (plantFrame == AlgaeMap.BROWN_PLANT)
				energy1 = value;
			else energy2 = value;
		}
	}

}