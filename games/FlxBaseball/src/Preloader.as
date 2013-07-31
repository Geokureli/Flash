package  {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.utils.getQualifiedClassName;
	import krakel.ads.AdBox;
	import krakel.ads.FlxMochiBox;
	import krakel.ads.HighScore;
	import krakel.ads.MochiBox;
	import mochi.as3.MochiServices;
	import org.flixel.FlxG;
	import rawr.BorderMaker;
	//import krakel.helpers.Random;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author George
	 */
	public dynamic class Preloader extends FlxPreloader {
		
		[Embed(source = "../res/sprites/loading_bar.png")] static public const LOAD_BAR:Class;
		[Embed(source = "../res/sprites/loadingscreen.png")] static public const LOAD_SCREEN:Class;
		
		static public const MOCHI_ID:String = "9b3b1ff9c740acfd";
		static private const SHOW_AD:Boolean = true;
		
		private var loadBar:Bitmap,
					loadScreen:Bitmap;
		
		public var hiScore:HighScore;
		
		public function Preloader() {
			super();
			Mouse.show();
			className = "baseball.Main";
		}
		
		override protected function create():void {
			super.create();
			
			//_min = 10000;
			
			createLoaderGraphics();
			
			if (!FlxG.debug) {
				canExit = false;
				createAdBox();
				createHiScore();
				//AdBox.showPreLoaderAd(onAdDone);
				//MochiServices.connect(MOCHI_ID, this);
			}
        }
		
		protected function createLoaderGraphics():void {
			removeChild(_buffer);
			_buffer = new Sprite();
			addChild(_buffer);
			
			_buffer.scaleX = _buffer.scaleY = 2;
			
			_buffer.addChild(loadBar = new LOAD_BAR());
			_buffer.addChild(loadScreen = new LOAD_SCREEN());
			
			var loaderMask:Shape = new Shape();
			_buffer.addChild(loadBar.mask = loaderMask);
			loaderMask.graphics.beginFill(0);
			loaderMask.graphics.drawRect(0, 8, 200, 26);
			loaderMask.graphics.endFill();
			loaderMask.x += 50;
		}
		
		protected function createHiScore():void { }
		
		public function createAdBox():void {
			addChild(new FlxMochiBox(MOCHI_ID));
		}
		
		private function onAdDone():void { canExit = true; }
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if (getQualifiedClassName(child) == className.replace('.', "::")) 
				return super.addChildAt(child, 0);
			
			else return super.addChild(child);
		}
		
		override protected function update(percent:Number):void {
			//super.update(Percent);
			
			loadBar.mask.scaleX = percent;
			
			trace("update:" + percent);
			
		}
		
		override protected function destroy():void {
			removeChild(_buffer);
			super.destroy();
			AdBox.cleanAds();
		}
	}

}