package art 
{
	import audio.Note;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author George
	 */
	public class Synthesizer extends Bitmap 
	{
		private var activeNotes:Vector.<Note>;
		public function Synthesizer(width:int, height:int = 100) 
		{
			super(new BitmapData(width, height, false, 0));
			activeNotes = new Vector.<Note>();
		}
		public function play(note:Note):void{
			
		}
		public function stop(note:Note = null):void {
			if (note == null)
			{
				// --- STOP ALL
			}
			// --- REMOVE NOTE
		}
	}

}