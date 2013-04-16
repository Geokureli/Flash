package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import relic.art.Asset;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public class BlitDraw {
		private var target:BitmapData;
		
		private var drawPos:Vec2;
		
		private var fillColor:uint,
					lineColor:uint,
					lineThickness:uint;
		
		private var fillAlpha:Number,
					lineAlpha:Number;
		
		public function BlitDraw(target:BitmapData) {
			this.target = target;
			setDefaultValue();
		}
		
		protected function setDefaultValue():void {
			drawPos = new Vec2();
		}
		public function beginFill(color:uint, alpha:Number = 1):void {
			fillColor = color;
			fillAlpha = alpha;
		}
		public function lineStyle(thickness:Number = 1, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
			lineThickness = thickness;
			lineColor = color;
			lineAlpha = alpha;
		}
		public function moveTo(x:Number, y:Number):void {
			drawPos.x = x;
			drawPos.y = y;
		}
		public function lineTo(x:Number, y:Number):void {
			var slope:Vec2 = new Vec2(x - drawPos.x, y - drawPos.y);
			target.unlock();
			
			if (slope.x == 0) 
				target.fillRect(new Rectangle(drawPos.x, Math.min(drawPos.y, y), lineThickness, Math.abs(slope.y)), lineColor);
				
			else if (slope.y == 0) 
				target.fillRect(new Rectangle(Math.min(drawPos.x, x), drawPos.y, Math.abs(slope.x), lineThickness), lineColor);
			
			else {
				slope.divide(slope.x);
				for (; x < drawPos.x; x++) {
					target.setPixel32(x, y, lineColor);
					y += slope.y;
				}
			}
			
			drawPos.x = x;
			drawPos.y = y;
			target.lock();
		}
		public function drawCircle(x:Number, y:Number, radius:Number):void { }
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void { }
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void { }
		public function clear():void { }
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = 0):void { }
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void { }
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void { }
		public function endFill():void { }
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):void { }
	}

}