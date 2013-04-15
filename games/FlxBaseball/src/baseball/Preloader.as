package baseball {
	import flash.display.Sprite;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author George
	 */
	public class Preloader extends FlxPreloader {
		public function Preloader() {
			super();
			className = "baseball.Main";
		}
		override protected function create():void {
			_buffer = new Sprite();
			addChild(_buffer);
			//Add stuff to the buffer...
		}
		override protected function update(Percent:Number):void {
			//Update the graphics...
		}
	}

}