package baseball.scenes 
{
	import baseball.art.Obstacle;
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
		private var songStarted:Boolean;
		protected var strikes:int;
		protected var bombTime:Number, defaultTime:Number;
		protected var level:XML, spawned:Vector.<int>
		protected var song:String;
		
		public function GameScene() {
			super(new BitmapData(800, 400, false, 0));
			BeatKeeper.init();
		}
		
		protected function setLevelProperties():void {
			Bomb.SPEED = -10;
			Obstacle.HERO = new Vec2(100, 300);
			level = <level bpm="120" speed="10"/>;
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			setLevelProperties();
			BeatKeeper.beatsPerMinute = Number(level.@bpm);
			Obstacle.SCROLL = -Number(level.@speed);
			if ("@song" in level) song = level.@song;
			trace(level.toXMLString());
			defaultUpdate = mainUpdate;
			bgColor = 0xFFFFFF;
			spawned = new Vector.<int>();
			songStarted = false;
			strikes = 3;
		}
		
		override protected function createLayers():void {
			super.createLayers();
			autoGroup(Bomb, "bombs,obstacles");
			autoGroup(Gap, "gaps,obstacles");
			autoGroup(Rock, "rocks,obstacles");
			autoGroup(Block, "blocks,obstacles");
			
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
			Obstacle.HERO = new Vec2(hero.right, hero.y);
			place("mid", "hero");
		}
		override protected function init(e:Event):void {
			super.init(e);
			BeatKeeper.frameRate = stage.frameRate;
			bombTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth+200) / 60 / (Bomb.SPEED + Obstacle.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth + 200) / 60 / Obstacle.SCROLL / stage.frameRate;
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
			
			if (song != null && beat > 0 && !songStarted){
				SoundManager.play(song);
				songStarted = true;
			}
			
			for each(var node:XML in level.children()) {
				var spawn:Number = Number(node) - (node.name().toString() == "ball" ? bombTime : defaultTime);
				if (beat > spawn && spawned.indexOf(node.childIndex()) == -1) {
					switch(node.name().toString()) {
						case "ball": addBomb(node.toString()); break;
						case "gap": addGap(node.toString()); break;
						case "rock": addRock(node.toString()); break;
						case "block": addBlock(node.toString()); break;
					}
					spawned.push(node.childIndex());
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
			//bg.update();
			for each(var bomb:Bomb in group("bombs")){
				if (bomb.left <= hero.right && bomb.isRhythm) {
					if (hero.currentAnimation == "swing") {
						bomb.vel.x = 20;
						bomb.vel.y = -20;
						bomb.acc.y = 1;
						SoundManager.play("swing");
						bomb.isRhythm = false;
					} else {
						removeFromGroup(bomb, "bombs");
						addStrike();
					}
				}
			}
			for each(var gap:Gap in group("gaps")) {
				if (hero.isTouching(gap) && hero.currentAnimation != "jump") {
					removeFromGroup(gap, "gaps");
					addStrike();
				}
			}
			hero.hitBlock = false;
			for each(var block:Block in group("blocks")) {
				if (hero.isTouching(block)) {
					hero.hitBlock = true;
					if (hero.currentAnimation != "duck" || hero.currentAnimation == "duck_end") {
						removeFromGroup(block, "blocks");
						addStrike();
					}
				}
			}
			for each(var rock:Rock in group("rocks")) {
				if (hero.isTouching(rock) && rock.currentAnimation == "idle") {
					if (hero.currentAnimation == "slide" || hero.currentAnimation == "slide_end") {
						rock.currentAnimation = "break";
						SoundManager.play("break");
					} else {
						removeFromGroup(rock, "rocks");
						addStrike();
					}
				}
			}
		}
		private function addStrike():void {
			SoundManager.play("hit");
			if (--strikes == 0) endGame();
			else hero.startFlash();
		}
		private function endGame():void{
			if (song != null)
				SoundManager.stop(song);
			hero.currentAnimation = "hit";
			defaultUpdate = updateEnd;
			hero.disableKeys();
			updateBlits = false;
			count = 0;
		}
		
		private function updateEnd():void {
			hero.update();
			if (count++ == 30) {
				reset();
			}
		}
		
		protected function addBomb(beat:Number):void { place("front", add(new Bomb(beat))); }
		protected function addGap(beat:Number):void { place("back", add(new Gap(beat))); }
		protected function addRock(beat:Number):void { place("front", add(new Rock(beat))); }
		protected function addBlock(beat:Number):void { place("front", add(new Block(beat))); }
		
		protected function reset():void { 
			BeatKeeper.reset();
			killGroup("obstacles");
			defaultUpdate = mainUpdate;
			hero.currentAnimation = "idle";
			updateBlits = true;
			songStarted = false;
			while (spawned.length > 0) spawned.shift();
			strikes = 3;
		}
		
		override public function destroy():void {
			super.destroy();
			level = null;
			spawned = null;
			song = null;
		}
		
		
		public function get hero():Hero { return getBlit("hero") as Hero; }
	}

}