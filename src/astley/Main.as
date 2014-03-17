package astley {
	import astley.art.Tilemap;
	import astley.states.RollinState;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.events.Event;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author George
	 */
	
	[Frame(factoryClass="astley.states.Preloader")]
	[SWF(width = "320", height = "512", backgroundColor = "#5c94fc", frameRate = "30")]
	public class Main extends FlxGame {
		
		[Embed(source = "../../res/astley/graphics/pres_any_key.png")] static public const INSTRUCTIONS:Class;
		
		static private const SCALE:int = 2;
		static private const POWERS:Number = Math.pow(Math.E, 4);
		
		public function Main() {
			super(320/SCALE, 512/SCALE,
				IntroState,
				SCALE,
				60, 30,
				true
			);
			
			var numPipes:int = 131;
			
			for (var i:int = 0; i <= numPipes; i++) {
				trace(i, (i / numPipes) * POWERS, check(i / 131));
			}
		}
		
        override protected function create(FlashEvent:Event):void
        {
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
			
			TweenPlugin.activate([BezierPlugin]);
        }
		
		public function check(num:Number):int{
			if (num == 1) return 4;
			return Math.log(int(num * POWERS));
		}
	}
}

import astley.art.Grass;
import astley.art.RickLite;
import astley.art.ScoreBoard;
import astley.art.Tilemap;
import astley.data.LevelData;
import astley.data.RAInput;
import astley.states.ReplayState;
import astley.states.RollinState;
import com.greensock.easing.Sine;
import com.greensock.TweenMax;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTimer;
import org.osflash.signals.Signal;
import astley.Main;

class IntroState extends FlxState {
	
	[Embed(source = "../../res/astley/graphics/gassy_rick_astley.png")] static private const TITLE:Class;
	[Embed(source = "../../res/astley/graphics/tap.png")] static private const TAP_ICON:Class;
	[Embed(source="../../res/astley/graphics/keys.png")] static private const KEYS_ICON:Class;
	
	private var _tileMap:Tilemap;
	private var _title:FlxSprite;
	private var _instructions:FlxSprite;
	private var _tweens:Array;
	private var _hero:RickLite;
	
	override public function create():void {
		super.create();
		
		FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		
		//add(_tileMap = new Tilemap());
		
		centerX(add(_title = new FlxSprite(0, 4, TITLE)) as FlxSprite).y = -_title.height;
		centerX(add(_instructions = new FlxSprite(0, 160, Main.INSTRUCTIONS)) as FlxSprite).visible = false;
		
		add(_hero = new RickLite(4, _title.y));
		_hero.offset.y = 8;
		_title.x += 8;
		
		add(new FlxSprite(100, 123, TAP_ICON));
		add(new FlxSprite(45, 128, KEYS_ICON));
		add(new Grass());
		var ground:FlxSprite = new FlxSprite(0, LevelData.SKY_HEIGHT);
		ground.makeGraphic(FlxG.width, LevelData.FLOOR_HEIGHT, 0xFF109400);
		ground.scrollFactor.x = 0;
		ground.solid = true;
		add(ground);
		
		RAInput.enabled = false;
		TweenMax.allTo([_hero, _title], 1, { y:52, ease:Sine.easeOut, onComplete:onIntroComplete } );
		
		FlxG.addPlugin(RAInput.instance);
		FlxG.bgColor = 0xFF5c94fc;
	}
	
	public function onIntroComplete():void {
		
		RAInput.enabled = true;
		_instructions.visible = true;
		_tweens = TweenMax.allTo( [_hero, _title], .5, { y:"-8", ease:Sine.easeInOut, repeat: -1, yoyo:true } );
	}
	
	override public function update():void {
		super.update();
		
		if (RAInput.instance.isButtonDown) {
			
			RAInput.enabled = false;
			FlxG.fade(0, .25, onFadeOut, true);
		}
	}
	
	private function onFadeOut():void {
		
		FlxG.switchState(
			new RollinState()
			//new ReplayState()
		)
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
	
	override public function destroy():void {
		super.destroy();
		
		alive = false;
		
		while(_tweens.length > 0)
			_tweens.pop().kill();
		
		_tileMap = null
		_title = null;
		_instructions = null;
		_hero = null;
	}
}

