package baseball.scenes 
{
	import baseball.art.RhythmBlit;
	import baseball.beat.BeatKeeper;
	
	import relic.art.Asset;
	import relic.art.Scene;
	import relic.art.ScrollingBG;
	import relic.art.SpriteSheet;
	import relic.art.blitting.Blitmap;
	import relic.art.blitting.BlitScene;
	import relic.audio.SoundManager;
	import relic.data.Vec2;
	import relic.data.events.SceneEvent;
	
	import baseball.Imports;
	import baseball.art.Hero;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Rock;
	import baseball.art.obstacles.Block;

	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameScene extends BlitScene {
		private var count:int;
		private var back:Sprite, mid:Sprite, front:Sprite;
		protected var bombTime:Number, defaultTime:Number;
		protected var level:XML;
		
		public function GameScene() {
			super(new BitmapData(800, 400, false, 0));
			BeatKeeper.init();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			defaultUpdate = mainUpdate;
			BeatKeeper.beatsPerMinute = 160;
			Bomb.SPEED = -10;
			RhythmBlit.SCROLL = -10;
			RhythmBlit.HERO = new Vec2(100, 309);
			bgColor = 0xFFFFFF;
		}
		override protected function createLayers():void {
			super.createLayers();
			autoGroup(Bomb, "bombs");
			autoGroup(Gap, "gaps");
			autoGroup(Rock, "rocks");
			autoGroup(Block, "blocks");
			
			autoName("bomb");
			autoName("gap");
			autoName("rock");
			autoName("block");
		}
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			//var bgSheet:SpriteSheet = new SpriteSheet(new Imports.Ground().bitmapData);
			//bgSheet.createGrid(64, 64);
			//bg = new ScrollingBG(800, 64, false);
			//bg.tile = bgSheet.frames[0];
			//bg.y = 280 + 64;
			//bg.speed = -10;
			//back.addChild(bg);
			var hero:Hero = add(new Hero(), "hero") as Hero;
			RhythmBlit.HERO = new Vec2(hero.right, hero.y);
			place("mid", "hero");
		}
		override protected function init(e:Event):void {
			super.init(e);
			BeatKeeper.frameRate = stage.frameRate;
			bombTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth+200) / 60 / (Bomb.SPEED + RhythmBlit.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth+200) / 60 / RhythmBlit.SCROLL / stage.frameRate;
		}
		
		override protected function keyHandle(e:KeyboardEvent):void {
			super.keyHandle(e);
			if (e.keyCode == 27)
				dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:"main" } ));
		}
		
		override public function update():void {
			var lastBeat:Number = BeatKeeper.beat;
			super.update();
			var beat:Number = BeatKeeper.beat;
			
			for each(var node:XML in level.children()) {
				var spawn:Number = Number(node) - (node.name().toString() == "ball" ? bombTime : defaultTime);
				if (beat > spawn && lastBeat <= spawn) {
					switch(node.name().toString()) {
						case "ball": addBomb(node.toString()); break;
						case "gap": addGap(node.toString()); break;
						case "rock": addRock(node.toString()); break;
						case "block": addBlock(node.toString()); break;
					}
					//delete spawnList[node];
					break;
				}
			}
		}
		
		protected function mainUpdate():void 
		{
			hero.u = up;
			hero.d = down;
			hero.l = left;
			hero.r = right;
			BeatKeeper.update();
			//hero.update();
			//bg.update();
			
			for each(var bomb:Bomb in group("bombs")){
				if (hero.isTouching(bomb) && bomb.isRhythm) {
					if (hero.currentAnimation == "swing") {
						bomb.vel.x = 20;
						bomb.vel.y = -20;
						bomb.acc.y = 1;
						SoundManager.play("swing");
						bomb.isRhythm = false;
					} else endGame();
				}
			}
			for each(var gap:Gap in group("gaps")) {
				if (hero.isTouching(gap) && hero.currentAnimation != "jump") 
					endGame();
			}
			hero.hitBlock = false;
			for each(var block:Block in group("blocks")) {
				if (hero.isTouching(block)) {
					hero.hitBlock = true;
					if (hero.currentAnimation != "duck" || hero.currentAnimation == "duck_end") 
						endGame();
				}
			}
			for each(var rock:Rock in group("rocks")) {
				if (hero.isTouching(rock) && rock.currentAnimation == "idle") {
					if (hero.currentAnimation == "slide" || hero.currentAnimation == "slide_end") {
						rock.currentAnimation = "break";
						SoundManager.play("break");
					} else endGame();
				}
			}
		}
		private function endGame():void {
			hero.currentAnimation = "hit";
			SoundManager.play("hit");
			defaultUpdate = endLevel;
			hero.disableKeys();
			updateBlits = false;
			count = 0;
		}
		
		private function endLevel():void {
			hero.update();
			if (count++ == 30) {
				reset();
			}
		}
		
		protected function addBomb(beat:Number):void { place("front", add(new Bomb(beat)), {x:stage.stageWidth+10}); }
		protected function addGap(beat:Number):void { place("back", add(new Gap(beat)), {x:stage.stageWidth+10}); }
		protected function addRock(beat:Number):void { place("front", add(new Rock(beat)), {x:stage.stageWidth+10}); }
		protected function addBlock(beat:Number):void { place("front", add(new Block(beat)), {x:stage.stageWidth+10}); }
		
		protected function reset():void { 
			BeatKeeper.reset();
			killGroup("bombs,gaps,rocks,blocks");
			defaultUpdate = mainUpdate;
			hero.currentAnimation = "idle";
			updateBlits = true;
		}
		
		override public function destroy():void {
			super.destroy();
			level = null;
		}
		
		
		public function get hero():Hero { return getBlit("hero") as Hero; }
	}

}