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
		[Embed(source = "../../res/sprites/smlButtons.png", mimeType = "image/png")]
		static private const smlBtnSrc:Class;
		[Embed(source = "../../res/sprites/navButtons.png", mimeType = "image/png")]
		static private const navBtnSrc:Class;
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
		[Embed(source = "../../res/audio/sfx/onBeat.mp3")]
		static private const OnBeat:Class;
		[Embed(source = "../../res/audio/sfx/offBeat.mp3")]
		
		// --- --- --- --- --- NOTE SAMPLES --- --- --- --- ---
		static private const OffBeat:Class;
		[Embed(source = "../../res/audio/sfx/notes/F5.mp3")]
		static private const NoteF:Class;
		[Embed(source = "../../res/audio/sfx/notes/F#5.mp3")]
		static private const NoteFs:Class;
		[Embed(source = "../../res/audio/sfx/notes/G5.mp3")]
		static private const NoteG:Class;
		[Embed(source = "../../res/audio/sfx/notes/G#5.mp3")]
		static private const NoteGs:Class;
		[Embed(source = "../../res/audio/sfx/notes/A5.mp3")]
		static private const NoteA:Class;
		[Embed(source = "../../res/audio/sfx/notes/A#5.mp3")]
		static private const NoteAs:Class;
		[Embed(source = "../../res/audio/sfx/notes/B5.mp3")]
		static private const NoteB:Class;
		[Embed(source = "../../res/audio/sfx/notes/C6.mp3")]
		static private const NoteC:Class;
		
		// --- --- --- --- --- SONGS --- --- --- --- ---
		[Embed(source = "../../res/audio/songs/17.mp3")]
		static private const Seventeen:Class;
		[Embed(source = "../../res/audio/songs/tmottbg.mp3")]
		static private const TMOTTBG:Class;
		// --- --- --- --- --- LEVELS --- --- --- --- ---
		[Embed(source='../../res/levels/level0.xml', mimeType="application/octet-stream")]
		public static const testLevel:Class; 
		[Embed(source='../../res/levels/level_tmottbg.xml', mimeType="application/octet-stream")]
		public static const Level1:Class; 
		{
			
			SoundManager.addSound("jump", new Jump(), {volume:.5});
			SoundManager.addSound("break", new Break(), {volume:.4});
			SoundManager.addSound("slide", new Imports.Slide());
			SoundManager.addSound("duck", new Imports.Duck());
			SoundManager.addSound("swing", new Imports.Swing(),{volume:.4});
			SoundManager.addSound("hit", new Imports.Hit());
			SoundManager.addSound("onBeat", new Imports.OnBeat());
			SoundManager.addSound("offBeat", new Imports.OffBeat());
			SoundManager.addSound("F", new Imports.NoteF());
			SoundManager.addSound("F#", new Imports.NoteFs());
			SoundManager.addSound("G", new Imports.NoteG());
			SoundManager.addSound("G#", new Imports.NoteGs());
			SoundManager.addSound("A", new Imports.NoteA());
			SoundManager.addSound("A#", new Imports.NoteAs());
			SoundManager.addSound("B", new Imports.NoteB());
			SoundManager.addSound("C", new Imports.NoteC());
			SoundManager.addMusic("17", new Imports.Seventeen());	
			SoundManager.addMusic("tmottbg", new Imports.TMOTTBG());
			Buttons = new SpriteSheet(new ButtonSrc().bitmapData);
			Buttons.createGrid(64, 64);
			TestBtn = new SpriteSheet(new TestBtnSrc().bitmapData);
			TestBtn.createGrid(128, 64);
			smlButtons = new SpriteSheet(new smlBtnSrc().bitmapData);
			smlButtons.createGrid(64, 16);
			navButtons = new SpriteSheet(new navBtnSrc().bitmapData);
			navButtons.createGrid(16, 16);
		}
		
		static public var Buttons:SpriteSheet;
		static public var smlButtons:SpriteSheet;
		static public var navButtons:SpriteSheet;
		static public var TestBtn:SpriteSheet;
	}

}