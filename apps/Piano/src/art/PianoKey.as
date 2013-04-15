package art 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author George
	 */
	public class PianoKey extends Sprite 
	{
		static private var SAMPLE_RATE:int = 2048*2;
		static internal var WHITE_SIZE:Rectangle = new Rectangle(0, 0, 20, 120);
		static internal var BLACK_SIZE:Rectangle = new Rectangle(3, 0, 14, 80);
		
		
		static public const A4:int = 440;
							
		private var amp:Number,
					tone:Number;
		private var position:int,
					attack:int;
		
		private var black:Boolean, pressed:Boolean;
		
		private var sound:Sound;
		public function PianoKey(pitch:int, black:Boolean = false) 
		{
			sound = new Sound();
			tone = A4 * Math.pow(2, pitch / 12) / 2;
			this.black = black;
			attack = .001*SAMPLE_RATE;
			super();
			redraw(black ? 0 : 0xFFFFFF, black ? BLACK_SIZE : WHITE_SIZE);
		}
		protected function redraw(color:uint, rect:Rectangle):void {
			graphics.beginFill(color);
			graphics.lineStyle(1);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
		public function press():void {
			redraw(0x808080, black ? BLACK_SIZE : WHITE_SIZE);
			amp = 1;
			position = 0;
			pressed = true;
			
			if(!sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
				sound.addEventListener(SampleDataEvent.SAMPLE_DATA, getSamples);
			sound.play();
			
		}
		public function release():void {
			//sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, getSamples);
			redraw(black ? 0 : 0xFFFFFF, black? BLACK_SIZE : WHITE_SIZE);
			pressed = false;
		}
		private function getSamples(e:SampleDataEvent):void {
			var gain:Number = position / attack;
			var fade:Number = Math.pow(pressed ? .9 : .6, 1/SAMPLE_RATE);
			for(var i:int = 0; i < SAMPLE_RATE; i++)
			{
				var phase:Number = position / 44100 * Math.PI * 2;
				var sample:Number = Math.sin(phase * tone)*amp;
				if (position < attack) sample *= gain;
				else amp *= fade;
				if (amp < 0.01){
					sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, getSamples);
				}
				e.data.writeFloat(sample); // left
				e.data.writeFloat(sample); // right
				position ++;
			}
		}
	}

}