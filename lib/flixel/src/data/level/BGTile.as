package data.level {
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import data.Helpers;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	/**
	 * ...
	 * @author George
	 */
	public class BGTile extends BitmapData {
		private static const BUFFER:int = 8;
		private static const POINT:Point = new Point();
		public function BGTile(width:int, height:int) {
			super(width, height*2, true, 0xFF000000);
			var source:BitmapData = new PerlinTile(width, height, BUFFER);
			var pnt:Point = new Point(0, height);
			var hist:Vector.<Number> = source.histogram()[3];
			var dSet:DataSet = new DataSet(hist);
			trace(dSet.quartiles)
			copyPixels(source, source.rect, POINT);
			threshold(source, rect, pnt, ">=", dSet.quartiles[1] << 24, 0xFFA0A0A0, 0xff000000);
			threshold(source, rect, pnt, "<", dSet.quartiles[1] << 24, 0xFF808080, 0xff000000);
			threshold(source, rect, pnt, ">", dSet.quartiles[2] << 24, 0xFFD0D0D0, 0xff000000);
			threshold(source, rect, pnt, "<", dSet.quartiles[0] << 24, 0xFF606060, 0xff000000);
			source.dispose();
		}
		
	}
}
import flash.display.BitmapData;
import data.Helpers;
import flash.display.BitmapDataChannel;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
class PerlinTile extends BitmapData{
	public function PerlinTile(width:int, height:int, buffer:int) {
		super(width, height, true);
		perlinNoise(width, height, 4, Helpers.random(20), true, true, BitmapDataChannel.ALPHA);
		
		var color:int = 0x80000000;
		var rect:Rectangle = new Rectangle(0, 0, width, buffer);
		fillRect(rect, color);
		rect.y = height-buffer;
		fillRect(rect, color);
		rect = new Rectangle(0, 0, buffer, height);
		fillRect(rect, color);
		rect.x = width-buffer;
		fillRect(rect, color);
		
		applyFilter(this, this.rect, new Point(), new BlurFilter(buffer, buffer, 3));
	}
}
class DataSet {
	public var quartiles:Vector.<int>;
	public var min:int, max:int,
		totalPts:int, mean:int, mode:int, sum:int;
	public function DataSet(nums:Vector.<Number>) {
		min = -1;
		quartiles = new Vector.<int>(3);
		var highest:int = 0;
		for (var i:int = 0; i < nums.length / length; i++) {
			totalPts += nums[i];
			sum += i * nums[i];
			if (nums[i] > 0 && min < 0) min = i;
			if (nums[i] > 0) max = i;
			if (nums[i] > highest) {
				mean = i;
				highest = nums[i];
			}
		}
		mean = sum / totalPts;
		var count:Number = totalPts / 4;
		var Q:int = 0;
		for (i = 0; i < nums.length; i++) {
			count -= nums[i];
			if (count <= 0) {
				quartiles[Q++] = i;
				count += totalPts / 4;
				if (Q == 3) break;
			}
		}
	}
}