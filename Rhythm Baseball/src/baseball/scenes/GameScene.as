package baseball.scenes 
{
	import baseball.art.RhythmAsset;
	import baseball.beat.BeatKeeper;
	import relic.art.Asset;
	import relic.art.Scene;
	import relic.art.ScrollingBG;
	import relic.art.SpriteSheet;
	import relic.audio.SoundManager;
	
	import baseball.Imports;
	import baseball.art.Hero;
	import baseball.art.obstacles.Gap;
	import baseball.art.obstacles.Bomb;
	import baseball.art.obstacles.Rock;
	import baseball.art.obstacles.Block;

	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	
	/**
	 * ...
	 * @author George
	 */
	public class GameScene extends Scene
	{
		private var count:int;
		private var back:Sprite, mid:Sprite, front:Sprite;
		
		protected var level:XML;
		protected var spawnList:XMLList;
		
		public function GameScene() {
			super();
			BeatKeeper.init();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			update = defaultUpdate;
			BeatKeeper.beatsPerMinute = 160;
			Bomb.SPEED = -10;
			RhythmAsset.SCROLL = -10;
			
		}
		override protected function createLayers():void {
			super.createLayers();
			assets.autoGroup(Bomb, "bombs");
			assets.autoGroup(Gap, "gaps");
			assets.autoGroup(Rock, "rocks");
			assets.autoGroup(Block, "blocks");
			
			assets.autoName("bomb");
			assets.autoName("gap");
			assets.autoName("rock");
			assets.autoName("block");
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
			
			RhythmAsset.END_X = add(new Hero(), "hero").right;
			place("mid", "hero");
		}
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			BeatKeeper.frameRate = stage.frameRate;
			setSpawnTimes(level);
			spawnList = level.children().copy();
		}
		
		
		protected function setSpawnTimes(level:XML):void {
			var bombTime:Number = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / (Bomb.SPEED + RhythmAsset.SCROLL) / stage.frameRate;
			var time:Number = BeatKeeper.beatsPerMinute * -stage.stageWidth / 60 / RhythmAsset.SCROLL / stage.frameRate;
			for (var i:int = 0; i < level.children().length(); i++) {
				if (level.children()[i].name().toString() == "ball")
					level.children()[i]["@spawn"] = Number(level.children()[i]) - bombTime;
				else 
					level.children()[i]["@spawn"] = Number(level.children()[i]) - time;
			}
		}
		override public function enterFrame():void {
			super.enterFrame();
			for (var i:int = 0; i < spawnList.length(); i++) {
				if (BeatKeeper.beat > Number(spawnList[i].@spawn)) {
					switch(spawnList[i].name().toString()) {
						case "ball": addBomb(spawnList[i]); break;
						case "gap": addGap(spawnList[i]); break;
						case "rock": addRock(spawnList[i]); break;
						case "block": addBlock(spawnList[i]); break;
					}
					delete spawnList[i];
					break;
				}
			}
		}
		
		protected function defaultUpdate():void 
		{
			hero.u = up;
			hero.d = down;
			hero.l = left;
			hero.r = right;
			BeatKeeper.update();
			//hero.update();
			//bg.update();
			
			for each(var bomb:Bomb in assets.group("bombs")){
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
			for each(var gap:Gap in assets.group("gaps")) {
				if (hero.isTouching(gap) && hero.currentAnimation != "jump") 
					endGame();
			}
			for each(var block:Block in assets.group("blocks")) {
				if (hero.isTouching(block)
				&& (hero.currentAnimation != "duck" || hero.currentAnimation == "duck_end")) 
					endGame();
			}
			for each(var rock:Rock in assets.group("rocks")) {
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
			update = endLevel;
			hero.disableKeys();
			updateAssets = false;
			count = 0;
			trace(BeatKeeper.beat);
		}
		
		private function endLevel():void {
			hero.update();
			if (count++ == 30) {
				reset();
			}
		}
		
		protected function addBomb(beat:Number):void { place("front", assets.add(new Bomb(beat)), {x:stage.stageWidth+10}); }
		protected function addGap(beat:Number):void { place("back", assets.add(new Gap(beat)), {x:stage.stageWidth+10}); }
		protected function addRock(beat:Number):void { place("front", assets.add(new Rock(beat)), {x:stage.stageWidth+10}); }
		protected function addBlock(beat:Number):void { place("front", assets.add(new Block(beat)), {x:stage.stageWidth+10}); }
		
		protected function reset():void { 
			BeatKeeper.reset();
			assets.killGroup("bombs,gaps,rocks,blocks");
			update = defaultUpdate;
			hero.currentAnimation = "idle";
			updateAssets = true;
			spawnList = level.children().copy();
		}
		
		override public function destroy():void {
			super.destroy();
			level = null;
			spawnList = null;
		}
		
		
		public function get hero():Hero { return asset("hero") as Hero; }
	}

}