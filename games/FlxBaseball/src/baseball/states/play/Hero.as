package baseball.states.play {
	import krakel.KrkSound;
	import krakel.KrkSprite;
	import org.flixel.FlxG;
	import org.flixel.system.FlxAnim;
	import org.flixel.system.input.Keyboard;
	
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends KrkSprite {
		
		[Embed(source = "../../../../res/sprites/hero2.png")] static private const SPRITES:Class;
		
		// --- --- --- --- --- SFX --- --- --- --- ---
		[Embed(source="../../../../res/audio/sfx/jump.mp3")] static private const SND_JUMP:Class;
		[Embed(source="../../../../res/audio/sfx/slide.mp3")] static private const SND_SLIDE:Class;
		[Embed(source="../../../../res/audio/sfx/duck.mp3")] static private const SND_DUCK:Class;
		
		static private const HANG_TIME:Number = 40;
		
		private var u:Boolean, _u:Boolean,
					r:Boolean,
					l:Boolean, _l:Boolean,
					d:Boolean;
		
		protected var s_jump:KrkSound,
					s_slide:KrkSound,
					s_duck:KrkSound;
		
		public var forceDuck:Boolean;
		
		private var lastFrame:uint, jumpTime:int;
		public function Hero(frameRate:Number = 15) {
			super(-1000, 230);
			initGraphic(frameRate);
			width = 20;
			height = 64;
			offset.x = 20;
			_u = _l = true;
			
			initSfx();
		}
		
		protected function initGraphic(frameRate:Number):void {
			loadGraphic(SPRITES, true, false, 64, 64);
			
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7], 15);// --- NOT TIME-BASED
			addAnimation("slide", [8, 9], frameRate, false);
			addAnimation("slide_end", [8], frameRate, false);
			addAnimation("duck", [10, 11], frameRate, false);
			addAnimation("duck_end", [10], frameRate, false);
			addAnimation("jump", [12], frameRate);// --- ROUGHLY 5 BEATS
			addAnimation("swing", [16, 17, 18, 18, 19, 19, 20], frameRate*2, false);
			addAnimation("hit1", [13]);
			addAnimation("hit2", [14]);
		}
		
		protected function initSfx():void {
			s_jump	  = new KrkSound().embed( SND_JUMP );
			s_slide   = new KrkSound().embed( SND_SLIDE );
			s_duck    = new KrkSound().embed( SND_DUCK );
		}
		
		override public function update():void {
			setKeys();
			super.update();
		}
		
		override protected function updateAnimation():void {
			super.updateAnimation();
			
			var onEndFrame:Boolean = _curFrame == _curAnim.frames.length - 1;
			jumpTime++;
			switch(_curAnim.name) {
				case "idle":
					if (u && _u) {
						_u = false;
						play("jump");
						s_jump.play(true);
						jumpTime = 0;
					} else if (r) play("slide");
					else if (d) play("duck");
					else if (l && _l) {
						_l = false;
						play("swing");
					}
					break;
				case "jump": 
					if (!u || jumpTime > HANG_TIME) {
						play("idle");
						s_jump.stop();
					}
					break;
				case "slide": if (!r && finished) play("slide_end"); break;
				case "duck": if (!d && finished && !forceDuck) play("duck_end"); break;
				case "slide_end":
				case "duck_end":
				case "swing": if (finished) play("idle"); break;
			}
		}
		
		private function setKeys():void {
			u = keys.W || keys.UP;
			d = keys.S || keys.DOWN;
			r = keys.D || keys.RIGHT;
			l = keys.A || keys.LEFT;
			
			if (!u) _u = true;
			if (!l) _l = true;
		}
		
		public function set delay(value:Number):void {
			for each(var anim:FlxAnim in _animations) {
				if (anim.name != "idle")
					anim.delay = value;
			}
		}
		
		private function get keys():Keyboard { return FlxG.keys; }
		public function get animName():String { return _curAnim.name; }
	}

}