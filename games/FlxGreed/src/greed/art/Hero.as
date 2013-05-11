package greed.art {
	import greed.schemes.Scheme;
	import krakel.jump.JumpScheme;
	import krakel.KrkSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends KrkSprite {
		
		[Embed(source="../../../res/graphics/theif.png")] static private const SHEET:Class;
		private var _weight:int;
		
		private var spawn:FlxPoint;
		
		public function Hero(x:Number = 0, y:Number = 0) {
			super(x, y);
			spawn = new FlxPoint(x, y);
			//numHops = 1;
			
			offset.x = 11;
			offset.y = 2;
			
			loadGraphic(SHEET, true, true, 32, 24);
			
			width = 10;
			height = 22;
			
			addAnimation("idle", [3]);
			addAnimation("walk", [0,1,2,3,4,5], 10);
			addAnimation("jump", [8]);
			addAnimation("c_idle", [14]);
			addAnimation("climb", [14,15,16,17], 10);
			
			
			scheme = new Scheme();
			weight = 0;
		}
		
		override public function update():void {
			super.update();
			var anim:String = "idle";
			if (jumpScheme.onLadder) {
				anim = velocity.x == 0 && velocity.y == 0 ? "c_idle" : "climb";
			} else if (isTouching(FLOOR)) {
				if (velocity.x != 0) {
					anim = "walk";
					facing = velocity.x > 0 ? RIGHT : LEFT;
					offset.x = velocity.x > 0 ? 11 : 10;
				}
			} else
				anim = "jump";// + (velocity.y > 0 ? "_rise" : "_fall");
			
			play(anim);
		}
		
		override public function revive():void {
			super.revive();
			x = spawn.x;
			y = spawn.y;
			weight = 0;
		}
		
		public function hitObject(obj:FlxObject):void {
			
			if (obj is Gold || obj is Button) {
				obj.kill();
				if (obj is Treasure) weight++;
			}
			else if (scheme != null) jumpScheme.hitObject(obj);
		}
		
		override public function destroy():void {
			super.destroy();
			spawn = null;
		}
		
		public function get weight():int { return _weight; }
		public function set weight(value:int):void {
			_weight = value;
			//jumpScheme.dragOnDecel = value == 0;
			jumpScheme.jumpMax = Scheme.JUMP_MAX - _weight * 6;
			if (jumpScheme.jumpMax < jumpScheme.jumpMin)
				jumpScheme.jumpMax = jumpScheme.jumpMin;
			
			//jumpScheme.groundDrag = Scheme.DRAG - _weight * 40;
			//if (jumpScheme.groundDrag < Scheme.DRAG_MIN)
				//jumpScheme.groundDrag = Scheme.DRAG_MIN;
		}
		
		public function get jumpScheme():Scheme { return scheme as Scheme; }
		
	}

}
