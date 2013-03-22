package relic.art 
{
	import relic.art.blitting.Blit;
	import relic.data.xml.IXMLParam;
	
	/**
	 * ...
	 * @author George
	 */
	public class ScrollingBG extends Asset
	{
		public function ScrollingBG() { super(); }
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			graphic = new ScrollBlit();
		}
		public function get parallax():Number { return blit.parallax.x; }
		public function set parallax(value:Number):void {
			blit.parallax.x = value;
		}
		
		public function get rows():Number { return rows; }
		public function set rows(value:Number):void { blit.rows = value; }
		
		public function get columns():Number { return columns; }
		public function set columns(value:Number):void { blit.columns = value; }
		
		public function get blit():ScrollBlit { return graphic as ScrollBlit; }
	}
}
import flash.events.Event;
import flash.geom.Point;
import relic.art.SpriteSheet;
import relic.art.blitting.Blit;
import relic.data.helpers.Random;
class ScrollBlit extends Blit {
	
	
	public var frames:Vector.<Vector.<int>>;

	override protected function setDefaultValues():void {
		super.setDefaultValues();
		columns = 0;
	}
	override protected function init(e:Event):void {
		super.init(e);
		//setFrameData();
	}
	
	override public function draw():void {
		super.draw();
	}
	//override protected function getTile(x:int, y:int):int {
		//var sheet:SpriteSheet = image as SpriteSheet;
		//if (sheet && sheet.numFrames > 1 && asset.id == "bg_darkGrass")
			//return defaultFrame = (((x + y) % sheet.numFrames) + sheet.numFrames) % sheet.numFrames;
		//return 0;
	//}
	private function setFrameData():void {
		//if (stage) {
			//if (rows < 1) rows = stage.stageHeight / rect.height;
			//if (columns < 1) columns = stage.stageHeight / rect.height;
		//}
		//
		//frames = new Vector.<Vector.<int>>();
		//for (var i:int = 0; i < columns; i++) {
			//frames.push(new Vector.<int>());
			//frames[i].push(Random.random(numFrames));
		//}
	}
	//public function update():void { super.update(); }
	//override public function draw():void {
		//if (anim != null || image != null) {
			//var oldPosition:Point = position.clone();
			//var size:Rectangle = rect;
			//position.x *= parallax;
			//position.x = position.x % size.width;
			//var frameOffset:int = numFrames;
			//if (position.x > 0) position.x -= size.width;
			//var r:int = 0, c:int = 0;
			//for (c = 0; c; position.x += size.width) {
				//position.y = oldPosition.y;
				//for (r = 0; r != rows; r++) {
					//frame = Random.random(numFrames);
					//super.draw();
					//position.y += size.height;
				//}
			//}
			//position = oldPosition;
		//}
	//}
	
	override public function get rows():int { return super.rows; }
	override public function set rows(value:int):void { super.rows = value; setFrameData(); }
	
	override public function get columns():int { return super.columns; }
	override public function set columns(value:int):void { super.columns = value; setFrameData(); }
}