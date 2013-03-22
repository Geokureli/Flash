package relic.art {
	import flash.events.IEventDispatcher;
	import relic.data.shapes.Shape;
	import relic.data.xml.IXMLParam;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IDisplay extends IEventDispatcher, IXMLParam {
		
		function preUpdate():void;
		function update():void;
		function draw():void;
		
		function destroy():void;
		
		//
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/** The left collision bound of the asset. */
		function get left():Number;
		/** The right collision bound of the asset. */
		function get right():Number;
		/** The top collision bound of the asset. */
		function get top():Number;
		/** The bottom collision bound of the asset. */
		function get bottom():Number;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get shape():Shape;
		function set shape(value:Shape):void;
		
		function get asset():Asset;
		function set asset(value:Asset):void;
		
		function get needsRedraw():Boolean;
		
	}
	
}