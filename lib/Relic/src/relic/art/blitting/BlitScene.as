package relic.art.blitting {
	import flash.display.BitmapData;
	import flash.events.Event;
	import relic.art.IScene;
	
	/**
	 * ...
	 * @author George
	 */
	public class BlitScene extends Blitmap implements IScene {
		
		protected var defaultUpdate:Function;
		
		public function BlitScene(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) {
			super(bitmapData, pixelSnapping, smoothing);
		}
		override protected function init(e:Event):void {
			super.init(e);
			
			createLayers();
			addStaticChildren();
		}
		
		/** Called automatically by constructor
		 * Override this to create custom layers, you do not have to call super.
		 * super will create a back, mid, and front layer. After this method is finished
		 * (whether super is called or not) a draw layer will be added to the front
		 */
		protected function createLayers():void {
			addLayer("back");
			addLayer("mid");
			addLayer("front");
		}
		
		/** Called automatically by constructor
		 * 
		 */
		protected function addStaticChildren():void { }
		
		override public function update():void {
			super.update();
			if (defaultUpdate != null) defaultUpdate();
		}
	}

}