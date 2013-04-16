package relic {
	import flash.geom.Rectangle;
	import relic.art.blitting.FontSheet;
	import relic.art.blitting.SpriteSheet;
	import relic.art.blitting.TemplateSheet;
	/**
	 * ...
	 * @author George
	 */
	public class Resources {
		
		//[Embed(source="C:\WINDOWS\Fonts\vgafix.fon", fontFamily="pixel")] 
		//public var PixelText:String;
		
		[Embed(source = "../../res/pixelFont.png", mimeType = "image/png")]
		static private const PIXEL_FONT:Class;
		[Embed(source = "../../res/border.png", mimeType = "image/png")]
		static private const BORDER:Class;
		[Embed(source = "../../res/shapeDebug.png", mimeType = "image/png")]
		static private const DEBUG_SHAPE:Class;
		[Embed(source = "../../res/graphicDebug.png", mimeType = "image/png")]
		static private const DEBUG_GRAPHIC:Class;
		
		static public var PixelFont:FontSheet;
		static public var DefaultBorder:TemplateSheet;
		static public var DebugShape:TemplateSheet;
		static public var DebugGraphic:TemplateSheet;
		
		{
			DefaultBorder = new TemplateSheet(new BORDER().bitmapData);
			DebugGraphic = new TemplateSheet(new DEBUG_GRAPHIC().bitmapData);
			DebugShape = new TemplateSheet(new DEBUG_SHAPE().bitmapData);
			
			PixelFont = new FontSheet(new PIXEL_FONT().bitmapData);
			PixelFont.createGrid(8, 14);
			PixelFont.setChars("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.'!$ ");
		}
		
	}

}