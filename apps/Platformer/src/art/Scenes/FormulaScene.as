package art.Scenes {
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author George
	 */
	public class FormulaScene extends TutorialScene {
		private var origin:Point;
		private var crest:int, hero:int;
		private var toss:Number;
		public function FormulaScene() { super(); }
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			crest = 100;
		}
		override protected function init(e:Event = null):void {
			super.init(e);
			origin = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			hero = origin.y-50;
			toss = -origin.x/2
			drawEquation(basic);
		}
		protected function drawEquation(func:Function):void {
			drawGrid();
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.moveTo(0, stage.stageHeight - func(-origin.x) - origin.y);
			for (var x:int = 1; x < stage.stageWidth; x++)
				graphics.lineTo(x, stage.stageHeight - func(x - origin.x) - origin.y);
		}
		
		private function drawGrid():void {
			graphics.clear();
			graphics.lineStyle(2, 0xFFFF);
			graphics.moveTo(origin.x, 0);
			graphics.lineTo(origin.x, stage.stageHeight);
			graphics.lineStyle(2, 0xFF00FF);
			graphics.moveTo(0, origin.y);
			graphics.lineTo(stage.stageWidth, origin.y);
			markY(hero);
			markY(crest);
			markX(toss);
		}
		public function markX(num:Number):void{
			graphics.lineStyle(2, 0x808080);
			var funcs:Array = [graphics.moveTo, graphics.lineTo];
			var lineSize:int = 10;
			for (var i:int = -1; (i-2) * lineSize < stage.stageHeight; i++){
				funcs[(i+1) % 2](origin.x+num, i * 2 * lineSize);
			}
		}
		public function markY(num:Number):void{
			graphics.lineStyle(2, 0x808080);
			var funcs:Array = [graphics.moveTo, graphics.lineTo];
			var lineSize:int = 10;
			for (var i:int = -1; (i-2) * lineSize < stage.stageWidth; i++){
				funcs[(i+1) % 2](i * 2 * lineSize, origin.y-num);
			}
		}
		private function basic(num:Number):Number {
			return square((4 * num + origin.x) / origin.x) * (hero - crest) + crest;
		}
		private function square(num:Number):Number { return num * num; }
	}

}