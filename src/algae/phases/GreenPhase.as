package algae.phases {
	import algae.AlgaeMap;
	import krakel.helpers.Random;
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author George
	 */
	public class GreenPhase extends Phase {
		
		public function GreenPhase(target:FlxBasic) {
			super(target);
			title = "Green's Turn";
		}
		
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			
			var availableSpots:Vector.<FlxPoint> = new <FlxPoint>[];
			
			var up:Boolean,
				down:Boolean,
				left:Boolean,
				right:Boolean;
				
			var x:uint, y:uint;
				
			for (var i:int = 0; i < seaweed.totalTiles; i++) {
				
				x = i % seaweed.widthInTiles;
				y = i / seaweed.widthInTiles;
				
				up = y > 0;
				down = y + 1 < seaweed.heightInTiles;
				left = x > 0;
				right = x + 1 < seaweed.widthInTiles;
					
				// --- ADJACENT
				if(((	left	&& seaweed.getTile(x - 1, y) == AlgaeMap.GREEN_PLANT)
					|| (right	&& seaweed.getTile(x + 1, y) == AlgaeMap.GREEN_PLANT)
					|| (up		&& seaweed.getTile(x, y - 1) == AlgaeMap.GREEN_PLANT)
					|| (down	&& seaweed.getTile(x, y + 1) == AlgaeMap.GREEN_PLANT))
					&&  seaweed.getTile(x, y) == 0)
				{
					// --- STORE ADJACENTS
					availableSpots.push(new FlxPoint(x, y));
				}
			}
			var tile:int;
			for (i = 0; i < 10; i++) {
				if (availableSpots.length == 0) break;
				tile = Random.index(availableSpots);
				seaweed.setTile(availableSpots[tile].x, availableSpots[tile].y, AlgaeMap.GREEN_SEED);
				availableSpots.splice(tile, 1);
			}
			
			end();
		}
	}

}