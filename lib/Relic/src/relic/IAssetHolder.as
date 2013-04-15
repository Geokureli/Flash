package relic {
	import flash.display.Stage;
	import relic.Asset;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAssetHolder {
		function place(asset:Asset):Asset;
		function remove(asset:Asset):Asset;
		function get stage():Stage;
	}
	
}