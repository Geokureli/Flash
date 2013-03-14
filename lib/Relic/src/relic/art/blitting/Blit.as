package relic.art.blitting {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import relic.art.Animation;
	import relic.art.Asset;
	import relic.art.SpriteSheet;
	import relic.data.BoundMode;
	import relic.data.events.AnimationEvent;
	import relic.data.events.AssetEvent;
	import relic.data.events.BlitEvent;
	import relic.data.shapes.Box;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class Blit extends Asset {
		protected var position:Point;
		
		internal var _layer:BlitLayer;
		
		public function Blit() { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			position = new Point();
			addEventListener(BlitEvent.ADDED_TO_BLITMAP, init);
		}
		
		override protected function init(e:Event):void {
			if (e is BlitEvent) {
				removeEventListener(BlitEvent.ADDED_TO_BLITMAP, init);
				bounds = map.bitmapData.rect;
			} else {
				if(_layer)
					_layer.remove(this);
				_layer = null;
				super.init(e);
			}
		}
		
		public function drawToStage(target:BitmapData):void {
			if (visible) {
				var o:Point = origin.point;
				position.add(o);
				if (anim != null)
					anim.drawFrame(_currentFrame, target, position);
				else if (graphic != null) {
					target.copyPixels(graphic as BitmapData, (graphic as BitmapData).rect, position);
				}
				position.subtract(o);
			}
		}
		
		override public function destroy():void {
			position = null;
			
			if(_layer)
				_layer.remove(this);
			_layer = null;
		}
		
		override public function set x(value:Number):void { super.x = position.x = value; }
		override public function set y(value:Number):void { super.y = position.y = value; }
		
		override public function get stage():Stage {
			if (parent != null)
				return super.stage;
			if(_layer != null)
				return _layer.stage;
			return null;
		}
		protected function get map():Blitmap { return _layer.parent; }
	}
}