package data.level {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class LevelData {
		private var sections:Vector.<Section>;
		private var tile:Rectangle;
		private var height:int, sectionStart:int;
		public function LevelData(tile:Rectangle, height:int) {
			this.tile = tile;
			this.height = height;
			sectionStart = 0;
			sections = new Vector.<Section>();
		}
		public function extend(width:int, min:int, max:int):void {
			if (sections.length == 0)
				sections.push(new Section(tile, width, height, min, max, 0));
			else
				sections.push(new Section(tile, width, height, min, max, sections[sections.length - 1].last));
		}
		public function draw(x:int, bmd:BitmapData):void{
			x -= sectionStart;
			if (x > sections[0].width) {
				// --- START NEXT SECTION
				sectionStart += sections.shift().width;
				
			} else if (x + bmd.width > sections[0].width && sections.length == 1) {
				// --- PREVIEW NEXT SECTION
			}
			var rect:Rectangle = bmd.rect.clone();
			rect.x = x;
			rect.y = 0;
			bmd.copyPixels(sections[0], rect, new Point());
		}
	}
}
import adobe.utils.CustomActions;
import data.Vec2;
import flash.geom.Point;
import flash.geom.Rectangle;
import data.Helpers;
import flash.display.BitmapData;

class Section extends BitmapData {
	static public const EDGE:int = 10,
						COLOR1:int = 0x00aeef,
						COLOR2:int = 0xFF0000;
	public var heightMap:Vector.<int>;
	private var bmd:BitmapData
	public function Section(tile:Rectangle, width:int, height:int, min:int, max:int, start:int) {
		var ceiling:Number = (1 + Helpers.random(4)) * tile.height;
		heightMap = new Vector.<int>(width / tile.width + 2);
		for (var i:String in heightMap) {
			
			heightMap[i] = ceiling;
			ceiling += Helpers.random( -tile.height, tile.height);
		}
		//heightMap[heightMap.length - 1] = height;
		super(width, height, false);
		
		lock();
		var p:Point = new Point();
		var buffer:Number, baseCeil:Number;
		var wall:Vec2 = new Vec2(tile.width);
		
		var dif:int = COLOR2 - COLOR1;
		var rgb:Vector.<int> = Vector.<int>([(dif & 0xFF0000) >> 16, (dif & 0xFF00) >> 8,  dif & 0xFF]);
		
		for (p.x = 0; p.x < width; p.x++) {
			if(p.x % tile.width == 0){
				baseCeil = heightMap[int(p.x / tile.width)];
				wall.y = heightMap[int(p.x / tile.height) + 1] - baseCeil;
				var edge:Vec2 = wall.lHand;
				edge.length = EDGE;
				
				buffer = edge.x * edge.x / edge.y + edge.y;
			}
			
			ceiling = baseCeil + (p.x % tile.width) / tile.width * (heightMap[int(p.x / tile.height)+1] - baseCeil);
			for (p.y = 0; p.y < ceiling; p.y++) {
				if(p.y < ceiling-buffer)
					setPixel(p.x, p.y, COLOR1);
				else if (p.y - 1 > ceiling - buffer)
					setPixel(p.x, p.y, COLOR2);
				else {
					var alias:Number = ceiling - buffer - p.y + 1;
					trace(((alias * rgb[0]) << 16) & ((alias * rgb[1]) << 8) & (alias * rgb[2]));
					setPixel(p.x, p.y, lerpColors(COLOR1, COLOR2, alias));
					//COLOR1+((alias * rgb[0]) << 16) | ((alias * rgb[1]) << 8) | (alias * rgb[2]));
				}
			}
		}
		unlock();	
	}
	private function lerpColors(c1:int, c2:int, t:Number):int{
		var dif:int = c2 - c1;
		var high:Boolean = dif < 0;
		if (!high) t *= -1;
		var difRGB:Vector.<int> = Vector.<int>([(dif & 0xFF0000) >> 16, (dif & 0xFF00) >> 8,  dif & 0xFF]);
		var base:int = high ? c1 : c2;
		var rgb:Vector.<int> = Vector.<int>([(base & 0xFF0000) >> 16, (base & 0xFF00) >> 8,  base & 0xFF]);
		rgb[0] += difRGB[0] * t;
		rgb[1] += difRGB[1] * t;
		rgb[2] += difRGB[2] * t;
		return rgb[0] << 16 | rgb[1] << 8 | rgb[2];
	}
	public function get last():int { return heightMap[heightMap.length - 1]; }
}