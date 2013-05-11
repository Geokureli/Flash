package greed.schemes {
	import greed.art.Door;
	import krakel.jump.JumpScheme;
	import krakel.KrkTile;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Scheme extends JumpScheme {
		
		static public const JUMP:int = 180,
							JUMP_MAX:int = 26,
							//JUMP_SKID:int = 230,
							HOP:int = 150,
							SPEED:int = 800,
							AIR_SPEED:int = 800,
							MAX_X:int = 150,
							MAX_Y:int = 180,
							WALL_SPEED:int = 75,
							DRAG:int = 600,
							DRAG_MIN:int = 100,
							AIR_DRAG:int = 100,
							GRAVITY:Number = 1800,
							NUM_HOPS:Number = 1,
							CLIMB:Number = 120,
							TILE_SIZE:int = 16;
		
		public var touchLadder:Boolean,
					onLadder:Boolean;
		
		public function Scheme() {
			jumpMax = JUMP_MAX;
			jumpMin = 6;
			jumpV = JUMP;
			//jumpSkidV = JUMP_SKID;
			//hopV = HOP;
			acc = SPEED;
			airAcc = AIR_SPEED;
			
			maxFall = MAX_Y;
				maxRise = MAX_Y;
			//maxWallFall = WALL_SPEED;
			
			groundDrag = DRAG;
			airDrag = AIR_DRAG;
			
			//numHops = NUM_HOPS;
			
			//changeDirOnHop =
				//canSkidJump =
				//canWallJump =
				//canWallSlide = true;
		}
		
		override protected function init():void {
			super.init();
			
			accY = GRAVITY;
			maxX = MAX_X;
		}
		
		override public function update():void {
			if (touchLadder && u && !onLadder) {
				onLadder = true;
				accY = velX = velY = 0;
				centerTileX()
			} else if (onLadder) {
				
				if (u) velY = -CLIMB;
				else if (d) velY = CLIMB;
				else velY = 0;
				
				velX = ((r?maxX:0) - (l?maxX:0)) / 2;
				if (!touchLadder) {
					onLadder = false;
					accY = GRAVITY;
					if (u) jump();
				}
				
			} else super.update();
			
		}
		private function centerTileX():void {
			x = int((x - offsetX + frameWidth/2) / TILE_SIZE) * TILE_SIZE + offsetX - 8;
		}
		override public function postUpdate():void {
			super.postUpdate();
			touchLadder = false;
		}
		
		public function hitObject(obj:FlxObject):void {
			if (obj is KrkTile) {
				switch((obj as KrkTile).type) {
					case "ladder":
						touchLadder = x - obj.x > -4 && x - obj.x < 10;
						break;
					case "spring":
						forceJump();
						break;
				}
			}
		}
	}

}