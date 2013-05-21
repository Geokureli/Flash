package krakel.jump {
	import krakel.KrkSprite;
	import krakel.KrkControlScheme;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author George
	 */
	public class JumpScheme extends KrkControlScheme {
		
		
		private var hopCount:int,
					jumpTime:int,
					tempJumpMin:int,
					tempJumpMax:int,
					lockDirection:int;
		
		public var jumpMin:int,
					jumpMax:int,
					hopMin:int,
					hopMax:int,
					wallMin:int,
					wallMax:int;
		
		// --- KEYS
		public var l:Boolean, _l:Boolean,
					r:Boolean, _r:Boolean,
					u:Boolean, _u:Boolean,
					d:Boolean, _d:Boolean;
		
		// --- ABILITIES
		public var canSkidJump:Boolean,
					canWallJump:Boolean,
					canWallSlide:Boolean,
					changeDirOnHop:Boolean,
					dragOnDecel:Boolean;
		
		// --- STATUS
		public var isJumping:Boolean,
					sprung:Boolean;
		
		public var right:Number,
					bottom:Number;
		
		public var maxWallFall:Number,
					groundDrag:Number,
					jumpSkidV:Number,
					airDrag:Number,
					maxFall:Number,
					maxRise:Number,
					numHops:Number,
					airAcc:Number,
					jumpV:Number,
					hopV:Number,
					acc:Number;
		
		public function JumpScheme() {
			super();
			hopCount = 0;
			jumpMin = 
				jumpMax =
				hopMin =
				hopMax =
				numHops =
				wallMin =
				wallMax =
				airAcc =
				airDrag =
				groundDrag =
				acc = 0;
			
			jumpTime =
				maxFall =
				maxRise =
				maxWallFall = 10000;
			
			changeDirOnHop =
				sprung =
				canSkidJump =
				canWallSlide = false;
			
			keyBinds = KEY_DIRECTIONS;
			_r = _l = _u = _d = true;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			right = x + width;
			bottom = y + height;
			
			accX = 0;
		}
		
		override public function update():void {
			super.update();
			
			var touchFloor:Boolean = isTouching(FLOOR);
			var touchWall:Boolean = isTouching(WALL);
			// --- OVERRIDE PUBLIC VARS
			var jumpMin:int = sprung ? tempJumpMin : this.jumpMin;
			var jumpMax:int = sprung ? tempJumpMax : this.jumpMax;
			
			isJumping = false;
			
			if (touchFloor)
				hopCount = 0;
			else {
				// --- JET JUMPING (VARIABLE HEIGHT)
				jumpTime++;
				isJumping = (u && jumpTime < jumpMax) || jumpTime < jumpMin;
				if (isJumping && !isTouching(CEILING))
					velY = -jumpV;
				else {
					jumpTime = jumpMax;
					tempJumpMin = 0;
					tempJumpMax = 0;
					sprung = false;
				}
			}
			// --- PLAYER HAS CHANGED DIRECTION
			if (isDecelX) {
				//if(dragOnDecel) velX = FlxU.applyDrag(velX, dragX);
				// --- SKID JUMP
				if (u && _u && touchFloor && canSkidJump) {
					_u = false;
					velY = -jumpSkidV;
					velX = maxX * ((r ? 1 : 0) - (l ? 1 : 0));
					//lockDirection = 10;
				}
			}
			if (falling)
				maxY = (canWallSlide && touchWall && (l || r) && !u ? maxWallFall : maxFall);	
			else 
				maxY = maxRise;
			
			
			dragX = touchFloor ? groundDrag : airDrag;
			
			if (u && _u) {
				if (touchFloor)
					jump();
				else if (touchWall && canWallJump)
					wallJump();
				else if (hopCount < numHops)
					hop();
			}
			
			if(lockDirection-- <= 0)
				accX = ((r ? 1 : 0) - (l ? 1 : 0)) * (touchFloor ? acc : airAcc);
			//trace(velY);
		}
		
		public function jump():void {
			velY = -jumpV + hopCount;
			jumpTime = 0;
			_u = false;
		}
		
		public function hop():void {
			velY = -hopV+hopCount;
			hopCount++;
			if ((l || r) && isDecelX && changeDirOnHop) {
				lockDirection = 0;
				velX = maxX * ((r ? 1 : 0) - (l ? 1 : 0));
			}
			_u = false;
		}
		
		public function forceJump():void {
			tempJumpMin = jumpMax;
			tempJumpMax = jumpMax+10;
			jump();
			sprung = true
		}
		
		private function wallJump():void {
			velX = ((l?1:0) - (r?1:0)) * acc;
			velY = -jumpV;
			jumpTime = 0;
			lockDirection = 5;
			_u = false;
		}
		
		private function get falling():Boolean { return velY > 0; }
		public function get isDecelX():Boolean { return accX != 0 && velX != 0 && (velX > 0 == accX < 0); }
		
	}

}