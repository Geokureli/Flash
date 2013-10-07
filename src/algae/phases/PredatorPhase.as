package algae.phases {
	import algae.AlgaeMap;
	import algae.art.Chiton;
	import krakel.helpers.Random;
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author George
	 */
	public class PredatorPhase extends Phase {
		static private const NUM_MOVES:uint = 6;
		static private const WAIT_TIME:Number = .5;
		
		static private const DIRECTIONS:Vector.<FlxPoint> = new <FlxPoint>[
			new FlxPoint(1, 0),
			new FlxPoint(0, 1),
			new FlxPoint(-1, 0),
			new FlxPoint(0, -1)
		];
		
		private var moveTimer:FlxTimer;
		
		protected var chitons:Vector.<Chiton>;
		
		protected var movesLeft:uint;
		private var nextSpawn:uint;
		
		public function PredatorPhase(target:FlxBasic) {
			super(target);
			title = "Predator's turn";
			chitons = new Vector.<Chiton>();
			moveTimer = new FlxTimer();
			
			nextSpawn = 1;
		}
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			if (quadrat.roundNum == nextSpawn) {
				var pos:FlxPoint = new FlxPoint(400, 400);
				pos = seaweed.getTileCoordsAtPos(pos.x, pos.y, true);
				var chiton:Chiton = new Chiton(pos.x, pos.y);
				chitons.push(chiton);
				quadrat.add(chiton);
				nextSpawn = Math.round(nextSpawn * 1.618);
			}
			
			startMove();
		}
		
		private function startMove():void {
			movesLeft = NUM_MOVES;
			
			nextMove();
		}
		
		private function nextMove():void {
			
			if (movesLeft == 0) {
				end();
				return;
			}
			
			movesLeft--;
			
			for each(var chiton:Chiton in chitons) {
				var dir:FlxPoint = Random.item(DIRECTIONS) as FlxPoint;
				
				var movement:FlxPoint = new FlxPoint(
					dir.x * seaweed.tileSize,
					dir.y * seaweed.tileSize
				);
				
				chiton.move(movement);
			}
			moveTimer.start(Chiton.MOVE_TIME + WAIT_TIME, 1, endMove);
			
		}
		
		private function endMove(timer:FlxTimer):void {
			
			var index:uint;
			var frame:uint;
			for each(var chiton:Chiton in chitons) {
				index = seaweed.indexAtPos(chiton.x+32, chiton.y+32);
				frame = seaweed.getTileByIndex(index);
				if (frame == AlgaeMap.BROWN_PLANT
				|| frame == AlgaeMap.GREEN_PLANT
				|| frame == AlgaeMap.RED_PLANT) {
					trace(frame);
					seaweed.setTileByIndex(index, 0);
				}
			}
			nextMove();
		}
		
	}

}