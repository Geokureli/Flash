package puzzle {
	import krakel.KrkGame;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "360", height = "640", backgroundColor = "#000000", frameRate = "30")]
	public class GridGame extends KrkGame {
		
		public function GridGame() {
			super(180, 320, GameState, 2);
			
		}
		
	}

}
import com.greensock.TweenMax;
import flash.geom.Point;
import krakel.helpers.Random;
import krakel.KrkButton;
import krakel.KrkGameState;
import krakel.KrkGroup;
import krakel.KrkSprite;
import org.flixel.FlxPoint;
class GameState extends KrkGameState {
	
	
	override protected function addFG():void {
		super.addFG();
		add(new AssetGrid(7, 13, AssetTile.WIDTH + AssetGrid.GAP, AssetTile.HEIGHT + AssetGrid.GAP));
		//(add(new KrkSprite(45,80)) as KrkSprite).makeGraphic(90, 160, 0x);
	}
}
class AssetGrid extends KrkGroup {
	
	static public const GAP:int = 5
	
	private var rows:uint;
	private var columns:uint;
	
	private var selectedIndex:int;
	private var assetList:Vector.<AssetTile>;
	
	public function AssetGrid(columns:uint, rows:uint, spacingX:int, spacingY:int) {
		
		super();
		
		this.columns = columns;
		this.rows = rows;
		
		selectedIndex = -1;
		
		assetList = new <AssetTile>[];
		
		var index:int = 0;
		for (var j:int = 0; j < rows; j++) {
			for (var i:int = 0; i < columns; i++) {
				
				var asset:AssetTile = new AssetTile(i * spacingX, j * spacingY, index, Random.between(0xff000000, 0xffffffff));
				asset.onDown = function ():void { onAssetClick(asset); };
				assetList.push(asset);
				add(asset);
				
				index++;
			}
		}
	}
	
	// --- --- --- 
	
	private function onAssetClick(asset:AssetTile):void {
		trace(asset, selectedIndex, asset.tileIndex);
		if (selectedIndex >= 0) {
			var dif:Point = getIndices(asset.tileIndex).subtract(getIndices(selectedIndex));
			if (dif.length < Math.SQRT2) {
				var selectedAsset:AssetTile = assetList[selectedIndex];
				TweenMax.to(selectedAsset, 1, { x:asset.x, y:asset.y } );
				TweenMax.to(asset, 1, { x:selectedAsset.x, y:selectedAsset.y } );
				selectedIndex = -1;
			}
		} else {
			selectedIndex = asset.tileIndex;
		}
	}
	
	public function getIndices(index:uint) :Point {
		return new Point(index % columns, int(index / columns));
	}
}

class AssetTile extends KrkButton {
	
	
	static public const WIDTH:int = 20;
	static public const HEIGHT:int = 20;
	
	public var tileIndex:uint;
	
	public function AssetTile(x:int, y:int, index:uint, color:uint) {
		
		super(x, y)
		
		tileIndex = index;
		
		makeGraphic(WIDTH, HEIGHT, color);
	}
}