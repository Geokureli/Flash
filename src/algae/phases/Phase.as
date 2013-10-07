package algae.phases {
	import algae.AlgaeMap;
	import algae.Quadrat;
	import krakel.KrkPhase;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class Phase extends KrkPhase {
		
		protected var hiliteMouseTile:Boolean;
		
		protected var mouseTileIndex:uint,
						mouseTile:uint;
		
		protected var title:String;
		
		protected var mouseTileCoords:FlxPoint;
		
		public function Phase(target:FlxBasic) {
			super(target);
			hiliteMouseTile = false;
			mouseTileCoords = new FlxPoint();
			title = "";
		}
		
		override public function update():void {
			super.update();
			
			mouseTileIndex = seaweed.indexAtPos(FlxG.mouse.x, FlxG.mouse.y);
			mouseTile = seaweed.getTileByIndex(mouseTileIndex);
			seaweed.getTileIndicesAtPos(FlxG.mouse.x, FlxG.mouse.y, mouseTileCoords);
			
			if (FlxG.mouse.justReleased())
				onTileClick();
		}
		
		protected function onTileClick():void {
			
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			titleText.text = title;
		}
		
		override public function destroy():void {
			super.destroy();
			title = null;
		}
		
		protected function get startingPlayer():uint { return quadrat.startingPlayer; }
		
		protected function get energy1():uint { return quadrat.energy1; }
		protected function set energy1(value:uint):void { quadrat.energy1 = value; }
		
		protected function get energy2():uint { return quadrat.energy2; }
		protected function set energy2(value:uint):void { quadrat.energy2 = value; }
		
		public function get titleText():FlxText { return quadrat.txt_phase; }
		public function get quadrat():Quadrat { return target as Quadrat; }
		public function get seaweed():AlgaeMap { return quadrat.seaweed; }
		public function get heightMap():FlxTilemap { return quadrat.heightMap; }
		public function get UIMap():FlxTilemap { return quadrat.UIMap; }
	}

}