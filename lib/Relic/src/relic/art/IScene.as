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
	}
	
}