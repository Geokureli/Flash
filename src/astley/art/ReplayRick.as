package astley.art {
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxReplay;
	/**
	 * ...
	 * @author George
	 */
	public class ReplayRick extends Rick {
		
		public var startTime:int;
		
		private var _replay:FlxReplay;
		
		public function ReplayRick(x:int, y:int, replayData:String) {
			super(x, y);
			
			_recorder = null;
			
			_replay = new FlxReplay();
			_replay.load(replayData);
		}
		
		override public function update():void {
			
			if (!onScreen())
				exists = visible = false;
				
			if (!moves || !exists) return;
			
			// --- PLAY RECORDING UNTIL RICK HITS HIS DESIRED X.
			do {
				_replay.playNextFrame();
				
				super.update();
				
				// --- STOP WHEN UP TO SPEED
				if(_replay.frame < startTime)
					updateMotion();
				
			} while (_replay.frame < startTime)
			
			FlxG.resetInput();
		}
		override public function start():void {
			if (startTime >= _replay.frameCount)
			{
				startTime = 0;
			}
			
			super.start();
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			_replay.rewind();
		}
		
		public function timedStart(timer:FlxTimer):void {
			
			start();
		}
		
		public function get replayFinished():Boolean {
			
			return _replay.frameCount - _replay.frame < 3;
		}
	}
}