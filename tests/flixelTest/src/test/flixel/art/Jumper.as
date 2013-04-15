package test.flixel.art {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
   /**
	* ...
	* @author George
	*/
   public class Jumper extends FlxSprite {
		
		
		private var l:Boolean,
					r:Boolean,
					u:Boolean, _u:Boolean,
					d:Boolean;
		
		private var hopCount:int,
					jumpTime:int,
					lockDirection:int;
		
		public var jumpMin:int,
					jumpMax:int,
					hopMin:int,
					hopMax:int,
					wallMin:int,
					wallMax:int;
		
		public var right:Number,
					bottom:Number;
		
		// --- ABILITIES
		public var canSkidJump:Boolean,
					canWallJump:Boolean,
					canWallSlide:Boolean,
					changeDirOnHop:Boolean;
		
		public var maxWallFall:Number,
					groundDrag:Number,
					jumpSkidV:Number,
					airDrag:Number,
					maxFall:Number,
					numHops:Number,
					airAcc:Number,
					jumpV:Number,
					hopV:Number,
					acc:Number;
		
		public function Jumper(x:Number = 0, y:Number = 0, simpleGraphic:Class = null) {
			super(x, y, simpleGraphic);
			hopCount = 0;
			jumpMin = 
				jumpMax =
				hopMin =
				hopMax =
				wallMin =
				wallMax =
				airAcc =
				airDrag =
				groundDrag =
				acc = 0;
				
			maxFall = maxWallFall = 10000;
			
			changeDirOnHop = false;
			canSkidJump = false;
			canWallSlide = true;
			_u = true;
		}
		
		override public function update():void {
			super.update();
			updateKeys();
			
			right = x + width;
			bottom = y + height;
			
			var onFloor:Boolean = isTouching(FLOOR);
			var onWall:Boolean = isTouching(WALL);
			
			if (onFloor)
				hopCount = 0;
			else {
				jumpTime++;
				if ((u && jumpTime < jumpMax) || jumpTime < jumpMin)
					velocity.y = -jumpV;
			}
			// --- PLAYER HAS CHANGED DIRECTION
			if (isDecelX) {
				//velocity.x = FlxU.applyDrag(velocity.x, drag.x);
				if (u && _u && onFloor && canSkidJump) {
					_u = false;
					trace(velocity.x);
					velocity.y = -jumpSkidV;
					velocity.x = maxVelocity.x * ((r ? 1 : 0) - (l ? 1 : 0));
					//lockDirection = 10;
				}
			}
			if(canWallSlide)
				maxVelocity.y = (falling && onWall && (l || r) && !u ? maxWallFall : maxFall);
			
			drag.x = onFloor ? groundDrag : airDrag;
			
			if (u && _u) {
				_u = false;
				if (onFloor)
					jump();
				else if (onWall && canWallJump )
					wallJump();
				else if (hopCount < numHops)
					hop();
			}
			
			acceleration.x = 0;
			if(lockDirection-- <= 0)
				acceleration.x = ((r ? 1 : 0) - (l ? 1 : 0)) * (onFloor ? acc : airAcc);
			//trace(velocity.y);
		}
		
		private function jump():void {
			velocity.y = -jumpV + hopCount;
			jumpTime = 0;
		}
		
		public function hop():void {
			velocity.y = -hopV+hopCount;
			hopCount++;
			if ((l || r) && isDecelX && changeDirOnHop) {
				lockDirection = 0;
				velocity.x = maxVelocity.x * ((r ? 1 : 0) - (l ? 1 : 0));
			}
		}
		
		private function wallJump():void {
			velocity.x = ((l?1:0) - (r?1:0)) * acc;
			velocity.y = -jumpV;
			jumpTime = 0;
			lockDirection = 5;
		}
		
		private function get falling():Boolean { return velocity.y > 0; }
		private function get isDecelX():Boolean { return acceleration.x != 0 && velocity.x != 0 && (velocity.x > 0 == acceleration.x < 0); }
		
		private function updateKeys():void {
			l = FlxG.keys.A || FlxG.keys.LEFT;
			r = FlxG.keys.D || FlxG.keys.RIGHT;
			u = FlxG.keys.W || FlxG.keys.UP;
			d = FlxG.keys.S || FlxG.keys.DOWN;
			if (!u) {
				_u = true;
				if (jumpTime >= jumpMin) jumpTime == jumpMax;
			}
		}
		
		override public function destroy():void {
			super.destroy();
		}
	}

}