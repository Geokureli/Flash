package relic.art {
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import relic.data.shapes.Shape;
	import relic.data.Vec2;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IAsset extends IEventDispatcher {
		
		/** Adds all of the animations from the target SpriteSheet. */
		function addAnimationSet(sheet:SpriteSheet):void;
		
		function update():void;
		
		function isTouching(asset:IAsset):Boolean;
		
		/** Allows the object to be garbage collected */
		function kill():void;
		
		/** Removes all references in the object */
		function destroy():void;
		
		// --- --- --- --- GETTERS / SETTERS --- --- --- ---
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function get height():Number;
		
		/** The left collision bound of the object. */
		function get left():Number;
		function set left(value:Number):void;
		
		/** The right collision bound of the object. */
		function get right():Number;
		function set right(value:Number):void;
		
		/** The top collision bound of the object. */
		function get top():Number;
		function set top(value:Number):void;
		
		/** The bottom collision bound of the object. */
		function get bottom():Number;
		function set bottom(value:Number):void;
		
		/** The name of the object. */
		function get name():String;
		function set name(value:String):void;

		/** The currently playing animation. */		
		function get anim():Animation;
		
		/** The frame currently being displayed */
		function get frame():BitmapData;
		
		/** The name of the current animation. */
		function get currentAnimation():String;
		function set currentAnimation(value:String):void;
		
		/** The collision shape of the object. */
		function get shape():Shape;
		function set shape(value:Shape):void;
		
		/** The blit's graphic shape. Used to tell if it's on screen. */
		function get graphicBounds():Shape;
		function set graphicBounds(value:Shape):void;
		
		/** The bounds of the object. */
		function get bounds():Rectangle;
		function set bounds(value:Rectangle):void;
		
		/** True once the object enters the bounds. */
		function get boundMode():String;
		function set boundMode(value:String):void;
		
		/** True once the object enters the bounds. */
		function get spawned():Boolean;
		function set spawned(value:Boolean):void;
		
		/** Used internally for garbage collection. */
		function get trash():Boolean;
		function set trash(value:Boolean):void;
		
		/** If true, the containing AssetManager will automatically call update. */
		function get live():Boolean;
		function set live(value:Boolean):void;
		
		/** The velocity of the asset. */
		function get vel():Vec2;
		function set vel(value:Vec2):void;
		
		/** The acceloration of the asset. */
		function get acc():Vec2;
		function set acc(value:Vec2):void;
		
		/** If -1, than ignored, otherwise caps velocity (positive and negative). */
		function get maxSpeed():Vec2;
		function set maxSpeed(value:Vec2):void;
		
		/** The blit's friction (0 = no friction). */
		function get friction():Number;
		function set friction(value:Number):void;
		
		/** The elasticity of the asset, a ball will a bounce of .5 will bounce half as high. */
		function get bounce():Number;
		function set bounce(value:Number):void;
		
	}
	
}