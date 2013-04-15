package relic.art {
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import relic.Asset;
	import relic.shapes.Shape;
	import relic.xml.IXMLParam;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IDisplay extends IEventDispatcher, IXMLParam {
		
		function preUpdate():void;
		function update():void;
		function draw():void;
		
		function drawRect(dest:Point, isGraphic:Boolean = false):void;
		
		function destroy():void;
		
		
		function get tileMap():Array;
		function set tileMap(value:Array):void;
		
		function get debugDraw():Boolean;
		function set debugDraw(value:Boolean):void;
		
		function get child():IBitmapDrawable;
		function set child(value:IBitmapDrawable):void;
		
		function get align():String;
		function set align(value:String):void;
		
		function get stretchMode():String;
		function set stretchMode(value:String):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get shape():Shape;
		function set shape(value:Shape):void;
		
		function get asset():Asset;
		function set asset(value:Asset):void;
		
		function get needsRedraw():Boolean;
		
		function get back():IBitmapDrawable;
		function set back(value:IBitmapDrawable):void;
		
		//
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get parallaxX():Number;
		function set parallaxX(value:Number):void;
		
		function get parallaxY():Number;
		function set parallaxY(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get columns():int;
		function set columns(value:int):void;
		
		function get rows():int;
		function set rows(value:int):void;
		
		/** The left collision bound of the asset. */
		function get left():Number;
		/** The right collision bound of the asset. */
		function get right():Number;
		/** The top collision bound of the asset. */
		function get top():Number;
		/** The bottom collision bound of the asset. */
		function get bottom():Number;
		
		function get color():uint;
		function set color(value:uint):void;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
	}
	
}