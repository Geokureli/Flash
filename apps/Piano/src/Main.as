package 
{
	import art.Piano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite 
	{		
		private var sound:Sound;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var piano:Piano = new Piano(5);
			piano.x = (stage.stageWidth - piano.width) / 2;
			piano.y = (stage.stageHeight - piano.height) / 2;
			addChild(piano);
			var bytes:ByteArray = createBytes(440);
			sound = new Sound();
			sound.loadPCMFromByteArray(bytes, bytes.length/2);
			sound.play();
		}
		public function createBytes(freq:int):ByteArray {
			var bytes:ByteArray = new ByteArray();
			for(var i:int = 0; i < 4000; i++) {
				var phase:Number = i / 44100 * Math.PI * 2;
				var sample:Number = Math.sin(phase * freq);
				bytes.writeFloat(sample); // left
				bytes.writeFloat(sample); // right
			}
			return bytes;
		}
	}
}