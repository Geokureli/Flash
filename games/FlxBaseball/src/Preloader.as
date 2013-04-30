package  {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.utils.getQualifiedClassName;
	import krakel.ads.AdBox;
	import krakel.ads.FlxMochiBox;
	import krakel.ads.MochiBox;
	import mochi.as3.MochiServices;
	import org.flixel.FlxG;
	//import krakel.helpers.Random;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author George
	 */
	public dynamic class Preloader extends FlxPreloader {
		static public const MOCHI_ID:String = "9b3b1ff9c740acfd";
		static private const SHOW_AD:Boolean = true;
		private var loadBar:LoadBar;
		public function Preloader() {
			super();
			Mouse.show();
			className = "baseball.Main";
		}
		
		override protected function create():void {
			super.create();
			
			if (!FlxG.debug) {
				canExit = false;
				createAdBox();
				AdBox.showPreLoaderAd(onAdDone);
				MochiServices.connect(MOCHI_ID, this);
			}
        }
		
		public function createAdBox():void {
			addChild(new FlxMochiBox(MOCHI_ID));
		}
		
		private function onAdDone():void { canExit = true; }
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if (getQualifiedClassName(child) == className.replace('.', "::")) 
				return super.addChildAt(child, 0);
			
			else return super.addChild(child);
		}
		override protected function destroy():void {
			removeChild(_buffer);
			super.destroy();
		}
	}

}
import flash.display.Sprite;
class LoadBar extends Sprite {
	public function LoadBar(width:Number) {
		super();
		graphics.beginFill(0);
		graphics.drawRect(0, 0, width, 20);
		graphics.endFill();
	}
}