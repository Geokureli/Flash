package krakel {
	import adobe.utils.CustomActions;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import krakel.xml.XMLParser;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author George
	 */
	public class KrkSprite extends FlxSprite {
		static private const ZERO:Point = new Point();
		
		static private const B_W:ColorMatrixFilter = new ColorMatrixFilter([
			1/3, 1/2, 1/6, 0, 0,
			1/3, 1/2, 1/6, 0, 0,
			1/3, 1/2, 1/6, 0, 0,
			0, 0, 0, 1, 0
		]);
		
		static public const GRAPHICS:Object = { };
		
		protected var _overlapArgs:Object;
		
		private var _graphic:String,
					_anim:String;
		
		public var startNode:int,
					pathT:Number;
		
		public var triggeringEdge:uint,
					movePairs:uint;
		
		public var passClouds:Boolean,
					falls:Boolean,
					recenter:Boolean,
					collides:Boolean,
					callback:Boolean,
					dragOnDecel:Boolean;
		
		public var filters:Vector.<Function>;
		
		protected var spawn:FlxPoint;
		
		public var hitAnim:String,
					killAnim:String,
					type:String;
		
		private var _scheme:KrkScheme;
		private var data:XML;
		public var pairs:Object,
					framePairs:Object;
		
		
		public function KrkSprite(x:Number = 0, y:Number = 0, graphic:Class = null) {
			super(x, y, graphic);
			
			passClouds =
				moves = 
				falls =
				dragOnDecel = false;
			
			startNode = 
				movePairs =
				pathT = 0;
			
			triggeringEdge = ANY;
			
			spawn = new FlxPoint(x, y);
			
			framePairs = {
				0x1000:new <KrkSprite>[],
				0x0100:new <KrkSprite>[],
				0x0010:new <KrkSprite>[],
				0x0001:new <KrkSprite>[]
			}
			pairs = {
				0x1000:new <KrkSprite>[],
				0x0100:new <KrkSprite>[],
				0x0010:new <KrkSprite>[],
				0x0001:new <KrkSprite>[]
			}
			_overlapArgs = { };
		}
		public function setParameters(data:XML):void {
			this.data = data;
			XMLParser.setProperties(this, data);
			if (path != null) {
				_pathNodeIndex = startNode;
				//var start:FlxPoint = path.nodes[_pathNodeIndex];
				//var end:FlxPoint = path.nodes[(_pathNodeIndex + 1) % path.nodes.length];
				//x = (end.x - start.x) * pathT + start.x;
				//y = (end.y - start.y) * pathT + start.y;
				advancePath(false);
			}
			if (recenter) {
				x += offset.x;
				y += offset.y;
			}
			spawn.x = x;
			spawn.y = y;
			
			if (!exists) kill();
		}
		override public function preUpdate():void {
			super.preUpdate();
			if (scheme != null) scheme.preUpdate();
		}
		override public function update():void {
			super.update();
			if (scheme != null) scheme.update();
			//trace(this, color.toString(16));
		}
		override public function postUpdate():void {
			super.postUpdate();
			if (scheme != null) scheme.postUpdate();
			
			var pair:KrkSprite;
			for(var i:String in pairs){
				while (pairs[i].length > 0) {
					pair = pairs[i].pop();
					if (framePairs[i].indexOf(pair) == -1)
						leaveObject(pair);
				}
			}
			var temp:Object = pairs;
			pairs = framePairs;
			framePairs = temp;
		}
		
		override protected function updateMotion():void {
			super.updateMotion();
			if ((last.x != x || last.y != y) && movePairs > 0) {
				for (var i:String in pairs) {
					if ((uint(i) & movePairs) > 0) {	
						for each(var pair:KrkSprite in pairs[i]) {
							trace(x - last.x, y - last.y);
							pair.x += x-last.x;
							pair.y += y-last.y;
						}
					}
				}
			}
			if (dragOnDecel) {
				if(isDecelX) velocity.x = FlxU.applyDrag(velocity.x, drag.x);
				if(isDecelY) velocity.y = FlxU.applyDrag(velocity.y, drag.y);
			}
		}
		
		override public function draw():void {
			var flicker:Boolean = _flicker;
			//color = 0xFFFFFF;
			if (_flickerTimer != 0 && flicker) {
				color = 0xFF4040;
				_flicker = true;
			}
			super.draw();
			
			_flicker = !flicker;
		}
		override protected function calcFrame():void {
			super.calcFrame();
			if (filters != null)
				for each(var filter:Function in filters)
					filter(framePixels);
		}
		
		public function checkHit(obj:FlxObject):Boolean {
			var isHit:Boolean = !collides || triggeringEdge == ANY;
			if (!isHit) {
				if ((triggeringEdge & DOWN) > NONE)
					isHit ||= justTouched(DOWN);
				
				if ((triggeringEdge & UP) > NONE)
					isHit ||= justTouched(UP);
				
				if ((triggeringEdge & RIGHT) > NONE)
					isHit ||= justTouched(RIGHT);
				
				if ((triggeringEdge & LEFT) > NONE)
					isHit ||= justTouched(LEFT);
			}
			
			if (_overlapArgs != null) {
				var colliderArgs:Object = _overlapArgs.collider;
				if (colliderArgs != null) {
					for (var i:String in colliderArgs) {
						
						if (i in obj && obj[i] != colliderArgs[i])
							return false;
					}
				}
				var args:Object = _overlapArgs["this"];
				if (args != null) {
					for (i in args) {
						if (i in this && this[i] != args[i])
							return false;
					}
				}
			}
			
			return isHit;
		}
		
		public function hitObject(obj:FlxObject):void {
			if (scheme != null)
				scheme.hitObject(obj);
			
			// --- GET LAST FRAMES PAIR
			var edge:uint = isPaired(obj as KrkSprite);
			// --- RESET IF
			if (!isTouching(edge)) edge = 0;
			// --- FIRST HIT WITH PLAYER?
			var isEnter:Boolean = false;
			
			if (edge == 0) {
				isEnter = true;
				edge = touching & ~wasTouching;
				// --- CANT DETERMINE NEW EDGE
				if (edge == 0 || !(edge in framePairs)) {
					// --- DETERMINE EDGE FROM OBJECT
					edge = obj.touching & ~obj.wasTouching;
					// --- FLIP EDGE SIDE
					switch(edge) {
						case UP:	edge = DOWN; break;
						case DOWN:	edge = UP; break;
						case LEFT:	edge = RIGHT; break;
						case RIGHT:	edge = LEFT; break;
					}
				}
			}
			//var msg:String =
				//((edge & 0x1000) > 0 ? "DOWN " : "") + 
				//((edge & 0x0100) > 0 ? "UP " : "") + 
				//((edge & 0x0010) > 0 ? "RIGHT " : "") + 
				//((edge & 0x0001) > 0 ? "LEFT " : "");
			//if (msg != "") trace(msg);
			if (obj is KrkSprite && edge > 0) {
				if (edge in framePairs && framePairs[edge].indexOf(obj) == -1) {
					if (isEnter) enterObject(obj);
					framePairs[edge].push(obj);
				}
				//else
					//trace(this + "has hit multiple sides, cannot determine pair direction");
			}
			
			if (hitAnim != null) play(hitAnim);
		}
		
		public function enterObject(obj:FlxObject):void { }
		
		public function leaveObject(obj:FlxObject):void { }
		
		public function isPaired(obj:KrkSprite):uint {
			for (var i:String in pairs) {
				if (pairs[i].indexOf(obj) != -1)
					return uint(i);
			}
			return 0;
		}
		
		override public function kill():void {
			alive = false;
			if(killAnim == null)
				exists = false;
			else play(killAnim);
			
			removePairs();
		}
		
		public function removePairs():void {
			for (var i:String in pairs) {
				while (pairs[i].length > 0)
					pairs.pop();
				while (framePairs[i].length > 0)
					framePairs.pop();
			}
		}
		
		override public function revive():void {
			super.revive();
			x = spawn.x;
			y = spawn.y;
			if (_anim != null)
				play(_anim);
		}
		
		override public function destroy():void {
			super.destroy();
			
			spawn = null;
			filters = null;
			
			if (scheme != null) scheme.destroy();
			scheme = null;
			
			_graphic = null;
			_anim = null;
		}
		
		public function get isDecelX():Boolean { return acceleration.x != 0 && velocity.x != 0 && (velocity.x > 0 == acceleration.x < 0); }
		public function get isDecelY():Boolean { return acceleration.y != 0 && velocity.y != 0 && (velocity.y > 0 == acceleration.y < 0); }
		
		public function get scheme():KrkScheme { return _scheme; }
		public function set scheme(value:KrkScheme):void {
			if (_scheme != null) _scheme.kill();
			_scheme = value;
			if (_scheme != null) {
				value.target = this;
				_scheme.revive();
			}
		}
		
		override public function play(AnimName:String, Force:Boolean = false):void {
			super.play(AnimName, Force);
		}
		public function get anim():String {
			if (_curAnim == null) return _anim;
			return _curAnim.name;
		}
		public function set anim(value:String):void {
			play(_anim = value);
		}
		
		public function get graphic():String { return _graphic; }
		public function set graphic(value:String):void {
			_graphic = value;
			(GRAPHICS[value] as KrkGraphic).load(this);
			if (scale.x != 1) xScale = scale.x;
			if (scale.y != 1) yScale = scale.y;
		}
		
		public function get edges():uint { return allowCollisions; }
		public function set edges(value:uint):void { allowCollisions = value; }
		
		public function get xScale():Number { return scale.x; }
		public function set xScale(value:Number):void {
			scale.x = value;
			offset.y = (width - (frameWidth * value)) / 2;
			width = frameWidth * value;
		}
		
		public function get yScale():Number { return scale.y; }
		public function set yScale(value:Number):void {
			scale.y = value;
			offset.y = (height - (frameHeight * value)) / 2;
			height = frameHeight * value;
		}
		
		public function get overlapArgs():String {
			return _overlapArgs.toString();
		}
		
		public function set overlapArgs(value:String):void {
			_overlapArgs = null;
		}
		
		public function bounce(height:Number):void {
			TweenMax.to(this, .15, { y:height.toString(), repeat:1, yoyo:true } );
		}
		
		static public function desaturate(bmd:BitmapData):void {
			bmd.applyFilter(bmd, bmd.rect, ZERO, B_W);
		}
		static public function outline(bmd:BitmapData):void {
			bmd.applyFilter(bmd, bmd.rect, ZERO, new GlowFilter(0, 1, 2, 2, 3, 1));
		}
		
		override public function toString():String {
			return (type != "KrkSprite" || graphic == null ? type : graphic) 
				+ "( " + int(x).toString() + ", " + int(y).toString() + ')';
		}
	}

}