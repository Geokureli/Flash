package audio 
{
	/**
	 * ...
	 * @author George
	 */
	public class Note 
	{
		public var frequency:Number, fade:Number;
		public var volume:int;
		public function Note(freq:Number, volume:int, fade:Number = 1) 
		{
			frequency = freq;
			this.fade = fade;
			this.volume = volume;
		}
		
	}

}