package 
{
	import data.level.BGTile;
	import data.level.LevelData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite 
	{
		private static const tile:Rectangle = new Rectangle(0, 0, 40, 40);
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var level:LevelData = new LevelData(tile, stage.stageHeight);
			level.extend(stage.stageWidth, 0, 0);
			var bm:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false));
			level.draw(0, bm.bitmapData);
			addChild(bm);
			//addChild(new Bitmap(new BGTile(64, 64)));
		}
	}
}