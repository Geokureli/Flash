package astley.art {
	import astley.data.Beat;
	import astley.data.RAInput;
	import astley.data.Recordings;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import krakel.helpers.Random;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxReplay;
	
	/**
	 * ...
	 * @author George
	 */
	
	public class Rick extends RickLite {
		
		[Embed(source = "../../../res/astley/audio/sfx/fart_0.mp3")] static private const FART_0:Class;
		[Embed(source = "../../../res/astley/audio/sfx/fart_1.mp3")] static private const FART_1:Class;
		[Embed(source = "../../../res/astley/audio/sfx/fart_2.mp3")] static private const FART_2:Class;
		[Embed(source = "../../../res/astley/audio/sfx/fart_3.mp3")] static private const FART_3:Class;
		[Embed(source = "../../../res/astley/audio/sfx/fart_4.mp3")] static private const FART_4:Class;
		[Embed(source = "../../../res/astley/audio/sfx/hit.mp3")] static private const HIT:Class;
		[Embed(source = "../../../res/astley/audio/sfx/smb_pipe.mp3")] static private const SOUND_PIPE:Class;
		
		static private const FARTS:Vector.<Class> = new <Class>[
			FART_0, FART_1, FART_2, FART_3, FART_4
		];
		
		static public const SPEED:Number = 60;
		
		static private const JUMP_HEIGHT:Number = 27;
		static private const GRAVITY:Number = JUMP_HEIGHT * Beat.BPM * Beat.BPM / 450;
		static private const JUMP:Number = 30 * GRAVITY / Beat.BPM;
		
		public var canFart:Boolean;
		public var playSounds:Boolean;
		
		protected var _recorder:FlxReplay;
		
		private var _input:RAInput;
		private var _recordSeed:int;
		private var _resetPos:FlxPoint;
		
		public function Rick(x:Number = 0, y:Number = 0) {
			super(x, y);
			
			_recorder = new FlxReplay();
			_resetPos = new FlxPoint(x, y);
			_input = new RAInput();
			
			width = 12;
			height = 20;
			
			offset.x = 2;
			offset.y = 6;
			
			acceleration.y = GRAVITY;
			maxVelocity.y = JUMP*2;
			velocity.x = SPEED;
			moves = false;
			canFart = true;
			playSounds = true;
		}
		
		public function start():void {
			moves = true;
			fart();
			if (_recorder != null)
				_recorder.create(_recordSeed++);
		}
		
		override public function update():void {
			super.update();
			_input.update();
			
			if (!moves) return;
			
			// --- DEATH DRAG
			if (isTouching(DOWN)) {
				
				if ((wasTouching & DOWN) == 0)
					FlxG.play(HIT);
				
				drag.x = 200;
			}
			
			if (!alive) return;
			
			if (_recorder != null)
				_recorder.recordFrame();
			// --- FARTING
			if (canFart && _input.isButtonDown)
				fart();
			
			// --- COLLISION
			if (y < 0 || y + height > FlxG.height)// || FlxG.overlap(this, Pipe.COLLIDER)) {
				kill();
		}
		
		public function fart():void {
			// --- USE FlxG SO THERE CAN BE MULTIPLE INSTANCES OF THE SAME FART
			if(playSounds)
				FlxG.play((Random.item(FARTS) as Class));
			
			velocity.y = -JUMP;
			play("farting");
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(_resetPos.x, _resetPos.y);
			
			velocity.x = SPEED;
			drag.x = 0;
			play("idle");
		}
		
		override public function kill():void {
			//super.kill();
			//velocity.x = 0;
			alive = false;
			play("dead");
			endRecording();
		}
		
		public function playWinAnim(targetX:int, targetY:int, callback:Function):void {
			
			x = targetX - width;
			acceleration.y = 0;
			velocity.x = 0;
			velocity.y = 0;
			canFart = false;
			
			endRecording(true);
			
			var speed:int = 10;
			var duration:Number = (y - targetY) / speed;
			TweenMax.to(this, duration, { y:targetY, ease:Linear.easeNone, onComplete:onPipeCentered, onCompleteParams:[callback] } );
		}
		
		private function onPipeCentered(callback:Function):void {
			
			velocity.x = 30;
			FlxG.play(SOUND_PIPE);
			callback();
		}
		
		public function endRecording(isDestroy:Boolean = false):void {
			
			if (_recorder != null)
				Recordings.addRecording(_recorder);
			
			if (isDestroy) {
				
				_recorder.destroy();
				_recorder = null;
			}
		}
		
		public function get resetPos():FlxPoint {
			return _resetPos;
		}
	}
}