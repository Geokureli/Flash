package relic.art 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import relic.data.IAssetHolder;
	
	/**
	 * ...
	 * @author George
	 */
	public class Layer extends Sprite implements IAssetHolder {
		
		public function Layer() { super(); }
		public function destroy():void { }
		
		/* INTERFACE relic.data.IAssetHolder */
		
		public function place(asset:Asset, parent:Object = "front"):Asset {
			return addChild(asset.graphic as DisplayObject) as Asset;
		}
		
		public function remove(asset:Asset):Asset {
			return removeChild(asset.graphic as DisplayObject) as Asset;
		}
		
	}

}