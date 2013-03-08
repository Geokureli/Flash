package baseball
{
	import relic.audio.SoundManager;
	/**
	 * ...
	 * @author George
	 */
	public class Imports
	{
		// --- --- --- --- --- GFX --- --- --- --- --- 
		[Embed(source = "../../res/sprites/hero.png", mimeType = "image/png")]
		static public var Hero:Class;
		[Embed(source = "../../res/sprites/ground.png", mimeType = "image/png")]
		static public var Ground:Class;
		[Embed(source = "../../res/sprites/bomb.png", mimeType = "image/png")]
		static public var Bomb:Class;
		[Embed(source = "../../res/sprites/gap.png", mimeType = "image/png")]
		static public var Gap:Class;
		[Embed(source = "../../res/sprites/rock.png", mimeType = "image/png")]
		static public var Rock:Class;
		[Embed(source = "../../res/sprites/block.png", mimeType = "image/png")]
		static public var Block:Class;
		[Embed(source = "../../res/sprites/remove.png", mimeType = "image/png")]
		static public var Remove:Class;
		// --- --- --- --- --- SFX --- --- --- --- ---
		[Embed(source = "../../res/audio/jump.mp3")]
		static public var Jump:Class;
		[Embed(source = "../../res/audio/swing.mp3")]
		static public var Swing:Class;
		[Embed(source = "../../res/audio/slide.mp3")]
		static public var Slide:Class;
		[Embed(source = "../../res/audio/duck.mp3")]
		static public var Duck:Class;
		[Embed(source = "../../res/audio/break.mp3")]
		static public var Break:Class;
		[Embed(source = "../../res/audio/hit.mp3")]
		static public var Hit:Class;
		// --- --- --- --- --- LEVELS --- --- --- --- ---
		[Embed(source='../../res/levels/level0.xml', mimeType="application/octet-stream")]
		public static const testLevel:Class; 
		{
			
			SoundManager.addSound("jump", new Imports.Jump());
			SoundManager.addSound("break", new Imports.Break());
			SoundManager.addSound("slide", new Imports.Slide());
			SoundManager.addSound("duck", new Imports.Duck());
			SoundManager.addSound("swing", new Imports.Swing());
			SoundManager.addSound("hit", new Imports.Hit());
		}
	}

}