package baseball.scenes 
{
	import baseball.art.Cloud;
	import baseball.art.Obstacle;
	import relic.beat.BeatKeeper;
	import relic.data.Global;
	import relic.data.helpers.Random;
	import relic.data.serial.Serializer;
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
		static private const NUM_CLOUDS:Number = 6;
		static public var BackGrass:SpriteSheet;
		static public var FrontGrass:SpriteSheet;
		
		{
			BackGrass = new SpriteSheet(new Imports.BackGrass().bitmapData);
			BackGrass.createGrid(32, 16);
			BackGrass.createDefualtAnimation(false, 1);
			
			FrontGrass = new SpriteSheet(new Imports.ForeGrass().bitmapData);
			FrontGrass.createGrid(32, 16);
			FrontGrass.createDefualtAnimation(false, 1);
			
			Serializer.addRef(Bomb, "ball");
			Serializer.addRef(Rock, "rock");
			Serializer.addRef(Gap, "gap");
			Serializer.addRef(Block, "block");
		}
		private var count:int;
		private var back:Sprite, mid:Sprite, front:Sprite;
		private var songStarted:Boolean;
		private var updateBlits:Boolean;
		protected var strikes:int;
		protected var bombTime:Number, defaultTime:Number, songOffset:Number;
		protected var level:XML, spawned:Vector.<int>
		protected var song:String;
		protected var levelParser:LevelParser;
		
		public function GameScene() {
			super(new BitmapData(Global.stage.stageWidth, Global.stage.stageHeight, false, 0));
			BeatKeeper.init();
		}
		
		protected function setLevelProperties():void {
			Bomb.SPEED = 0;
			Obstacle.HERO = new Vec2(100, bitmapData.height-112);
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
			updateBlits = true;
			spawned = new Vector.<int>();
			songStarted = false;
			strikes = 3;
			BeatKeeper.clearMetronome();
		}
		
		override protected function createLayers():void {
			super.createLayers();
			assets.autoGroup(Bomb, "bombs,obstacles");
			assets.autoGroup(Gap, "gaps,obstacles");
			assets.autoGroup(Rock, "rocks,obstacles");
			assets.autoGroup(Block, "blocks,obstacles");
			assets.autoGroup(BG, "bg");
			assets.autoGroup(Cloud, "bg,clouds");
			
			assets.autoID("bomb");
			assets.autoID("gap");
			assets.autoID("rock");
			assets.autoID("block");
			assets.autoID("cloud");
		}
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			var hero:Hero = assets.add(new Hero(), "hero") as Hero;
			place(hero, "mid");
			Cloud.CLOUD_RANGE = hero.y - 128;
			createBG();
		}
		protected function createBG():void {
			
			// --- CLOUDS --- 
			for (var i:int = 0; i < NUM_CLOUDS; i++)
				place(assets.add(new Cloud()), "back").x = stage.stageWidth / NUM_CLOUDS * i;
			
			// --- STANDS --- 
			var asset:Asset = assets.add(new BG(), "bg_stands");
			asset.setParameters( {
				graphic:new Imports.Crowd().bitmapData,
				y:hero.y - 112,
				parallax:.5
			} );
			place(asset, "back" );
			
			// --- BACK GRASS ---
			asset = assets.add(new BG(), "bg_darkGrass");
			asset.setParameters( {
				graphic:BackGrass,
				y:hero.y,
				parallax:.75,
				rows:2
			} );
			place(asset, "back" );
			
			// --- LINE ---
			asset = assets.add(new BG(), "bg_line")
			asset.setParameters( {
				graphic:new Imports.Ground().bitmapData,
				y:hero.y + 32
			} );
			place(asset, "back");
			
			// --- FRONT GRASS ---
			asset = assets.add(new BG(), "bg_lightGrass");
			asset.setParameters( {
				graphic:FrontGrass,
				y:hero.y + 96,
				parallax:1.5
			});
			place(asset, "back");
		}
		override protected function init(e:Event):void {
			super.init(e);
			BeatKeeper.frameRate = stage.frameRate;
			bombTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth + 200) / 60 / (Bomb.SPEED + Obstacle.SCROLL) / stage.frameRate;
			defaultTime = BeatKeeper.beatsPerMinute * -(stage.stageWidth + 200) / 60 / Obstacle.SCROLL / stage.frameRate;
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
			for each(var bomb:Bomb in assets.group("bombs")){
				if (bomb.left <= hero.right && bomb.isRhythm) {
					if (hero.currentAnimation == "swing") {
						bomb.vel.x = 40;
						bomb.vel.y = -20;
						bomb.acc.y = 1;
						SoundManager.play("swing");
						bomb.isRhythm = false;
					} else {
						assets.removeFromGroup(bomb, "bombs");
						addStrike();
					}
				}
			}
			for each(var gap:Gap in assets.group("gaps")) {
				if (hero.isTouching(gap) && hero.currentAnimation != "jump") {
					assets.removeFromGroup(gap, "gaps");
					addStrike();
				}
			}
			hero.onBlock = false;
			for each(var block:Block in assets.group("blocks")) {
				if (hero.isTouching(block)) {
					hero.onBlock = true;
					if (hero.currentAnimation != "duck" || hero.currentAnimation == "duck_end") {
						assets.removeFromGroup(block, "blocks");
						addStrike();
					}
				}
			}
			for each(var rock:Rock in assets.group("rocks")) {
				if (hero.isTouching(rock) && rock.currentAnimation == "idle") {
					if (hero.currentAnimation == "slide" || hero.currentAnimation == "slide_end") {
						rock.currentAnimation = "break";
						SoundManager.play("break");
					} else {
						assets.removeFromGroup(rock, "rocks");
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
			assets.setGroupParams("clouds", { live:false } );
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
			assets.trashGroup("obstacles");
			defaultUpdate = mainUpdate;
			hero.currentAnimation = "idle";
			updateBlits = true;
			songStarted = false;
			while (spawned.length > 0) spawned.shift();
			strikes = 3;
			assets.setGroupParams("clouds", { live:true } );
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
		
		public function get hero():Hero { return a("hero") as Hero; }
	}

}
import baseball.art.Obstacle;
import relic.art.Asset;
import relic.art.IScene;
import relic.art.ScrollingBG;
import relic.beat.BeatKeeper;
import relic.data.xml.XMLLevelParser;
class LevelParser extends XMLLevelParser {
	public function LevelParser(src:XML, target:IScene) { super(src, target); }
	//override public function parse(entry:String = null):void { super.parse(entry); }
	override protected function setDefaultValues():void {
		super.setDefaultValues();
		defaultAttributes.prependChild(<x>
			<ball layer="front"/>
			<rock layer="front"/>
			<gap layer="back"/>
			<block layer="front"/>
		</x>.children());
	}
	public function spawn(node:XML):void { return parseNode(node); }
}
class BG extends ScrollingBG {
	public function BG() { super(); }
	override public function update():void {
		super.update();
		x = Obstacle.HERO.x + BeatKeeper.toBeatPixels(Obstacle.SCROLL) * BeatKeeper.beat - stage.stageWidth*2;
	}
	override public function draw():void {
		super.draw();
	}
}