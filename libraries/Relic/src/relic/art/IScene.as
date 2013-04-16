package relic.art {
	import flash.events.IEventDispatcher;
	import flash.display.IBitmapDrawable;
	import relic.Asset;
	import relic.AssetManager;
	import relic.IAssetHolder;
	/**
	 * ...
	 * @author George
	 */
	public interface IScene extends IEventDispatcher, IBitmapDrawable, IAssetHolder{
		function destroy():void;
		
		function update():void;
		
		function placeOnLayer(layer:Object, asset:Asset):Asset;
		
		function get assets():AssetManager;
	}
	
}