package relic.art {
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAnimated extends IDisplay{
		
		function hasAnimation(name:String):Boolean;
		
		function get defaultAnimation():String;
		function set defaultAnimation(value:String):void;
		
		function get currentAnimation():String;
		function set currentAnimation(value:String):void;
		
		function get frame():int;
		function set frame(value:int):void;
	}
	
}