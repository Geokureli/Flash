package krakel {
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author George
	 */
	public class KrkSound extends FlxSound{
		static private var _enabled:Boolean = true;
		
		override public function play(ForceRestart:Boolean = false):void {
			if(_enabled) super.play(ForceRestart);
		}
		
		public function embed(embeddedSound:Class, looped:Boolean = false, autoDestroy:Boolean = false):KrkSound {
			return loadEmbedded(embeddedSound, looped, autoDestroy) as KrkSound;
		}
		
		public function get position():Number {
			if (_channel == null) return 0;
			return _channel.position;
		}
		public function set position(value:Number):void { _position = value; }
		
		static public function get enabled():Boolean { return _enabled; }
		static public function set enabled(value:Boolean):void { _enabled = value; }
		
	}

}