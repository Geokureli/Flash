package music {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "600", height = "400", backgroundColor = "#FFFFFF", frameRate = "30")]
	public class Main extends Sprite {
		
		public var needle:Needle;
		public var wheel:Wheel;
		public var spectrum:Spectrum;
		
		private var mic:Microphone;
		
		private var isPlaying:Boolean;
		private var sound:Sound;
		private var micBytes:ByteArray;
		
		
		public function Main() {
			super();
			
			addChild(wheel = new Wheel());
			addChild(needle = new Needle());
			addChild(spectrum = new Spectrum());
			
			needle.x = wheel.x = stage.stageWidth / 2;
			spectrum.y = needle.y = wheel.y = stage.stageHeight / 2;
			
			mic = Microphone.getMicrophone();
			
			if (mic != null) {
				mic.addEventListener(SampleDataEvent.SAMPLE_DATA, soundIn);
				mic.addEventListener(ActivityEvent.ACTIVITY, micState);
			}
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			sound = new Sound();
			//sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundOut);
		}
		
		private function micState(e:ActivityEvent):void {
			if(!e.activating) {
				spectrum.graphics.clear();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			//var bytes:ByteArray = new ByteArray();
			//SoundMixer.computeSpectrum(bytes);
            //spectrum.drawChannel(bytes);
			
		}
		
		private function soundIn(e:SampleDataEvent):void {
			isPlaying = true;
			//while(e.data.bytesAvailable){
				//var sample:Number = e.readFloat();
				//micBytes.writeFloat(sample);
			//}
			spectrum.drawChannel(e.data);
			//sound.play();
			//trace("play");
		}
		
		private function soundOut(e:SampleDataEvent):void {
			for (var i:int = 0; i < 8192 && micBytes.bytesAvailable > 0; i++) {
				var sample:Number = micBytes.readFloat();
				e.data.writeFloat(sample);
				e.data.writeFloat(sample);
			}
		}
	}

}
import flash.display.Shape;
import flash.display.Sprite;
import flash.utils.ByteArray;
import music.fft.FFT;

class Spectrum extends Shape {
	
	static private const PLOT_HEIGHT:int = 150;
	static private const CHANNEL_LENGTH:int = 256;
	private var fft:FFT;
	
	public function Spectrum() {
		fft = new FFT();
		fft.init(8);
	}
	
	public function drawChannel(bytes:ByteArray):void {
		graphics.clear();
			
		graphics.lineStyle(0, 0x6600CC);
		graphics.beginFill(0x6600CC);
		graphics.moveTo(0, 0);
		
		var tones:Vector.<Number> = fft.runBytes(bytes);
		var halfLength:int = tones.length / 2;
		for (var i:int = 0; i < tones.length; i++)
			graphics.lineTo(i * 2, tones[i] * PLOT_HEIGHT);
		
		graphics.lineTo(CHANNEL_LENGTH * 2, 0);
		graphics.endFill();
	}
}

class Wheel extends Sprite {
	
	public var radius:Number;
	
	public function Wheel(radius:Number = 100) {
		super();
		
		this.radius = radius;
		
		graphics.lineStyle(1);
		graphics.drawCircle(0, 0, radius)
		
		var a:Number;
		for (var i:int = 0; i < 6; i++) {
			a = i / 12 * Math.PI * 2;
			graphics.moveTo(Math.cos(a)*100, Math.sin(a)*100);
			graphics.lineTo(Math.cos(a)*75, Math.sin(a)*75);
			graphics.moveTo(-Math.cos(a)*100, -Math.sin(a)*100);
			graphics.lineTo(-Math.cos(a)*75, -Math.sin(a)*75);
		}
	}
}

class Needle extends Sprite {
	public var length:Number;
	public function Needle(length:Number = 125) {
		this.length = length;
		graphics.lineStyle(3);
		graphics.moveTo(0, 0);
		graphics.lineTo(length, 0);
	}
}