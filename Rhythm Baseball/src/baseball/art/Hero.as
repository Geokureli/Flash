package baseball.art 
{
	import flash.media.SoundChannel;
	import relic.beat.BeatKeeper;
	import baseball.Imports;
	import relic.art.Asset;
	import relic.art.blitting.Blit;
	import relic.art.SpriteSheet;
	import relic.audio.SoundManager;
	import relic.data.events.AnimationEvent;
	import relic.data.BoundMode;
	import relic.data.shapes.Box;
	import flash.events.Event;
	import relic.data.Vec2;
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends Blit {
		static private var sprites:SpriteSheet;
		private var jumpChannel:SoundChannel;
		private var startBeat:Number;
		{
			sprites = new SpriteSheet(new Imports.Hero().bitmapData);
			sprites.clearBG();
			sprites.createGrid(64, 64);
			sprites.addAnimation("idle", Vector.<int>([0, 1, 2, 3, 4, 5, 6, 7]));// --- NOT TIME-BASED
			sprites.addAnimation("slide", Vector.<int>([8, 9]), false, 1);
			sprites.addAnimation("slide_end", Vector.<int>([8]), true, 1);
			sprites.addAnimation("duck", Vector.<int>([10, 11]), false, 1);
			sprites.addAnimation("duck_end", Vector.<int>([10]),true, 1);
			sprites.addAnimation("jump", Vector.<int>([12]), true, 19);// --- ROUGHLY 5 BEATS
			sprites.addAnimation("swing", Vector.<int>([13, 14, 15, 15, 16, 16, 17]), false, 1);
			sprites.addAnimation("hit", Vector.<int>([8, 9]), false);
		}
		public var u:Boolean, d:Boolean, l:Boolean, r:Boolean,
					_u:Boolean, _d:Boolean, _l:Boolean, _r:Boolean;
		public var hitBlock:Boolean;
		public function Hero() {
			super();
		}
		override protected function setDefaultValues():void 
		{
			super.setDefaultValues();
			x = Obstacle.HERO.x;
			y = Obstacle.HERO.y;
			friction = .05;
			shape = new Box(20, 0, 20, 64);
			//shape.debugDraw(graphics);
			//boundMode = BoundMode.LOCK;
			addAnimationSet(sprites);
			//debugDraw()
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
					addEventListener(AnimationEvent.COMPLETE, animEnd);
				}
				if (l && _l) {
					_l = false;
					currentAnimation = "swing";
					addEventListener(AnimationEvent.COMPLETE, animEnd);
				}
				
				if (d) {
					currentAnimation = "duck";
					SoundManager.play("duck");
				}
			} else if (currentAnimation == "slide" && !r && _currentFrame > 1) {
				currentAnimation = "slide_end";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			} else if (currentAnimation == "duck" && !d && _currentFrame > 1 && !hitBlock) {
				currentAnimation = "duck_end";
				addEventListener(AnimationEvent.COMPLETE, animEnd);
			} else if (currentAnimation == "jump" && !u && _currentFrame > 1) {
				removeEventListener(AnimationEvent.COMPLETE, animEnd);
				jumpChannel.stop();
				jumpChannel = null;
				currentAnimation = "idle";
				SoundManager.play("hit");
			}
		}
		override protected function updateGraphics():void {
			super.updateGraphics();
			if(currentAnimation != "idle"){
				//trace((BeatKeeper.beat - startBeat) * BeatKeeper.beatsPerMinute * stage.frameRate / 60 / 3 - frame);
				_currentFrame = (BeatKeeper.beat - startBeat) * 120 * stage.frameRate / 60 / 3;
			}
		}
		override public function set currentAnimation(value:String):void 
		{
			startBeat = BeatKeeper.beat;
			super.currentAnimation = value;
		}
		private function animEnd(e:AnimationEvent):void {
			if (e.data.name == "jump") {
				if (jumpChannel != null) jumpChannel.stop();
				SoundManager.play("hit");
			}
			removeEventListener(AnimationEvent.COMPLETE, animEnd);
			currentAnimation = "idle";
		}
		
		public function disableKeys():void {
			u = d = l = r = false;
			removeEventListener(AnimationEvent.COMPLETE, animEnd);
		}
	}

}