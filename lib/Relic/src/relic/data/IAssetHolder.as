package relic.data {
	import flash.display.Stage;
	import relic.art.Asset;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAssetHolder {
		function place(asset:Asset, parent:Object = "front"):Asset
		function remove(asset:Asset):Asset;
		function get stage():Stage;
	}
	
}