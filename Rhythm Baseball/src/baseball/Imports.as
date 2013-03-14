package baseball {
	import relic.art.SpriteSheet;
	import relic.audio.SoundManager;
	/**
	 * ...
	 * @author George
	 */
	public class Imports
	{
		// --- --- --- --- --- GFX --- --- --- --- --- 
		[Embed(source = "../../res/sprites/hero.png", mimeType = "image/png")]
		static public const Hero:Class;
		[Embed(source = "../../res/sprites/ground.png", mimeType = "image/png")]
		static public const Ground:Class;
		[Embed(source = "../../res/sprites/bomb.png", mimeType = "image/png")]
		static public const Bomb:Class;
		[Embed(source = "../../res/sprites/gap.png", mimeType = "image/png")]
		static public const Gap:Class;
		[Embed(source = "../../res/sprites/rock.png", mimeType = "image/png")]
		static public const Rock:Class;
		[Embed(source = "../../res/sprites/block.png", mimeType = "image/png")]
		static public const Block:Class;
		[Embed(source = "../../res/sprites/buttons.png", mimeType = "image/png")]
		static private const ButtonSrc:Class;
		[Embed(source = "../../res/sprites/testBtn.png", mimeType = "image/png")]
		static private const TestBtnSrc:Class;
		// --- --- --- --- --- SFX --- --- --- --- ---
		[Embed(source = "../../res/audio/sfx/jump.mp3")]
		static private const Jump:Class;
		[Embed(source = "../../res/audio/sfx/swing.mp3")]
		static private const Swing:Class;
		[Embed(source = "../../res/audio/sfx/slide.mp3")]
		static private const Slide:Class;
		[Embed(source = "../../res/audio/sfx/duck.mp3")]
		static private const Duck:Class;
		[Embed(source = "../../res/audio/sfx/break.mp3")]
		static private const Break:Class;
		[Embed(source = "../../res/audio/sfx/hit.mp3")]
		static private const Hit:Class;
		// --- --- --- --- --- SONGS --- --- --- --- ---
		[Embed(source = "../../res/audio/songs/17.mp3")]
		static private const Seventeen:Class;
		[Embed(source = "../../res/audio/songs/tmottbg.mp3")]
		static private const TMOTTBG:Class;
		// --- --- --- --- --- LEVELS --- --- --- --- ---
		[Embed(source='../../res/levels/level0.xml', mimeType="application/octet-stream")]
		public static const testLevel:Class; 
		{
			
			SoundManager.addSound("jump", new Jump());
			SoundManager.addSound("break", new Break());
			SoundManager.addSound("slide", new Imports.Slide());
			SoundManager.addSound("duck", new Imports.Duck());
			SoundManager.addSound("swing", new Imports.Swing());
			SoundManager.addSound("hit", new Imports.Hit());
			SoundManager.addMusic("17", new Imports.Seventeen());	
			SoundManager.addMusic("tmottbg", new Imports.TMOTTBG());
			Buttons = new SpriteSheet(new ButtonSrc().bitmapData);
			Buttons.createGrid(64, 64);
			TestBtn = new SpriteSheet(new TestBtnSrc().bitmapData);
			TestBtn.createGrid(128, 64);
		}
		
		static public var Buttons:SpriteSheet;
		static public var TestBtn:SpriteSheet;
	}

}