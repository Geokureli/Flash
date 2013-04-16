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
	import krakel.KrkState;
	import krakel.serial.Serializer;
	import krakel.xml.XMLParser;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
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
		
		// --- --- --- --- --- SFX --- --- --- --- ---
		[Embed(source="../../../../res/audio/sfx/hit.mp3")] static private const SND_HIT:Class;
		[Embed(source="../../../../res/audio/sfx/break.mp3")] static private const SND_BREAK:Class;
		[Embed(source="../../../../res/audio/sfx/swing.mp3")] static private const SND_SWING:Class;
		[Embed(source="../../../../res/audio/sfx/onBeat.mp3")] static private const SND_BEAT_ON:Class;
		[Embed(source="../../../../res/audio/sfx/offBeat.mp3")] static private const SND_BEAT_OFF:Class;
		
		static private const MSG_X:Number = 300, 
							MSG_Y:Number = 150;
		
		static protected var messages:Object;
		{
			messages = { strike:STRIKE_TXT, out:OUT_TXT, gameover:GAMEOVER_TXT, go:GO_TXT, ready:READY_TXT, charge:CHARGE_TXT };
		}
		
		protected var hero:Hero;
		
		protected var bg:FlxSprite;
		
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
					songStarted:Boolean;
					
		protected var strikes:CountLight,
					outs:CountLight;
		
		protected var s_break:FlxSound,
					s_hit:FlxSound,
					s_swing:FlxSound,
					s_onBeat:FlxSound,
					s_offBeat:FlxSound;
		
		protected var txt_message:FlxSprite;
		protected var defaultUpdate:Function;
		private var restartTimer:FlxTimer;
		private var song:FlxSound;
		private var checkpoint:Number;
		public var lastSpawn:Number;
		public var lastHit:Obstacle;
		
		public function GameState(level:XML = null) {
			this.level = level;
			
			super();
			
			checkpoint = 0;
		}
		
		override public function create():void {
			super.create();
			setLevelProperties();
			initLayers();
			addSounds();
			startGame();
			FlxG.bgColor = 0xFFa4e4fc;
			gameOver = true;
		}
		
		protected function initLayers():void {
			
			// --- LAYER ORDER
			add(bg = new FlxSprite(0, 340 - 224, BG));
			FlxScrollZone.add(bg, new Rectangle(0, 0, bg.width, bg.height), Obstacle.SCROLL, 0, true, true);
			FlxScrollZone.createZone(bg, new Rectangle(0, 0, bg.width, 112), Obstacle.SCROLL*.5, 0);
			FlxScrollZone.createZone(bg, new Rectangle(0, 112, bg.width, 16), Obstacle.SCROLL*.75, 0);
			FlxScrollZone.createZone(bg, new Rectangle(0, 128, bg.width, 16), Obstacle.SCROLL*.85, 0);
			//FlxScrollZone.createZone(bg, new Rectangle(0, 32, bg.width, 64), Obstacle.SCROLL, 0);
			FlxScrollZone.createZone(bg, new Rectangle(0, 208, bg.width, 16), Obstacle.SCROLL*1.5, 0);
			FlxScrollZone.stopScrolling();
			
			add(gaps   = new FlxGroup());
			add(bases  = new FlxGroup());
			add(tees  = new FlxGroup());
			add(hero   = new Hero());
			add(blocks = new FlxGroup());
			add(rocks  = new FlxGroup());
			add(bombs  = new FlxGroup());
			
			addUI();
			
			add(effects = new FlxGroup());
			
			hero.delay = 120 / FlxG.flashFramerate / BeatKeeper.beatsPerMinute;
			//FlxG.visualDebug = true;
		}
		
		protected function addSounds():void {
			s_swing   = new FlxSound().loadEmbedded( SND_SWING );
			s_break   = new FlxSound().loadEmbedded( SND_BREAK );
			s_hit     = new FlxSound().loadEmbedded( SND_HIT );
			s_onBeat  = new FlxSound().loadEmbedded( SND_BEAT_ON );
			s_offBeat = new FlxSound().loadEmbedded( SND_BEAT_OFF );
		}
		
		protected function addUI():void {
			
			add(UI = new FlxGroup());
			
			UI.add(strikes = new CountLight(240, 16, STRIKE_BAR, STRIKE_LIGHT));
			UI.add(outs = new CountLight(310, 16, OUT_BAR, OUT_LIGHT));
			
			UI.add(txt_message = new FlxSprite(MSG_X, MSG_Y));
			txt_message.scale.x =
				txt_message.scale.y = 2;
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
				song = new FlxSound();
				song.volume = 1;
				song.loadEmbedded(Imports.getSong(level.@song), false, true);
			}
			
			time = BeatKeeper.beatsPerMinute * -(FlxG.width + 200) / 60 / Obstacle.SCROLL / FlxG.flashFramerate;
			restartTimer = new FlxTimer();
		}
		
		protected function startGame():void {
			
			hero.x = -hero.frameWidth;
			hero.velocity.x = -Obstacle.SCROLL * 15;
			hero.acceleration.x = Obstacle.SCROLL * 10;
			
			startRun();
			
			defaultUpdate = updateIntro;
		}
		
		protected function startRun():void {
			
			
			if (checkpoint == 0) {
				// --- metronome
			}
			
			FlxScrollZone.startScrolling();
			
			message = "ready";
			txt_message.x = -txt_message.width;
			TweenMax.to(txt_message, 1, { x:MSG_X,  ease:com.greensock.easing.Sine.easeOut, onComplete:onReadyIn } );
			txt_message.visible = true;
			hero.play("idle");
			strikes.value = 0;
			songStarted = false;
			lastSpawn = checkpoint - .01;
		}
		
		private function onReadyIn():void {
			
		}
		
		protected function endIntro():void {
			BeatKeeper.init(checkpoint-(meter % 2 == 0 ? int(meter / 2) : meter));
			gameOver = false;
			
			hero.x = Obstacle.HERO.x;
			hero.velocity.x = 0;
			hero.acceleration.x = 0;
			
			message = "go";
			
			defaultUpdate = updateMain;
		}
		
		override public function update():void {
			
			if(!gameOver) BeatKeeper.update();
			super.update();
			if (defaultUpdate != null) defaultUpdate();
			
			if (BeatKeeper.time > songOffset && !songStarted && song != null) {
				song.position = BeatKeeper.time-songOffset;
				//trace("start: " + song.position);
				song.play();
				songStarted = true;
			}
			
			spawnAssets();
			
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
		
		private function updateIntro():void {
			//txt_message.alpha = (BeatKeeper.beat+100) % 1;
			if (hero.x > Obstacle.HERO.x) {
				hero.x = Obstacle.HERO.x;
				
				endIntro();
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
			
			//if (txt_message.alpha > 0) txt_message.alpha -= .025;
		}
		private function updateLose():void { }
		
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
						case "base" : obstacle =  bases.recycle(Base)  as Obstacle; break;
					}
					
					XMLParser.setProperties(obstacle, node);
					obstacle.revive();
					//trace(obstacle);
					lastSpawn = spawn;
					break;
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
				checkpoint = base.beat;
				base.pass();
			}
		}
		
		protected function strike(obstacle:Obstacle):void {
			lastHit = obstacle;
			if (++strikes.value == 3) out();
			s_hit.play(true);
			hero.flicker(15 / BeatKeeper.beatsPerMinute);
			addEffect(hero.x, hero.y, strikes.value == 0 ? OUT_TXT : STRIKE_TXT);
		}
		
		private function out():void {
			message = "out"
			if (outs.value == 2) lose();
			else restartTimer.start(2, 1, reset);
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
			
			
			BeatKeeper.init(checkpoint - (meter % 2 == 0 ? int(meter / 2) : meter));
			gameOver = false;
			startRun();
			defaultUpdate = updateMain;
			
			outs.value++;
			//trace("reset", checkpoint, -meter);
		}
		
		override public function destroy():void {
			super.destroy();
			bg.destroy();
			bombs.destroy();
			rocks.destroy();
			blocks.destroy();
			gaps.destroy();
			bases.destroy();
			hero.destroy();
			bg = null;
			bombs =
				rocks =
				blocks =
				gaps = null;
			hero = null;
			strikes = null;
			outs = null;
			level = null;
			defaultUpdate = null;
			restartTimer.destroy();
		}
		
		public function set message(value:String):void {
			txt_message.loadGraphic(messages[value]);
			txt_message.alpha = 1;
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
		_value = 0;
	}
	public function get value():uint { return _value; }
	public function set value(value:uint):void {
		while (_value < value)
			lights[_value++].visible = true;
		
		while ( _value > value)
			lights[--_value].visible = false;
	}
}

class Tee extends Obstacle {
	
	[Embed(source = "../../../../res/sprites/tee.png")] static private var TEE:Class;
	
	public function Tee() {
		super(34, TEE);
		offset.x = 1;
	}
}