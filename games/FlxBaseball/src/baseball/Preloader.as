package baseball {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import krakel.helpers.Random;
	import mochi.as3.MochiAd;
	import org.flixel.FlxG;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author George
	 */
	public class Preloader extends FlxPreloader {
		static private const SHOW_AD:Boolean = true;
		private var loadBar:LoadBar;
		private var adBox:MovieClip;
		public function Preloader() {
			super();
			className = "baseball.Main";
			
			//if(!FlxG.debug) _min = 10000;
		}
		override protected function create():void {
			_buffer = new MovieClip();
			addChild(_buffer);
			_buffer.addChild(loadBar = new LoadBar(stage.stageWidth * .75));
			_buffer.addChild(adBox = new MovieClip());
			
			loadBar.x = (stage.stageWidth - loadBar.width)/2;
			loadBar.y = stage.stageHeight - loadBar.height - 10;
			MochiAd.showPreGameAd( {
				clip:_buffer,
				id:"9b3b1ff9c740acfd",
				res:stage.stageWidth + "x" + stage.stageHeight, ad_finished: MochiAdComplete} );
        }
		
        private function MochiAdComplete():void
        {
            /*
                Ad finished, load the Flex application by
                dispatching Event.COMPLETE
            */
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
		
		override protected function update(percent:Number):void {
			if(Random.bool(.25))
				loadBar.scaleX = percent;
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