package baseball.states.play {
	import baseball.art.Base;
	import baseball.art.Block;
	import baseball.art.Bomb;
	import baseball.art.Cloud;
	import baseball.art.Gap;
	import baseball.art.Obstacle;
	import baseball.art.Rock;
	import baseball.Imports;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import krakel.ads.AdBox;
	import krakel.beat.BeatKeeper;
	import krakel.helpers.Random;
	import krakel.KrkDepthBG;
	import krakel.KrkEffect;
	import krakel.KrkSound;
	import krakel.KrkSprite;
	import krakel.KrkState;
	import krakel.serial.Serializer;
	import krakel.xml.XMLParser;
	import mochi.as3.MochiEvents;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	import com.greensock.easing.*;
	import com.greensock.easing.Strong;
	import com.greensock.easing.FastEase;
	/**
	 * ...
	 * @author George
	 */
	public class GameState extends KrkState {
		// --- --- --- --- --- GFX --- --- --- --- ---
		[Embed(source = "../../../../res/sprites/field_signs_2.png")] static private var BG:Class;
		[Embed(source = "../../../../res/sprites/out_bar.png")] static private var OUT_BAR:Class;
		[Embed(source = "../../../../res/sprites/out_light.png")] static private var OUT_LIGHT:Class;
		[Embed(source = "../../../../res/sprites/strike_bar.png")] static private var STRIKE_BAR:Class;
		[Embed(source = "../../../../res/sprites/strike_light.png")] static private var STRIKE_LIGHT:Class;
		
		// --- --- --- --- --- TEXT --- --- --- --- ---
		[Embed(source="../../../../res/sprites/GO_txt.png")] static private var GO_TXT:Class;
		[Embed(source="../../../../res/sprites/Out_txt.png")] static private var OUT_TXT:Class;
		[Embed(source="../../../../res/sprites/Ready_txt.png")] static private var READY_TXT:Class;
		[Embed(source="../../../../res/sprites/Strike_txt.png")] static private var STRIKE_TXT:Class;
		[Embed(source="../../../../res/sprites/Charge_txt.png")] static private var CHARGE_TXT:Class;
		[Embed(source="../../../../res/sprites/GameOver_txt.png")] static private var GAMEOVER_TXT:Class;
		[Embed(source="../../../../res/sprites/Replay_txt.png")] static private var REPLAY_TXT:Class;
		[Embed(source="../../../../res/sprites/main_txt.png")] static private var MAIN_MENU_TXT:Class;
		
		// --- --- --- --- --- SFX --- --- --- --- ---
		[Embed(source="../../../../res/audio/sfx/hit.mp3")] static private const SND_HIT:Class;
		[Embed(source="../../../../res/audio/sfx/break.mp3")] static private const SND_BREAK:Class;
		[Embed(source="../../../../res/audio/sfx/swing.mp3")] static private const SND_SWING:Class;
		[Embed(source="../../../../res/audio/sfx/onBeat.mp3")] static private const SND_BEAT_ON:Class;
		[Embed(source="../../../../res/audio/sfx/offBeat.mp3")] static private const SND_BEAT_OFF:Class;
		
		static private const ZONE_HEIGHTS:Vector.<int>	 = new <int>	[112, 16, 16, 64, 16];
		static private const ZONE_SPEEDS:Vector.<Number> = new <Number>	[.5, .75, .85, 1, 1.5];
		
		static private const MSG_X:Number = 300, 
							MSG_Y:Number = 150;
		
		static private const NUM_CLOUDS:Number = 5;
		
		static private var BG_Y:Number;
		
		static private const LEVEL_IDS:Vector.<String> = Vector.<String>(["tmottbg", "test"]);
		
		static protected var messages:Object;
		{
			messages = { strike:STRIKE_TXT, out:OUT_TXT, gameover:GAMEOVER_TXT, go:GO_TXT, ready:READY_TXT, charge:CHARGE_TXT };
		}
		
		
		public var lastSpawn:Number;
		
		public var lastHit:Obstacle;
		
		public var won:Boolean;
		
		public var level:XML;
		
		protected var hero:Hero;
		
		protected var bg:FlxSprite,
						txt_message:FlxSprite;
		
		protected var obstacles:Array;
		
		protected var clouds:FlxGroup,
					bombs:FlxGroup,
					rocks:FlxGroup,
					blocks:FlxGroup,
					gaps:FlxGroup,
					tees:FlxGroup,
					bases:FlxGroup,
					effects:FlxGroup,
					UI:FlxGroup;
		
		protected var songOffset:int,
						meter:int,
						time:int;
		
		protected var gameOver:Boolean,
					flashMessage:Boolean,
					metronomeRunning:Boolean;
		
		protected var strikes:CountLight,
					outs:CountLight;
		
		protected var defaultUpdate:Function;
		
		
		private var s_break:KrkSound,
					s_hit:KrkSound,
					s_swing:KrkSound,
					s_onBeat:KrkSound,
					s_offBeat:KrkSound;
		
		private var replayBtn:FlxButton,
					mainBtn:FlxButton;
		
		private var restartTimer:FlxTimer,
					GOTimer:FlxTimer;
		
		private var checkpoint:Number;
		private var levelSpeed:Number;
		
		public function GameState(level:XML = null) {
			this.level = level;
			
			super();
		}
		
		override public function create():void {
			super.create();
			setLevelProperties();
			initLayers();
			addSounds();
			enterGame();
			BeatKeeper.clearMetronome();
			FlxG.bgColor = 0xFFa4e4fc;
			gameOver = true;
			BeatKeeper.stop();
			checkpoint = 0;
			won = false;
			metronomeRunning = false;
		}
		
		protected function setLevelProperties():void {
			if (level == null)
				level = Imports.getLevel(null);
				
			BeatKeeper.beatsPerMinute = level.@bpm;
			Obstacle.HERO = new FlxPoint(100, FlxG.height - 110);
			levelSpeed = Obstacle.SCROLL = -level.@speed;
			BG_Y = FlxG.height - 224;
			songOffset = 0;
			meter = level.@meter;
			if ("@song" in level) {
				var song:KrkSound = new KrkSound();
				song.volume = 1;
				song.loadEmbedded(Imports.getSong(level.@song), false, true);
				BeatKeeper.syncWithSong(song, level.@offset);
			}
			
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
			restartTimer = new FlxTimer();
			GOTimer = new FlxTimer();
		}
		
		protected function initLayers():void {
			// --- CLOUDS
			add(clouds = new FlxGroup(NUM_CLOUDS));
			var cloud:Cloud;
			for (var i:int = 0; i < NUM_CLOUDS; i++)
				clouds.add(new Cloud(FlxG.width/NUM_CLOUDS*i,Random.between(BG_Y - 32)));
			// --- SCROLLING BACKGROUND
			add(bg = new FlxSprite(0, BG_Y, BG));
			FlxScrollZone.add(bg, new Rectangle(0, 0, bg.width, bg.height), 0, 0, true, true);
			// --- SCROLL ZONES
			var y:int = 0;
			for (i = 0; i < ZONE_HEIGHTS.length; i++) {
				FlxScrollZone.createZone(bg, new Rectangle(0, y, bg.width, ZONE_HEIGHTS[i]), levelSpeed * ZONE_SPEEDS[i], 0);
				y += ZONE_HEIGHTS[i];
			}
			
			FlxScrollZone.stopScrolling();
			
			obstacles = [];
			
			add(gaps	= new FlxGroup());
			add(bases	= new FlxGroup());
			add(hero	= new Hero());
			add(tees	= new FlxGroup());
			add(blocks	= new FlxGroup());
			add(rocks	= new FlxGroup());
			add(bombs	= new FlxGroup());
			
			addUI();
			
			add(effects = new FlxGroup());
			
			hero.delay = 120 / FlxG.flashFramerate / BeatKeeper.beatsPerMinute;
			hero.play("idle");
		}
		
		protected function addSounds():void {
			s_swing   = new KrkSound().embed( SND_SWING );
			s_break   = new KrkSound().embed( SND_BREAK );
			s_hit     = new KrkSound().embed( SND_HIT );
			s_onBeat  = new KrkSound().embed( SND_BEAT_ON );
			s_offBeat = new KrkSound().embed( SND_BEAT_OFF );
		}
		
		protected function addUI():void {
			
			add(UI = new FlxGroup());
			
			UI.add(strikes = new CountLight(230, 10, STRIKE_BAR, STRIKE_LIGHT));
			UI.add(outs = new CountLight(338, 10, OUT_BAR, OUT_LIGHT));
			
			// --- BUTTON TEXTS
			UI.add(replayBtn = new FlxButton(215, 200).loadGraphic(REPLAY_TXT) as FlxButton);
			UI.add(mainBtn = new FlxButton(315, 200).loadGraphic(MAIN_MENU_TXT) as FlxButton);
			replayBtn.visible =
				mainBtn.visible = false;
			
			replayBtn.onOver = replayHilite;
			replayBtn.onOut = replayUnlite;
			mainBtn.onOver = mainHilite;
			mainBtn.onOut = mainUnlite;
			
			// --- MAIN MESSAGE
			UI.add(txt_message = new KrkSprite(MSG_X, MSG_Y));
			message = "ready";
			txt_message.scale.x =
				txt_message.scale.y = 2;
			txt_message.alpha = 0;
			
			messagePos = "center";
			flashMessage = false;
			
		}
		
		private function replayHilite():void { replayBtn.color = 0x00FF00; }
		private function replayUnlite():void { replayBtn.color = 0xFFFFFF; }
		public function replay():void {
			reset(null);
			//strikes.value = 0;
			outs.value = 0;
			replayBtn.onUp = mainBtn.onUp = null;
			replayBtn.visible = mainBtn.visible = false;
			checkpoint = 0;
		}
		
		private function mainHilite():void { mainBtn.color = 0x00FF00; }
		private function mainUnlite():void { mainBtn.color = 0xFFFFFF; }
		
		protected function enterGame():void {
			FlxScrollZone.startScrolling();
			
			if (FlxG.debug)
				onPanDone();
			else {
				TweenMax.from(bg, 1, { y:FlxG.height, ease:Cubic.easeOut, onComplete:onPanDone} );
				TweenMax.allFrom(topUI, 1, { y:-100 } );
				TweenMax.allFrom(clouds.members, 1, { y:FlxG.height } );
			}
		}
		
		private function onPanDone():void {
			if (FlxG.debug) {
				hero.x = Obstacle.HERO.x;
			} else {
				hero.x = -hero.frameWidth;
				hero.velocity.x = -Obstacle.SCROLL * 15;
				hero.acceleration.x = Obstacle.SCROLL * 10;
			}
			
			startRun();
			
			defaultUpdate = updateIntro;
		}
		
		protected function startRun():void {
			MochiEvents.startPlay(level.@id.toString());
			FlxScrollZone.startScrolling();
			clouds.setAll("moves", true);
			hero.play("idle");
			
			message = "ready";
			txt_message.y = -txt_message.height * txt_message.scale.y;
			TweenMax.to(txt_message, BeatKeeper.toSeconds(1), { y:MSG_Y,  ease:Strong.easeIn, onComplete:onReadyIn } );
			txt_message.visible = true;
			
			strikes.value = 0;
		}
		
		private function onReadyIn():void {
			//BeatKeeper.init(checkpoint - (meter % 2 == 0 ? int(meter / 2) : meter));
			BeatKeeper.start(checkpoint - meter);
			BeatKeeper.addWatch(checkpoint, onZero);
			lastSpawn = checkpoint - .01;
			
			gameOver = false;
			flashMessage = true;
			
			if (checkpoint == 0)
				setIntroMetronome();
		}
		
		protected function setIntroMetronome():void {
			BeatKeeper.setSimpleMetronome(meter, Imports.TICK, Imports.TOCK, 2);
			metronomeRunning = true;
		}
		
		protected function onZero(beat:Number):void {
			if (metronomeRunning)
				BeatKeeper.clearMetronome()
			
			message = "go";
			
			flashMessage = false;
			GOTimer.start(1, 1, onGoDone);
			//TweenMax.to(txt_message, BeatKeeper.toSeconds(1), { alpha:0 } );
		}
		
		private function onGoDone(timer:FlxTimer):void { txt_message.visible = false; }
		
		override public function update():void {
			if (!gameOver) {
				//BeatKeeper.update();
				
				if (flashMessage) {
					var x:Number = (BeatKeeper.beat + meter + songOffset / 60000 * BeatKeeper.beatsPerMinute) % 1;
					//txt_message.alpha = 4 * (x - .5) * (x - .5);
					txt_message.visible = 4 * (x - .5) * (x - .5) >= .25;
				}
			}
			
			super.update();
			if (defaultUpdate != null) defaultUpdate();
			
			spawnAssets();
			
			for (var i:int = 0; i < obstacles.length; i++) {
				if (!obstacles[i].exists) {
					obstacles.splice(i, 1);
					i--;
				}
			}
		}
		
		private function spawnAssets():void {
			var obstacle:Obstacle, tee:Obstacle;
			for each(var node:XML in level.assets[0].children()) {
				
				var spawn:Number = Number(node.@beat.toString());
				if (BeatKeeper.beat > spawn - time && spawn > lastSpawn) {
					
					switch(node.name().toString()) {
						case "bomb" :
							obstacle =  bombs.recycle(Bomb)  as Obstacle;
							tee = tees.recycle(Tee) as Obstacle;
							XMLParser.setProperties(tee, node);
							tee.revive();
							obstacles.push(tee);
							break;
						
						case "rock" : obstacle =  rocks.recycle(Rock)  as Obstacle; break;
						case "block":
							obstacle = blocks.recycle(Block) as Obstacle;
							(obstacle as Block).duration = 0;
							break;
						case "gap"  :
							obstacle =   gaps.recycle(Gap)   as Obstacle;
							(obstacle as Gap).duration = 0;
							break;
						case "base" :
							obstacle =  bases.recycle(Base)  as Obstacle;
							(obstacle as Base).isLast = islast(spawn);
							break;
					}
					
					XMLParser.setProperties(obstacle, node);
					obstacle.revive();
					obstacles.push(obstacle);
					lastSpawn = spawn;
					break;
				}
			}
		}
		
		private function updateIntro():void {
			
			if (hero.x >= Obstacle.HERO.x) {
				hero.reset(Obstacle.HERO.x, hero.y);
				hero.acceleration.x = 0;
				
				defaultUpdate = updateMain;
			}
		}
		protected function updateMain():void {
			var heroAnim:String = hero.animName;
			hero.forceDuck = false;
			if(
				FlxG.overlap(hero, bombs, onBomb) ||
				FlxG.overlap(hero, rocks, onRock) ||
				FlxG.overlap(hero, blocks, onBlock) ||
				FlxG.overlap(hero, gaps, onGap)
			) {
				//trace("hit");
			}
			FlxG.overlap(hero, bases, onBase);
		}
		private function updateLose():void { }
		private function updateWin():void {
			if (levelSpeed < 0) {
				
				levelSpeed += .15;
				
				for (var i:int = 0; i < ZONE_HEIGHTS.length; i++)
					FlxScrollZone.setScroll(bg, i, levelSpeed * ZONE_SPEEDS[i], 0);
				
			} else {
				FlxScrollZone.clear();
				levelSpeed = 0;
				gameOver = true;
				BeatKeeper.stop();
				defaultUpdate = null;
				
				if (FlxG.debug) onLeaveDone();
				else {
					leaveGame();
				}
			}
		}
		
		private function onBomb(hero:Hero, bomb:Bomb):void {
			if (bomb.alive) {
				
				bomb.alive = false;
				if (hero.animName == "swing") {
					s_swing.play(true);
					bomb.pass();
				}
				
				else strike(bomb);
			}
		}
		private function onRock(hero:Hero, rock:Rock):void {
			
			if (rock.alive) {
				
				rock.alive = false;
				if (hero.animName.indexOf("slide") != -1) {
					rock.pass();
					s_break.play(true);
				}
					
					
				else strike(rock);
			}
			
		}
		private function onBlock(hero:Hero, block:Block):void {
			if (hero.animName.indexOf("duck") != -1)
				block.pass();
				
			else if(block.alive) {
				hero.play("duck");
				block.alive = false;
				strike(block);
			}
			hero.forceDuck = true;
		}
		private function onGap(hero:Hero, gap:Gap):void {
			if (gap.alive) {
				
				if (hero.animName == "jump")
					gap.pass();
				
				else {
					
					gap.alive = false;
					strike(gap);
				}
			}
		}
		private function onBase(hero:Hero, base:Base):void {
			if (base.alive) {
				base.alive = false;
				base.pass();
				if (base.isLast) win();
				else checkpoint = base.beat;
			}
		}
		
		protected function islast(beat:Number):Boolean { return level.assets[0].children().(Number(@beat) > beat).length() == 0; }
		
		protected function strike(obstacle:Obstacle):void {
			lastHit = obstacle;
			if (++strikes.value == 3) out();
			s_hit.play(true);
			hero.flicker(15 / BeatKeeper.beatsPerMinute);
			addEffect(hero.x, hero.y, strikes.value == 0 ? OUT_TXT : STRIKE_TXT);
		}
		
		private function out():void {
			messagePos = "_top";
			TweenMax.to(txt_message, 1.5, { y:MSG_Y, ease:Bounce.easeOut } );
			if (outs.value == 2) lose();
			else {
				message = "out";
				restartTimer.start(2, 1, reset);
			}
			stopRun();
		}
		
		protected function stopRun():void {
			gameOver = true;
			BeatKeeper.stop();
			
			clouds.setAll("moves", false);
			FlxScrollZone.stopScrolling();
			
			hero.play(lastHit is Bomb || lastHit is Block ? "hit1" : "hit2");
			defaultUpdate = updateLose;
			
		}
		
		private function lose():void {
			outs.value++;
			message = "gameover";
			
			replayBtn.visible = mainBtn.visible = true;
			replayBtn.onUp = replay;
			mainBtn.onUp = leaveGame;
			
			MochiEvents.endPlay();
		}
		
		private function win():void {
			defaultUpdate = updateWin;
			hero.acceleration.x = 200;
			won = true;
			setKongVars();
		}
		
		protected function setKongVars():void {
			var level:int = levelNum;
			AdBox.sendVar("outs_lvl_" + level, outs.value);
			AdBox.sendVar("strikes_lvl_" + level, strikes.value + outs.value*3);
		}
		
		private function leaveGame():void {
			if (FlxG.debug) {
				onLeaveDone();
			} else {
				txt_message.visible = false;
				mainBtn.visible = replayBtn.visible = false;
				TweenMax.allTo([hero, bg].concat(obstacles), 1, { y:'+' + (FlxG.height - bg.y), ease:Cubic.easeIn, onComplete:onLeaveDone } );
				TweenMax.allTo(clouds.members, .95, { y:FlxG.height, ease:Cubic.easeIn } );
				TweenMax.allTo(topUI, .5, { y:-50, ease:Cubic.easeIn } );
			}
		}
		
		protected function get topUI():Array {
			return strikes.members.concat(outs.members);
		}
		
		private function onLeaveDone():void {
			toParentState();
		}
		
		protected function reset(timer:FlxTimer):void {
			
			bombs.kill();
			rocks.kill();
			blocks.kill();
			gaps.kill();
			tees.kill();
			bases.kill();
			
			bombs.revive();
			rocks.revive();
			blocks.revive();
			gaps.revive();
			tees.revive();
			bases.revive();
			
			startRun();
			defaultUpdate = updateMain;
			
			if(outs.value < 3)outs.value++;
		}
		
		override public function destroy():void {
			super.destroy();
			
			bg = null;
			obstacles = null;
			clouds =
				bombs =
				rocks =
				blocks =
				gaps = 
				tees = 
				effects = 
				UI = null;
			
			hero = null;
			strikes = null;
			outs = null;
			level = null;
			txt_message = null;
			defaultUpdate = null;
			
			// --- EVENTS
			restartTimer.destroy();
			restartTimer = null;
			FlxScrollZone.clear();
			BeatKeeper.destroy();
			
			// --- SOUNDS
			s_hit.destroy();
			s_break.destroy();
			s_swing.destroy();
			s_onBeat.destroy();
			s_offBeat.destroy();
			
			s_hit =
				s_break =
				s_swing =
				s_onBeat =
				s_offBeat = null;
			
		}
		
		public function set message(value:String):void {
			txt_message.loadGraphic(messages[value]);
			txt_message.alpha = 1;
			txt_message.visible = true;
		}
		public function set messagePos(value:String):void {
			switch(value) {
				case "top":
					txt_message.y = 0;
					break;
				case "_top":
					txt_message.y = -txt_message.height;
					//* txt_message.scale.y;
					break;
				case "center":
					txt_message.x = (FlxG.width - txt_message.width) / 2;
					break;
			}
		}
		
		public function addEffect(x:Number, y:Number, graphic:Class, animated:Boolean = false, width:uint = 0, height:uint = 0, unique:Boolean = false):void {
			var effect:FlxSprite = effects.recycle(KrkEffect) as FlxSprite;
			effect.revive();
			effect.x = x;
			effect.y = y;
			effect.velocity.y = -200;
			effect.acceleration.y = 400;
			effect.loadGraphic(graphic, animated, false, width, height, unique);
		}
		
		override public function pause():void {
			super.pause();
			BeatKeeper.pause();
		}
		
		override public function unpause():void {
			super.unpause();
			BeatKeeper.unpause();
		}
		
		public function get levelNum():int {
			return LEVEL_IDS.indexOf(level.@id.toString()) + 1;
		}
	}

}
import baseball.art.Obstacle;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.system.FlxList;

class CountLight extends FlxGroup {
	private var back:FlxSprite;
	private var lights:Vector.<FlxSprite>;
	private var _value:uint;
	private var _alpha:Number;
	
	public function CountLight(x:Number, y:Number, back:Class, light:Class) {
		super();
		add(this.back = new FlxSprite(x, y, back));
		this.back.scale.x = this.back.scale.y = 2;
		
		lights = new Vector.<FlxSprite>();
		var sprite:FlxSprite;
		for (var i:int = 0; i < 3; i++) {
			add(sprite = new FlxSprite(x+18*i - 6, y+6, light));
			lights.push(sprite);
			sprite.scale.x = sprite.scale.y = 2;
			sprite.visible = false;
		}
		_alpha = 1;
		_value = 0;
	}
	public function get value():uint { return _value; }
	public function set value(value:uint):void {
		while (_value < value)
			lights[_value++].visible = true;
		
		while ( _value > value)
			lights[--_value].visible = false;
	}
	
	public function get alpha():Number { return _alpha; }
	public function set alpha(value:Number):void {
		_alpha = value;
		setAll("alpha", value);
	}
}

class Tee extends Obstacle {
	
	[Embed(source = "../../../../res/sprites/tee.png")] static private var TEE:Class;
	
	public function Tee() {
		super(34, TEE);
		offset.x = 1;
		offset.y = -1;
	}
}