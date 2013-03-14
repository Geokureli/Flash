package relic.art 
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextLineMetrics;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author George
	 */
	public class Text extends Asset {
		static public const DEFAULT_FORMAT:TextFormat = new TextFormat("arial", 12, 0, true, null, null, null, null, TextFormatAlign.CENTER);
		private var _format:TextFormat;
		private var _isInput:Boolean;
		private var _numMode:Boolean;
		public function Text(text:String) {
			super();
			graphic = new TextField();
			format = DEFAULT_FORMAT;
			this.text = text;
			selectable = false;
		}
		
		public function get textField():TextField { return graphic as TextField; }
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			if (type == TextEvent.TEXT_INPUT || type == Event.CHANGE)
				textField.addEventListener(type, listener, useCapture, priority, useWeakReference);
			else super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/* DELEGATE flash.text.TextField */
		
		public function get type():String { return textField.type; }
		public function set type(value:String):void {
			textField.type = value;
		}
		
		override public function get width():Number { return textField.width; }
		override public function set width(value:Number):void { textField.width = value; }
		
		override public function get height():Number { return textField.height; }
		override public function set height(value:Number):void { textField.height = value; }
		
		public function get antiAliasType():String { return textField.antiAliasType; }
		public function set antiAliasType(value:String):void { textField.antiAliasType = value; }
		
		public function get autoSize():String { return textField.autoSize; }
		public function set autoSize(value:String):void { textField.autoSize = value; }
		
		public function get background():Boolean { return textField.background; }
		public function set background(value:Boolean):void { textField.background = value; }
		
		public function get backgroundColor():uint { return textField.backgroundColor; }
		public function set backgroundColor(value:uint):void { textField.backgroundColor = value; }
		
		public function get border():Boolean { return textField.border; }
		public function set border(value:Boolean):void { textField.border = value; }
		
		public function get borderColor():uint { return textField.borderColor; }
		public function set borderColor(value:uint):void { textField.borderColor = value; }
		
		public function get caretIndex():int { return textField.caretIndex; }
		
		public function get condenseWhite():Boolean { return textField.condenseWhite; }
		public function set condenseWhite(value:Boolean):void { textField.condenseWhite = value; }
		
		public function get displayAsPassword():Boolean { return textField.displayAsPassword; }
		public function set displayAsPassword(value:Boolean):void { textField.displayAsPassword = value; }
		
		public function get embedFonts():Boolean { return textField.embedFonts; }
		public function set embedFonts(value:Boolean):void { textField.embedFonts = value; }
		
		public function getCharBoundaries(charIndex:int):flash.geom.Rectangle { return textField.getCharBoundaries(charIndex); }
		public function getCharIndexAtPoint(x:Number, y:Number):int { return textField.getCharIndexAtPoint(x, y); }
		public function getFirstCharInParagraph(charIndex:int):int { return textField.getFirstCharInParagraph(charIndex); }
		public function getImageReference(id:String):flash.display.DisplayObject { return textField.getImageReference(id); }
		public function getLineIndexAtPoint(x:Number, y:Number):int { return textField.getLineIndexAtPoint(x, y); }
		public function getLineIndexOfChar(charIndex:int):int { return textField.getLineIndexOfChar(charIndex); }
		public function getLineLength(lineIndex:int):int { return textField.getLineLength(lineIndex); }
		public function getLineMetrics(lineIndex:int):TextLineMetrics { return textField.getLineMetrics(lineIndex); }
		public function getLineOffset(lineIndex:int):int { return textField.getLineOffset(lineIndex); }
		public function getLineText(lineIndex:int):String { return textField.getLineText(lineIndex); }
		public function getParagraphLength(charIndex:int):int { return textField.getParagraphLength(charIndex); }
		public function getRawText():String { return textField.getRawText(); }
		
		public function get length():int { return textField.length; }
		
		public function get maxChars():int { return textField.maxChars; }
		public function set maxChars(value:int):void { textField.maxChars = value; }
		
		public function get maxScrollH():int { return textField.maxScrollH; }
		public function get maxScrollV():int { return textField.maxScrollV; }
		
		public function get mouseWheelEnabled():Boolean { return textField.mouseWheelEnabled; }
		public function set mouseWheelEnabled(value:Boolean):void { textField.mouseWheelEnabled = value; }
		
		public function get multiline():Boolean { return textField.multiline; }
		public function set multiline(value:Boolean):void { textField.multiline = value; }

		public function get numLines():int { return textField.numLines; }
		
		public function replaceSelectedText(value:String):void { textField.replaceSelectedText(value); }
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void { textField.replaceText(beginIndex, endIndex, newText); }
		
		public function get restrict():String { return textField.restrict; }
		public function set restrict(value:String):void { textField.restrict = value; }
		
		public function get scrollH():int { return textField.scrollH; }
		public function set scrollH(value:int):void { textField.scrollH = value; }
		
		public function get scrollV():int { return textField.scrollV; }
		public function set scrollV(value:int):void { textField.scrollV = value;}
		
		public function get selectable():Boolean { return textField.selectable; }
		public function set selectable(value:Boolean):void { textField.selectable = value; }
		
		public function get selectedText():String { return textField.selectedText; }
		public function get selectionBeginIndex():int { return textField.selectionBeginIndex; }
		public function get selectionEndIndex():int { return textField.selectionEndIndex; }
		public function setSelection(beginIndex:int, endIndex:int):void { textField.setSelection(beginIndex, endIndex); }
		
		public function get sharpness():Number { return textField.sharpness; }
		public function set sharpness(value:Number):void { textField.sharpness = value; }
		
		public function get text():String { return textField.text; }
		public function set text(value:String):void { textField.text = value; }
		
		public function get textHeight():Number { return textField.textHeight; }
		public function get textWidth():Number { return textField.textWidth; }
		
		public function get thickness():Number { return textField.thickness; }
		public function set thickness(value:Number):void { textField.thickness = value; }
		
		public function get wordWrap():Boolean { return textField.wordWrap; }
		public function set wordWrap(value:Boolean):void { textField.wordWrap = value; }
		
		/* DELEGATE flash.text.TextFormat */
		
		public function get align():String { return format.align; }
		public function set align(value:String):void { format.align = value; }
		
		public function get blockIndent():Object { return format.blockIndent; }
		public function set blockIndent(value:Object):void { format.blockIndent = value; }
		
		public function get bold():Object { return format.bold; }
		public function set bold(value:Object):void { format.bold = value; }
		
		public function get bullet():Object { return format.bullet; }
		public function set bullet(value:Object):void { format.bullet = value; }
		
		public function get color():Object { return format.color; }
		public function set color(value:Object):void { format.color = value; }
		
		public function get display():String { return format.display; }
		public function set display(value:String):void { format.display = value; }
		
		public function get font():String { return format.font; }
		public function set font(value:String):void { format.font = value; }
		
		public function get indent():Object { return format.indent; }
		public function set indent(value:Object):void { format.indent = value; }
		
		public function get italic():Object { return format.italic; }
		public function set italic(value:Object):void { format.italic = value; }
		
		public function get kerning():Object { return format.kerning; }
		public function set kerning(value:Object):void { format.kerning = value; }
		
		public function get leading():Object { return format.leading; }
		public function set leading(value:Object):void { format.leading = value; }
		
		public function get leftMargin():Object { return format.leftMargin; }
		public function set leftMargin(value:Object):void { format.leftMargin = value; }
		
		public function get letterSpacing():Object { return format.letterSpacing; }
		public function set letterSpacing(value:Object):void { format.letterSpacing = value; }
		
		public function get rightMargin():Object { return format.rightMargin; }
		public function set rightMargin(value:Object):void { format.rightMargin = value; }
		
		public function get size():Object { return format.size; }
		public function set size(value:Object):void { format.size = value; }
		
		public function get tabStops():Array { return format.tabStops; }
		public function set tabStops(value:Array):void { format.tabStops = value; }
		
		public function get target():String { return format.target; }
		public function set target(value:String):void { format.target = value; }
		
		public function get underline():Object { return format.underline; }
		public function set underline(value:Object):void { format.underline = value; }
		
		public function get url():String { return format.url; }
		public function set url(value:String):void { format.url = value; }
		
		public function get format():TextFormat { return textField.defaultTextFormat; }
		public function set format(value:TextFormat):void { textField.defaultTextFormat = value; }
		
		public function get numMode():Boolean { return _numMode; }
		public function set numMode(value:Boolean):void {
			_numMode = value;
			if (value)
				restrict = "0-9.";
			else restrict = null;
		}
		
	}

}