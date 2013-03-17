package relic.art {
	import flash.events.IEventDispatcher;
	import flash.display.IBitmapDrawable;
	/**
	 * ...
	 * @author George
	 */
	public interface IScene extends IEventDispatcher, IBitmapDrawable{
		function destroy():void;
		
		function update():void;
		
		function place(parent:Object, asset:Object, params:Object = null):Asset;
		
		function add(asset:Asset, name:String = null, groups:String = null):Asset;
	}
	
}