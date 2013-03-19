package baseball.scenes 
{
	import baseball.art.Obstacle;
	import relic.beat.BeatKeeper;
	import relic.data.Global;
	import relic.data.xml.XMLClasses;
	import relic.data.xml.XMLParser;
	
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
		{
			XMLClasses.addRef(Bomb, "ball");
			XMLClasses.addRef(Rock, "rock");
			XMLClasses.addRef(Gap, "gap");
			XMLClasses.addRef(Block, "block");
		}
		private var count:int;
		private var back:Sprite, mid:Sprite, front:Sprite;
		private var songStarted:Boolean;
		protected var strikes:int;
		protected var bombTime:Number, defaultTime:Number, songOffset:Number;
		protected var level:XML, spawned:Vector.<int>
		protected var song:String;
		protected var levelParser:LevelParser;
		
		public function GameScene() {
			super(new BitmapData(800, 400, false, 0));
			BeatKeeper.init();
		}
		
		protected function setLevelProperties():void {
			Bomb.SPEED = -10;
			Obstacle.HERO = new Vec2(100, 300);
			if ("userLevel" in Global.VARS) level = Global.VARS.userLevel;
			else level = new XML(new Imports.testLevel);
		}
		
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			setLevelProperties();
			levelParser = new LevelParser(level, this);
			BeatKeeper.beatsPerMinute = Number(level.@bpm);
			Obstacle.SCROLL = -Number(level.@speed);
			if ("@song" in level) song = level.@song;
			if ("@offset" in level) songOffset = level.@offset;
			Global.VARS.songOffset = songOffset;
			Global.VARS.song = null;
			trace(level.toXMLString());
			defaultUpdate = mainUpdate;
			bgColor = 0xFFFFFF;
			spawned = new Vector.<int>();
			songStarted = false;
			strikes = 3;
			BeatKeeper.clearMetronome();
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
			
			for each(var node:XML in level.assets[0].children()) {
				var spawn:Number = Number(node.@beat) - (node.name().toString() == "ball" ? bombTime : defaultTime);
				if (beat > spawn && spawned.indexOf(node.childIndex()) == -1) {
					levelParser.spawn(node);
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
			
			if (song != null && BeatKeeper.time > songOffset && !songStarted){
				SoundManager.play(song, BeatKeeper.time - songOffset);
				songStarted = true;
				//Global.game.addDebugText("offset");
				BeatKeeper.syncWithSong(song, songOffset);
			}
			//if (songStarted) {
				//Global.game.setText("offset", (int(SoundManager.currentSongPosition) - (BeatKeeper.time - songOffset)).toString());
			//}
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
			BeatKeeper.stopSync();
			count = 0;
		}
		
		private function updateEnd():void {
			hero.update();
			if (count++ == 30) {
				reset();
			}
		}
		
		protected function reset():void { 
			trace("reset");
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
			SoundManager.stop(song);
			BeatKeeper.stopSync();
			song = null;
			Global.VARS.song = null;
		}
		
		
		public function get hero():Hero { return getBlit("hero") as Hero; }
	}

}
import relic.art.IScene;
import relic.data.xml.XMLLevelParser;
class LevelParser extends XMLLevelParser {
	public function LevelParser(src:XML, target:IScene) { super(src, target); }
	//override public function parse(entry:String = null):void { super.parse(entry); }
	override protected function setDefaultProperies():void {
		super.setDefaultProperies();		
		defaultAttributes.prependChild(<x>
			<ball layer="front"/>
			<rock layer="front"/>
			<gap layer="back"/>
			<block layer="front"/>
		</x>.children());
	}
	public function spawn(node:XML):void { return parseNode(node); }
}