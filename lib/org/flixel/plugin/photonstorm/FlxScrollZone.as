/**
 * FlxScrollZone
 * -- Part of the Flixel Power Tools set
 * 
 * v1.4 Added "clearRegion" support for when you use Sprites with transparency and renamed parameter to onlyScrollOnscreen
 * v1.3 Swapped plugin update for draw, now smoother / faster in some fps cases
 * v1.2 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.4 - May 16th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm. My thanks to Ralph Hauwert for help with this.
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.flixel.*;
	
	/**
	 * FlxScrollZone allows you to scroll the content of an FlxSprites bitmapData in any direction you like.
	 */
	public class FlxScrollZone extends FlxBasic
	{
		private static var members:Dictionary = new Dictionary(true);
		private static var zeroPoint:Point = new Point;
		
		public function FlxScrollZone() 
		{
		}
		
		/**
		 * Add an FlxSprite to the Scroll Manager, setting up one scrolling region. <br />
		 * To add extra scrolling regions on the same sprite use addZone()
		 * 
		 * @param	source				The FlxSprite to apply the scroll to
		 * @param	region				The region, specified as a Rectangle, of the FlxSprite that you wish to scroll
		 * @param	distanceX			The distance in pixels you want to scroll on the X axis. Negative values scroll left. Positive scroll right. Floats allowed (0.5 would scroll at half speed)
		 * @param	distanceY			The distance in pixels you want to scroll on the Y axis. Negative values scroll up. Positive scroll down. Floats allowed (0.5 would scroll at half speed)
		 * @param	onlyScrollOnscreen	Only update this FlxSprite if visible onScreen (default true) Saves performance by not scrolling offscreen sprites, but this isn't always desirable
		 * @param	clearRegion			Set to true if you want to clear the scrolling area of the FlxSprite with a 100% transparent fill before applying the scroll texture (default false)
		 * @see		createZone
		 */
		public static function add(source:FlxSprite, region:Rectangle, distanceX:Number, distanceY:Number, onlyScrollOnscreen:Boolean = true, clearRegion:Boolean = false):void
		{
			if (members[source])
			{
				throw Error("FlxSprite already exists in FlxScrollZone, use addZone to add a new scrolling region to an already added FlxSprite");
			}
			
			var data:ScrollSprite = new ScrollSprite();
			
			data.source = source;
			data.scrolling = true;
			data.onlyScrollOnscreen = onlyScrollOnscreen;
			data.zones = new Vector.<Zone>();
			
			members[source] = data;
			
			//createZone(source, region, distanceX, distanceY, clearRegion);
		}
		
		/**
		 * Creates a new scrolling region to an FlxSprite already in the Scroll Manager (see add())<br />
		 * 
		 * @param	source				The FlxSprite to apply the scroll to
		 * @param	region				The region, specified as a Rectangle, of the FlxSprite that you wish to scroll
		 * @param	distanceX			The distance in pixels you want to scroll on the X axis. Negative values scroll left. Positive scroll right. Floats allowed (0.5 would scroll at half speed)
		 * @param	distanceY			The distance in pixels you want to scroll on the Y axis. Negative values scroll up. Positive scroll down. Floats allowed (0.5 would scroll at half speed)
		 * @param	clearRegion			Set to true if you want to fill the scroll region of the FlxSprite with a 100% transparent fill before scrolling it (default false)
		 */
		public static function createZone(source:FlxSprite, region:Rectangle, distanceX:Number, distanceY:Number, clearRegion:Boolean = false):void
		{
			var texture:BitmapData = new BitmapData(region.width, region.height, true, 0x00000000);
			texture.copyPixels(source.framePixels, region, zeroPoint, null, null, true);
			
			var data:Zone = new Zone();
			
			data.buffer = new Sprite;
			data.texture = texture;
			data.region = region;
			data.clearRegion = clearRegion;
			data.distanceX = distanceX;
			data.distanceY = distanceY;
			data.scrollMatrix = new Matrix();
			data.drawMatrix = new Matrix(1, 0, 0, 1, region.x, region.y);
			
			members[source].zones.push(data);
		}
		
		/**
		 * Sets the draw Matrix for the given FlxSprite scroll zone<br />
		 * Warning: Modify this at your own risk!
		 * 
		 * @param	source		The FlxSprite to set the draw matrix on
		 * @param	matrix		The Matrix to use during the scroll update draw 
		 * @param	zone		If the FlxSprite has more than 1 scrolling zone, use this to target which zone to apply the update to (default 0)
		 * @return	Matrix		The draw matrix used in the scroll update
		 */
		public static function updateDrawMatrix(source:FlxSprite, matrix:Matrix, zone:int = 0):void
		{
			members[source].zones[zone].drawMatrix = matrix;
		}
		
		/**
		 * Returns the draw Matrix for the given FlxSprite scroll zone
		 * 
		 * @param	source		The FlxSprite to get the draw matrix from
		 * @param	zone		If the FlxSprite has more than 1 scrolling zone, use this to target which zone to apply the update to (default 0)
		 * @return	Matrix		The draw matrix used in the scroll update
		 */
		public static function getDrawMatrix(source:FlxSprite, zone:int = 0):Matrix
		{
			return members[source].zones[zone].drawMatrix;
		}
		
		/**
		 * Removes an FlxSprite and all of its scrolling zones. Note that it doesn't restore the sprite bitmapData.
		 * 
		 * @param	source	The FlxSprite to remove all scrolling zones for.
		 * @return	Boolean	true if the FlxSprite was removed, otherwise false.
		 */
		public static function remove(source:FlxSprite):Boolean
		{
			if (members[source])
			{
				delete members[source];
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes all FlxSprites, and all of their scrolling zones.<br />
		 * This is called automatically if the plugin is ever destroyed.
		 */
		public static function clear():void
		{
			for each (var obj:ScrollSprite in members)
			{
				members[obj.source].destroy();
				delete members[obj.source];
			}
		}
		
		/**
		 * Update the distance in pixels to scroll on the X axis.
		 * 
		 * @param	source		The FlxSprite to apply the scroll to
		 * @param	distanceX	The distance in pixels you want to scroll on the X axis. Negative values scroll left. Positive scroll right. Floats allowed (0.5 would scroll at half speed)
		 * @param	zone		If the FlxSprite has more than 1 scrolling zone, use this to target which zone to apply the update to (default 0)
		 */
		public static function updateX(source:FlxSprite, distanceX:Number, zone:int = 0):void
		{
			members[source].zones[zone].distanceX = distanceX;
		}
		
		/**
		 * Update the distance in pixels to scroll on the X axis.
		 * 
		 * @param	source		The FlxSprite to apply the scroll to
		 * @param	distanceY	The distance in pixels you want to scroll on the Y axis. Negative values scroll up. Positive scroll down. Floats allowed (0.5 would scroll at half speed)
		 * @param	zone		If the FlxSprite has more than 1 scrolling zone, use this to target which zone to apply the update to (default 0)
		 */
		public static function updateY(source:FlxSprite, distanceY:Number, zone:int = 0):void
		{
			members[source].zones[zone].distanceY = distanceY;
		}
		
		/**
		 * Starts scrolling on the given FlxSprite. If no FlxSprite is given it starts scrolling on all FlxSprites currently added.<br />
		 * Scrolling is enabled by default, but this can be used to re-start it if you have stopped it via stopScrolling.<br />
		 * 
		 * @param	source	The FlxSprite to start scrolling on. If left as null it will start scrolling on all sprites.
		 */
		public static function startScrolling(source:FlxSprite = null):void
		{
			if (source)
			{
				members[source].scrolling = true;
			}
			else
			{
				for each (var obj:Object in members)
				{
					obj.scrolling = true;
				}
			}
		}
		
		public static function setScroll(source:FlxSprite, zone:int, distanceX:Number, distanceY:Number):void {
			members[source].zones[zone].distanceX = distanceX;
			members[source].zones[zone].distanceY = distanceY;
		}
		/**
		 * Stops scrolling on the given FlxSprite. If no FlxSprite is given it stops scrolling on all FlxSprites currently added.<br />
		 * Scrolling is enabled by default, but this can be used to stop it.<br />
		 * 
		 * @param	source	The FlxSprite to stop scrolling on. If left as null it will stop scrolling on all sprites.
		 */
		public static function stopScrolling(source:FlxSprite = null):void
		{
			if (source)
			{
				members[source].scrolling = false;
			}
			else
			{
				for each (var obj:Object in members)
				{
					obj.scrolling = false;
				}
			}
		}
		
		override public function draw():void
		{
			for each (var obj:ScrollSprite in members)
			{
				obj.scroll();
			}
		}
		
		override public function destroy():void
		{
			clear();
		}
		
	}

}
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import org.flixel.FlxSprite;

class ScrollSprite {
	public var source:FlxSprite;
	public var scrolling:Boolean;
	public var onlyScrollOnscreen:Boolean;
	public var zones:Vector.<Zone>;
	public function ScrollSprite() { }
	public function scroll():void {
		if (onlyScrollOnscreen && source.onScreen() && scrolling && source.exists) {
			
			for each (var zone:Zone in zones)
				zone.scroll(this);
			
			source.dirty = true;
		}
	}
	
	public function destroy():void {
		while (zones.length > 0)
			zones.pop().destroy();
	}
}

class Zone {
	public var buffer:Sprite;
	public var texture:BitmapData;
	public var region:Rectangle;
	public var clearRegion:Boolean;
	public var distanceX:Number;
	public var distanceY:Number;
	public var scrollMatrix:Matrix;
	public var drawMatrix:Matrix;
	
	public function Zone() { }
	public function scroll(data:ScrollSprite):void {
		scrollMatrix.tx += distanceX;
		scrollMatrix.ty += distanceY;
		// George bug fix
		scrollMatrix.tx %= region.width;
		scrollMatrix.ty %= region.height;
		
		buffer.graphics.clear();
		buffer.graphics.beginBitmapFill(texture, scrollMatrix, true, false);
		buffer.graphics.drawRect(0, 0, region.width, region.height);
		buffer.graphics.endFill();
		
		
		if (clearRegion){
			data.source.pixels.fillRect(region, 0x0);
		}
		
		data.source.pixels.draw(buffer, drawMatrix);
	}
	
	public function destroy():void {
		scrollMatrix = null;
		drawMatrix = null;
		buffer = null;
		texture = null;
		region = null;
	}
}