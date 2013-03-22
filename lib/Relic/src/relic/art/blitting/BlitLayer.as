package relic.art.blitting 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import relic.art.Asset;
	import relic.data.Asset2;
	import relic.data.IAssetHolder;
	/**
	 * ...
	 * @author George
	 */
	public class BlitLayer implements IAssetHolder {
		internal var parent:Blitmap;
		internal var children:Vector.<Asset>;
		public function BlitLayer() {
			children = new Vector.<Asset>();
		}
		public function place(asset:Asset, parent:Object = "front"):Asset {
			if (asset.parent)
				asset.parent.remove(asset);
			children.push(asset);
			asset.parent = this;
			var e:Event = new Event(Event.ADDED_TO_STAGE);
			asset.dispatchEvent(e);
			if(asset.graphic != null)
				asset.graphic.dispatchEvent(e);
			return asset;
		}
		
		public function remove(asset:Asset):Asset {
			var i:int = children.indexOf(asset);
			if (i == -1) return asset;
			children.splice(i, 1);
			asset.parent = null;
			var e:Event = new Event(Event.REMOVED_FROM_STAGE);
			asset.dispatchEvent(e);
			if(asset.graphic != null)
				asset.graphic.dispatchEvent(e);
			return asset;
		}
		
		public function destroy():void {
			while (children.length > 0)
				remove(children.shift());
			children = null;
			parent = null;
		}
		
		public function get stage():Stage { return parent.stage; }
	}

}