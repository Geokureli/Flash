package krakel {
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	import org.flixel.FlxCamera;
	/**
	 * ...
	 * @author George
	 */
	public class KrkScheme {
		/** Generic value for "left" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>. */
		static public const LEFT:uint	= 0x0001;
		/** Generic value for "right" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>. */
		static public const RIGHT:uint	= 0x0010;
		/** Generic value for "up" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>. */
		static public const UP:uint		= 0x0100;
		/** Generic value for "down" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>. */
		static public const DOWN:uint	= 0x1000;
		
		/** Special-case constant meaning no collisions, used mainly by <code>allowCollisions</code> and <code>touching</code>. */
		static public const NONE:uint	= 0;
		/** Special-case constant meaning up, used mainly by <code>allowCollisions</code> and <code>touching</code>. */
		static public const CEILING:uint= UP;
		/** Special-case constant meaning down, used mainly by <code>allowCollisions</code> and <code>touching</code>. */
		static public const FLOOR:uint	= DOWN;
		/** Special-case constant meaning only the left and right sides, used mainly by <code>allowCollisions</code> and <code>touching</code>. */
		static public const WALL:uint	= LEFT | RIGHT;
		/** Special-case constant meaning any direction, used mainly by <code>allowCollisions</code> and <code>touching</code>. */
		static public const ANY:uint	= LEFT | RIGHT | UP | DOWN;
		
		/** Handy constant used during collision resolution (see <code>separateX()</code> and <code>separateY()</code>). */
		static public const OVERLAP_BIAS:Number = 4;
		
		/** Path behavior controls: move from the start of the path to the end then stop. */
		static public const PATH_FORWARD:uint			= 0x000000;
		/** Path behavior controls: move from the end of the path to the start then stop. */
		static public const PATH_BACKWARD:uint			= 0x000001;
		/** Path behavior controls: move from the start of the path to the end then directly back to the start, and start over. */
		static public const PATH_LOOP_FORWARD:uint		= 0x000010;
		/** Path behavior controls: move from the end of the path to the start then directly back to the end, and start over. */
		static public const PATH_LOOP_BACKWARD:uint		= 0x000100;
		/** Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over. */
		static public const PATH_YOYO:uint				= 0x001000;
		/** Path behavior controls: ignores any vertical component to the path data, only follows side to side. */
		static public const PATH_HORIZONTAL_ONLY:uint	= 0x010000;
		/** Path behavior controls: ignores any horizontal component to the path data, only follows up and down. */
		static public const PATH_VERTICAL_ONLY:uint		= 0x100000;
		
		internal var target:KrkSprite;
		private var _x:Number;
		protected var _hitCallbacks:Object;
		
		public function KrkScheme() { }
		
		
		protected function init():void {
			
			_hitCallbacks = { };
		}
		
		public function preUpdate():void { }
		public function update():void { }
		public function postUpdate():void { }
		
		public function hitObject(obj:FlxObject):void {
			var tile:KrkTile = obj as KrkTile;
			if (tile != null && tile.type in _hitCallbacks) {
				
				_hitCallbacks[tile.type](tile);
			}
		}
		
		public function kill():void { target = null; }
		public function revive():void { init(); }
		
		public function destroy():void { kill(); }
		
		/* DELEGATE krakel.KrkSprite */
		
		public function get x():Number { return target.x; }
		public function set x(value:Number):void { target.x = value; }
		
		public function get y():Number { return target.y; }
		public function set y(value:Number):void { target.y = value; }
		
		public function get offsetX():Number { return target.offset.x; }
		public function set offsetX(value:Number):void { target.offset.x = value; }
		
		public function get offsetY():Number { return target.offset.y; }
		public function set offsetY(value:Number):void { target.offset.y = value; }
		
		public function get velX():Number { return target.velocity.x; }
		public function set velX(value:Number):void { target.velocity.x = value; }
		
		public function get velY():Number { return target.velocity.y }
		public function set velY(value:Number):void { target.velocity.y = value; }
		
		public function get accX():Number { return target.acceleration.x; }
		public function set accX(value:Number):void { target.acceleration.x = value; }
		
		public function get accY():Number { return target.acceleration.y }
		public function set accY(value:Number):void { target.acceleration.y = value; }
		
		public function get maxX():Number { return target.maxVelocity.x }
		public function set maxX(value:Number):void { target.maxVelocity.x = value; }
		
		public function get maxY():Number { return target.maxVelocity.y }
		public function set maxY(value:Number):void { target.maxVelocity.y = value; }
		
		public function get dragX():Number { return target.drag.x }
		public function set dragX(value:Number):void { target.drag.x = value; }
		
		public function get dragY():Number { return target.drag.y }
		public function set dragY(value:Number):void { target.drag.y = value; }
		
		public function get width():Number { return target.width; }
		public function set width(value:Number):void { target.width = value; }
		
		public function get height():Number { return target.height; }
		public function set height(value:Number):void { target.height = value; }
		
		public function get frameWidth():Number { return target.frameWidth; }
		public function set frameWidth(value:Number):void { target.frameWidth = value; }
		
		public function get frameHeight():Number { return target.frameHeight; }
		public function set frameHeight(value:Number):void { target.frameHeight = value; }
		
		public function get angle():Number { return target.angle; }
		public function set angle(value:Number):void { target.angle = value; }
		
		public function get alpha():Number { return target.alpha; }
		public function set alpha(value:Number):void { target.alpha = value; }
		
		public function get color():uint { return target.color; }
		public function set color(value:uint):void { target.color = value; }
		
		public function get facing():uint { return target.facing; }
		public function set facing(value:uint):void { target.facing = value; }
		
		public function get frame():uint { return target.frame; }
		public function set frame(value:uint):void { target.frame = value; }
		
		public function get finished():Boolean { return target.finished; }
		public function set finished(value:Boolean):void { target.finished = value; }
		
		public function get solid():Boolean { return target.solid; }
		public function set solid(value:Boolean):void { target.solid = value; }
		
		public function get moves():Boolean { return target.moves; }
		public function set moves(value:Boolean):void { target.moves = value; }
		
		public function get health():Number { return target.health; }
		public function set health(value:Number):void { target.health = value; }
		
		public function onScreen(camera:FlxCamera = null):Boolean { return target.onScreen(camera); }
		
		public function play(animName:String, force:Boolean = false):void { target.play(animName, force); }
		
		public function flicker(duration:Number = 1):void { target.flicker(duration); }
		
		public function get flickering():Boolean { return target.flickering; }
		
		public function get path():FlxPath { return target.path; }
		public function set path(value:FlxPath):void { target.path = value; }
		
		public function followPath(path:FlxPath, speed:Number = 100, mode:uint = PATH_FORWARD, autoRotate:Boolean = false):void {
			target.followPath(path, speed, mode, autoRotate);
		}
		public function stopFollowingPath(destroyPath:Boolean = false):void {
			target.stopFollowingPath(destroyPath);
		}
		
		public function getMidpoint(point:FlxPoint = null):FlxPoint { return target.getMidpoint(point); }
		public function getScreenXY(point:FlxPoint = null, Camera:FlxCamera = null):FlxPoint {
			return target.getScreenXY(point, Camera);
		}
		
		public function hurt(damage:Number):void { target.hurt(damage); }
		
		public function isTouching(direction:uint):Boolean { return target.isTouching(direction); }
		public function justTouched(direction:uint):Boolean { return target.justTouched(direction); }
		
		public function reset(x:Number, y:Number):void { target.reset(x, y); }
	}

}