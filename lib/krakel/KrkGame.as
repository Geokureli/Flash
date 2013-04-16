package krakel {
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkGame extends FlxGame {
		/**
		 * @inheritDoc
		 */
		public function KrkGame(width:Number, height:Number, state:Class, zoom:Number = 1, gameFrameRate:uint = 60, flashFrameRate:uint = 30, useSystemCursor:Boolean = false) {
			super(width, height, state, zoom, gameFrameRate, flashFrameRate, useSystemCursor);
		}
		override protected function create(e:Event):void {
			super.create(e);
		}
		override protected function switchState():void {
			var prevState:FlxState = FlxG.state;
			super.switchState();
			if (prevState != null && FlxG.state is KrkState)
				(FlxG.state as KrkState).parentState = prevState;
			if(FlxG.debug) FlxG.mouse.show();
		}
		
	}

}