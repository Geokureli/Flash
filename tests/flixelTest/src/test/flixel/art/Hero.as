package test.flixel.art {
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends Jumper {
		static public const JUMP:int = 120,
							JUMP_SKID:int = 230,
							HOP:int = 150,
							SPEED:int = 600,
							AIR_SPEED:int = 400,
							MAX_X:int = 100,
							MAX_Y:int = 300,
							WALL_SPEED:int = 75,
							DRAG:int = 300,
							AIR_DRAG:int = 100,
							GRAVITY:Number = 600,
							NUM_HOPS:Number = 1;
		
		public function Hero() {
			super(50, 50);
			numHops = 1;
			width = 7;
			height = 12;
			jumpMax = 10;
			jumpMin = 3;
			makeGraphic(width, height, 0xFFFF0000);
			acceleration.y = GRAVITY;
			maxVelocity.x = MAX_X;
			jumpV = JUMP;
			jumpSkidV = JUMP_SKID;
			hopV = HOP;
			acc = SPEED;
			airAcc = AIR_SPEED;
			maxFall = MAX_Y;
			maxWallFall = WALL_SPEED;
			groundDrag = DRAG;
			airDrag = AIR_DRAG;
			numHops = NUM_HOPS;
			
			changeDirOnHop =
				canSkidJump =
				canWallJump =
				canWallSlide = true;
		}
		override public function hop():void {
			super.hop();
		}
	}

}