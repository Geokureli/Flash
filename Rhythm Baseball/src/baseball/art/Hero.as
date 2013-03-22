package baseball.art 
{
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import relic.art.Animation;
	import relic.art.blitting.AnimatedBlit;
	import relic.beat.BeatKeeper;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.blitting.Blit;
	import relic.art.SpriteSheet;
	import relic.audio.SoundManager;
	import relic.data.events.AnimationEvent;
	import relic.data.BoundMode;
	import relic.data.Keys;
	import relic.data.shapes.Box;
	import flash.events.Event;
	import relic.data.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends Asset {
		private var jumpChannel:SoundChannel;
		public var u:Boolean, d:Boolean, l:Boolean, r:Boolean,
					_u:Boolean, _d:Boolean, _l:Boolean, _r:Boolean;
		public var onBlock:Boolean;
		public function Hero() {
			super();
		}
		override protected function setDefaultValues():void 
		{
			super.setDefaultValues();
			id = "hero";
			graphic = new HeroBlit();
			x = Obstacle.HERO.x;
			y = Obstacle.HERO.y;
			friction = .05;
			shape = new Box(20, 0, 20, 64);
			//shape.debugDraw(graphics);
			//boundMode = BoundMode.LOCK;
			//debugDraw()
		}
		override protected function addListeners():void {
			super.addListeners();
			Keys.autoWatch(Keyboard.LEFT, this, "l");
			Keys.autoWatch(Keyboard.RIGHT, this, "r");
			Keys.autoWatch(Keyboard.UP, this, "u");
			Keys.autoWatch(Keyboard.DOWN, this, "d");
		}
		override protected function init(e:Event):void 
		{
			super.init(e);
		
			currentAnimation = "idle";
			bounds.width = stage.stageWidth;
			bounds.height = stage.stageHeight;
		}
		override public function update():void {
			super.update();
			if (!u) _u = true;
			if (!d) _d = true;
			if (!l) _l = true;
			if (!r) _r = true;
			if (currentAnimation == "idle"){// || currentAnimation == "slide_end" || currentAnimation == "duck_end") {
				if (r) {
					currentAnimation = "slide";
					SoundManager.play("duck");
					//
				}
				if (u && _u) {
					_u = false;
					currentAnimation = "jump";
					jumpChannel = SoundManager.play("jump");
					graphic.addEventListener(AnimationEvent.COMPLETE, animEnd);
				}
				if (l && _l) {
					_l = false;
					currentAnimation = "swing";
					graphic.addEventListener(AnimationEvent.COMPLETE, animEnd);
				}
				
				if (d) {
					currentAnimation = "duck";
					SoundManager.play("duck");
				}
			} else if (currentAnimation == "slide" && !r && frame > 1) {
				currentAnimation = "slide_end";
				graphic.addEventListener(AnimationEvent.COMPLETE, animEnd);
			} else if (currentAnimation == "duck" && !d && frame > 1 && !onBlock) {
				currentAnimation = "duck_end";
				graphic.addEventListener(AnimationEvent.COMPLETE, animEnd);
			} else if (currentAnimation == "jump" && !u && frame > 1) {
				graphic.removeEventListener(AnimationEvent.COMPLETE, animEnd);
				if(jumpChannel) jumpChannel.stop();
				jumpChannel = null;
				currentAnimation = "idle";
				SoundManager.play("hit");
			}
			
		}
		
		private function animEnd(e:AnimationEvent):void {
			if (e.data.name == "jump") {
				if (jumpChannel != null) jumpChannel.stop();
				SoundManager.play("hit");
			}
			graphic.removeEventListener(AnimationEvent.COMPLETE, animEnd);
			currentAnimation = "idle";
		}
		
		public function disableKeys():void {
			u = d = l = r = false;
			
			graphic.removeEventListener(AnimationEvent.COMPLETE, animEnd);
		}
		
		
		override protected function removeListeners():void {
			super.removeListeners();
			disableKeys();
			Keys.removeWatch(Keyboard.LEFT, this, "l");
			Keys.removeWatch(Keyboard.RIGHT, this, "r");
			Keys.removeWatch(Keyboard.UP, this, "u");
			Keys.removeWatch(Keyboard.DOWN, this, "d");
		}
		
		override public function destroy():void {
			super.destroy();
			
			jumpChannel = null;
		}
		
		public function get currentAnimation():String { return blit.currentAnimation; }
		public function set currentAnimation(value:String):void { blit.currentAnimation = value; }
		
		public function get frame():Number{ return blit.frame; }
		public function set frame(value:Number):void { blit.frame = value; }
		
		public function get blit():AnimatedBlit { return graphic as AnimatedBlit; }
	}
}
import baseball.Imports;
import relic.art.blitting.AnimatedBlit;
import relic.art.SpriteSheet;
import relic.beat.BeatKeeper;
class HeroBlit extends AnimatedBlit {
		
	static private var SPRITES:SpriteSheet;
	{
		SPRITES = new SpriteSheet(new Imports.Hero().bitmapData);
		SPRITES.clearBG();
		SPRITES.createGrid(64, 64);
		SPRITES.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));// --- NOT TIME-BASED
		SPRITES.addAnimation("slide", Vector.<int>([8, 9]), false, 1);
		SPRITES.addAnimation("slide_end", Vector.<int>([8]), true, 1);
		SPRITES.addAnimation("duck", Vector.<int>([10, 11]), false, 1);
		SPRITES.addAnimation("duck_end", Vector.<int>([10]),true, 1);
		SPRITES.addAnimation("jump", Vector.<int>([12]), true, 19);// --- ROUGHLY 5 BEATS
		SPRITES.addAnimation("swing", Vector.<int>([13, 14, 15, 15, 16, 16, 17]), false, 1);
		SPRITES.addAnimation("hit", Vector.<int>([8, 9]), false);
	}
	
	private var startBeat:Number;
	
	public function HeroBlit() { super(); }
	
	override protected function setDefaultValues():void {
		super.setDefaultValues();
		addAnimationSet(SPRITES);
		currentAnimation = "idle";
	}
	override public function draw():void {
		if(currentAnimation != "idle"){
			//trace((BeatKeeper.beat - startBeat) * BeatKeeper.beatsPerMinute * stage.frameRate / 60 / 3 - frame);
			frame = (BeatKeeper.beat - startBeat) * 120 * stage.frameRate / 60 / 3;
		}
		super.draw();
	}
	override public function set currentAnimation(value:String):void {
		startBeat = BeatKeeper.beat;
		super.currentAnimation = value;
	}
}