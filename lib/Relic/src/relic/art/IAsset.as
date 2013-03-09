package relic.art {
	import flash.geom.Rectangle;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAsset {
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function get height():Number;
		
		function get left():Number;
		function set left(value:Number):void;
		
		function get right():Number;
		function set right(value:Number):void;
		
		function get top():Number;
		function set top(value:Number):void;
		
		function get bottom():Number;
		function set bottom(value:Number):void;
		
		function get name():String;
		function set name(value:String):void;
		
		function get anim():Animation
		
		function get currentAnimation():String;
		function set currentAnimation(value:String):void;
		
		function get boundMode():String;
		function set boundMode(value:String):void;
				
		function get shape():Shape;
		function set shape(value:Shape):void;
		
		function get spawned():Boolean;
		function set spawned(value:Boolean):void;
		
		function get trash():Boolean;
		function set trash(value:Boolean):void;
		
		function get live():Boolean;
		function set live(value:Boolean):void;
		
		function get vel():Vec2;
		function set vel(value:Vec2):void;
		
		function get acc():Vec2;
		function set acc(value:Vec2):void;
		
		function get maxSpeed():Vec2;
		function set maxSpeed(value:Vec2):void;
		
		function get friction():Number;
		function set friction(value:Number):void;
		
		function get bounce():Number;
		function set bounce(value:Number):void;
		
		function get bounds():Rectangle;
		function set bounds(value:Rectangle):void;
		
		function update():void
		function isTouching(asset:IAsset):Boolean;
		
		function kill():void;
		function destroy():void;
	}
	
}