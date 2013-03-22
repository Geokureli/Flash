package relic.art {
	import flash.events.IEventDispatcher;
	import flash.display.IBitmapDrawable;
	import relic.data.AssetManager;
	import relic.data.IAssetHolder;
	/**
	 * ...
	 * @author George
	 */
	public interface IScene extends IEventDispatcher, IBitmapDrawable, IAssetHolder{
		function destroy():void;
		
		function update():void;
		
		function get assets():AssetManager;
	}
	
}