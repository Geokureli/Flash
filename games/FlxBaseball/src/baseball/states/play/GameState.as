package baseball.states.play {
	import baseball.art.Base;
	import baseball.art.Block;
	import baseball.art.Bomb;
	import baseball.art.Gap;
	import baseball.art.Obstacle;
	import baseball.art.Rock;
	import baseball.Imports;
	import com.greensock.TweenMax;
	import flash.geom.Rectangle;
	import krakel.beat.BeatKeeper;
	import krakel.KrkDepthBG;
	import krakel.KrkEffect;
	import krakel.KrkSound;
	import krakel.KrkSprite;
	import krakel.KrkState;
	import krakel.serial.Serializer;
	import krakel.xml.XMLParser;
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
		[Embed(source = "../../../../res/sprites/field.png")] static private var BG:Class;
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
							MSG_Y:Number = 150,
							BG_Y:Number = 176;
		
		static protected var messages:Object;
		{
			messages = { strike:STRIKE_TXT, out:OUT_TXT, gameover:GAMEOVER_TXT, go:GO_TXT, ready:READY_TXT, charge:CHARGE_TXT };
		}
		
		protected var hero:Hero;
		
		protected var bg:FlxSprite,
						txt_message:FlxSprite;
		
		protected var bombs:FlxGroup,
					rocks:FlxGroup,
					blocks:FlxGroup,
					gaps:FlxGroup,
					tees:FlxGroup,
					bases:FlxGroup,
					effects:FlxGroup,
					UI:FlxGroup;
		
		public var level:XML;
		
		protected var songOffset:int,
						meter:int,
						time:int;
		
		protected var gameOver:Boolean,
					songStarted:Boolean,
					flashMessage:Boolean;
		
		protected var strikes:CountLight,
					outs:CountLight;
		
		private var song:KrkSound,
					s_break:KrkSound,
					s_hit:KrkSound,
					s_swing:KrkSound,
					s_onBeat:KrkSound,
					s_offBeat:KrkSound;
		
		private var replayBtn:FlxButton,
					mainBtn:FlxButton;
		
		
		private var restartTimer:FlxTimer;
		
		protected var defaultUpdate:Function;
		
		protected var metronomeRunning:Boolean;
		
		private var checkpoint:Number;
		public var lastSpawn:Number;
		
		public var lastHit:Obstacle;
		
		public var won:Boolean;
		
		public function GameState(level:XML = null) {
			this.level = level;
			
			super();
		}
		
		override public function create():void {
			super.create();
			setLevelProperties();
			initLayers();
			addSounds();
			startGame();
			BeatKeeper.clearMetronome();
			FlxG.bgColor = 0xFFa4e4fc;
			gameOver = true;
			checkpoint = 0;
			won = false;
			metronomeRunning = false;
		}
		
		protected function setLevelProperties():void {
			if (level == null)
				level = Imports.getLevel(null);
				
			BeatKeeper.beatsPerMinute = level.@bpm;
			Obstacle.HERO = new FlxPoint(100, 230);
			Obstacle.SCROLL = -level.@speed;
			songOffset = level.@offset;
			meter = level.@meter;
			if ("@song" in level) {
				song = new KrkSound();
				song.volume = 1;
				song.loadEmbedded(Imports.getSong(level.@song), false, true);
			}
			
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
			restartTimer = new FlxTimer();
		}
		
		protected function initLayers():void {
			
			// --- SCROLLING BACKGROUND
			add(bg = new FlxSprite(0, BG_Y, BG));
			FlxScrollZone.add(bg, new Rectangle(0, 0, bg.width, bg.height), 0, 0, true, true);
			
			var y:int = 0;
			for (var i:int = 0; i < ZONE_HEIGHTS.length; i++) {
				FlxScrollZone.createZone(bg, new Rectangle(0, y, bg.width, ZONE_HEIGHTS[i]), Obstacle.SCROLL * ZONE_SPEEDS[i], 0);
				y += ZONE_HEIGHTS[i];
			}
			
			//FlxScrollZone.createZone(bg, new Rectangle(0, 112, bg.width, 16), Obstacle.SCROLL*.75, 0);
			//FlxScrollZone.createZone(bg, new Rectangle(0, 128, bg.width, 16), Obstacle.SCROLL*.85, 0);
			//FlxScrollZone.createZone(bg, new Rectangle(0, 32, bg.width, 64), Obstacle.SCROLL, 0);
			//FlxScrollZone.createZone(bg, new Rectangle(0, 208, bg.width, 16), Obstacle.SCROLL*1.5, 0);
			FlxScrollZone.stopScrolling();
			
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
			
			UI.add(strikes = new CountLight(240, 16, STRIKE_BAR, STRIKE_LIGHT));
			UI.add(outs = new CountLight(310, 16, OUT_BAR, OUT_LIGHT));
			
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
		
		protected function startGame():void {
			FlxScrollZone.startScrolling();
			
			trace(Obstacle.HERO.y)
			
			if (FlxG.debug)
				onPanDone();
			else {
				TweenMax.from(bg, 1, { y:FlxG.stage.stageHeight, ease:Cubic.easeOut, onComplete:onPanDone} );
				TweenMax.allFrom([strikes, outs], 1, { alpha:0 } );
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
			
			FlxScrollZone.startScrolling();
			hero.play("idle");
			
			message = "ready";
			txt_message.y = -txt_message.height * txt_message.scale.y;
			TweenMax.to(txt_message, BeatKeeper.toSeconds(1), { y:MSG_Y,  ease:Strong.easeIn, onComplete:onReadyIn } );
			txt_message.visible = true;
			
			strikes.value = 0;
		}
		
		private function onReadyIn():void {
			//BeatKeeper.init(checkpoint - (meter % 2 == 0 ? int(meter / 2) : meter));
			BeatKeeper.init(checkpoint - meter);
			BeatKeeper.addWatch(checkpoint, onZero);
			lastSpawn = checkpoint - .01;
			songStarted = false;
			
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
			TweenMax.to(txt_message, BeatKeeper.toSeconds(1), { alpha:0 } );
		}
		
		override public function update():void {
			if (!gameOver) {
				BeatKeeper.update();
				
				if (flashMessage) {
					var x:Number = (BeatKeeper.beat + meter + songOffset / 60000 * BeatKeeper.beatsPerMinute) % 1;
					txt_message.alpha = 4 * (x - .5) * (x - .5); // --- QUADRATIC: f(0) = 1, f(.5) = 0, f(1) = 1
				}
			}
			
			super.update();
			if (defaultUpdate != null) defaultUpdate();
			
			if (BeatKeeper.time > songOffset && !songStarted && song != null) {
				song.position = BeatKeeper.time-songOffset;
				song.play();
				songStarted = true;
			}
			
			spawnAssets();
			
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
							break;
						
						case "rock" : obstacle =  rocks.recycle(Rock)  as Obstacle; break;
						case "block": obstacle = blocks.recycle(Block) as Obstacle; break;
						case "gap"  : obstacle =   gaps.recycle(Gap)   as Obstacle; break;
						case "base" :
							obstacle =  bases.recycle(Base)  as Obstacle;
							(obstacle as Base).isLast = islast(spawn);
							break;
					}
					
					XMLParser.setProperties(obstacle, node);
					obstacle.revive();
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
			if (Obstacle.SCROLL < 0) {
				
				Obstacle.SCROLL += .15;
				
				for (var i:int = 0; i < ZONE_HEIGHTS.length; i++)
					FlxScrollZone.setScroll(bg, i, Obstacle.SCROLL * ZONE_SPEEDS[i], 0);
				
			} else {
				FlxScrollZone.clear();
				Obstacle.SCROLL = 0;
				gameOver = true;
				defaultUpdate = null;
				
				if (FlxG.debug) onLeaveDone();
				else {
					TweenMax.allTo([hero, bg], 1, { y:'+' + (FlxG.stage.stageHeight - bg.y), ease:Cubic.easeIn, onComplete:onLeaveDone } );
					TweenMax.allTo([strikes, outs], 1, { alpha:0, ease:Cubic.easeIn, onComplete:onLeaveDone } );
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
			if (block.alive) {
				
				block.alive = false;
				if (hero.animName.indexOf("duck") != -1) {
					
					hero.forceDuck = true;
					block.pass();
					
				} else strike(block);
			}
		}
		private function onGap(hero:Hero, gap:Gap):void {
			if (gap.alive) {
				gap.alive = false;
				
				if (hero.animName == "jump")
					gap.pass();
				
				else strike(gap);
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
			
			FlxScrollZone.stopScrolling();
			if (song != null) song.stop();
			
			hero.play(lastHit is Bomb || lastHit is Block ? "hit1" : "hit2");
			defaultUpdate = updateLose;
			
		}
		
		private function lose():void {
			outs.value++;
			message = "gameover";
			
			replayBtn.visible = mainBtn.visible = true;
			replayBtn.onUp = replay;
			mainBtn.onUp = toParentState;
		}
		
		private function win():void {
			defaultUpdate = updateWin;
			hero.acceleration.x = 200;
			won = true;
		}
		
		private function onLeaveDone():void {
			toParentState();
		}
		
		private function reset(timer:FlxTimer):void {
			
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
			
			song =
				s_hit =
				s_break =
				s_swing =
				s_onBeat =
				s_offBeat = null;
			
		}
		
		public function set message(value:String):void {
			txt_message.loadGraphic(messages[value]);
			txt_message.alpha = 1;
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
					txt_message.x = (FlxG.stage.stageWidth - txt_message.width) / 2;
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