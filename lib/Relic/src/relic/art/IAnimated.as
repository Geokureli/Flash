package relic.art {
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAnimated {
		
		function get currentAnimation():String;
		function set currentAnimation(value:String):void;
		
		function get frame():int;
		function set frame(value:int):void;
	}
	
}