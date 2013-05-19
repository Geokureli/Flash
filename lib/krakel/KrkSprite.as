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
		
		private var _overlapArgs:Object;
		
		private var _graphic:String,
					_anim:String;
		
		public var startNode:int,
					pathT:Number;
		
		public var triggeringEdge:uint;
		
		public var passClouds:Boolean,
					falls:Boolean,
					recenter:Boolean,
					collides:Boolean,
					callback:Boolean;
		
		public var filters:Vector.<Function>;
		
		protected var spawn:FlxPoint;
		
		public var hitAnim:String,
					killAnim:String;
		
		private var _scheme:KrkScheme;
		private var data:XML;
		protected var pairs:Vector.<KrkSprite>,
					framePairs:Vector.<KrkSprite>;
		
		
		public function KrkSprite(x:Number = 0, y:Number = 0, graphic:Class = null) {
			super(x, y, graphic);
			
			passClouds =
				moves = 
				falls = false;
			
			startNode = 
				pathT = 0;
			
			triggeringEdge = ANY;
			
			spawn = new FlxPoint(x, y);
			
			framePairs = new <KrkSprite>[];
			pairs = new <KrkSprite>[];
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
			while (pairs.length > 0) {
				pair = pairs.pop();
				if (framePairs.indexOf(pair) == -1)
					separateObject(pair);
			}
			var temp:Vector.<KrkSprite> = pairs;
			pairs = framePairs;
			framePairs = temp;
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
				if (pairs.indexOf(obj)) {
					if ((triggeringEdge & DOWN) > NONE)
						isHit ||= isTouching(DOWN);
					
					if ((triggeringEdge & LEFT) > NONE)
						isHit ||= isTouching(LEFT);
					
					if ((triggeringEdge & RIGHT) > NONE)
						isHit ||= isTouching(RIGHT);
					
					if ((triggeringEdge & UP) > NONE)
						isHit ||= isTouching(UP);
				} else {
					
					if ((triggeringEdge & DOWN) > NONE)
						isHit ||= justTouched(DOWN);
					
					if ((triggeringEdge & LEFT) > NONE)
						isHit ||= justTouched(LEFT);
					
					if ((triggeringEdge & RIGHT) > NONE)
						isHit ||= justTouched(RIGHT);
					
					if ((triggeringEdge & UP) > NONE)
						isHit ||= justTouched(UP);
				}
			}
			
			return isHit;
		}
		
		public function hitObject(obj:FlxObject):void {
			if (scheme != null)
				scheme.hitObject(obj);
				
			if (framePairs.indexOf(obj) == -1 && obj is KrkSprite)
				framePairs.push(obj);
			
			if (hitAnim != null) play(hitAnim);
		}
		public function separateObject(obj:FlxObject):void {
			
		}
		override public function kill():void {
			alive = false;
			if(killAnim == null)
				exists = false;
			else play(killAnim);
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
	}

}