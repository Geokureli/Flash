package krakel {
	import flash.display.BitmapData;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import org.flixel.FlxText;
	
	/**
	* An extended version of the FlxText class.
	* Adds a resize function for adjusting the width,
	* and also handles pixel text properly, even on centered text.
	* 
	* Unfortunately, it's not all that efficient.
	* 
	* @author Truefire
	*/
	public class KrkText extends FlxText {
		
		/** Internal reference to a bunch of Flash <code>TextField</code> objects.
		 * We use these to position each line of the text to avoid anti-aliasing.
		 * Hacks FTW!
		 */
		protected var _textFields:Vector.<TextField>
		public var antiBlur:Boolean;
		
		public function KrkText(x:Number = 0, y:Number = 0, width:uint = 1, text:String=null, embed:Boolean=true) {
			super(x, y, width, text, embed);
			antiBlur = false;
		}
		override public function preUpdate():void {
			if (pixels.width != width && antiBlur) resetWidth();
			super.preUpdate();
			
		}
		private function resetWidth():void {
			makeGraphic(width, 1, 0);
			_textField.width = width;
			_regen = true;
		}
		
		/**
		 * Resizes the text field, updating the pixels and everything.
		 * 
		 * @param  W                The new width of the text.
		 */
		public function resize(W:uint):void
		{
			_textField.width = width = W;
			_regen = true;
			calcFrame();
		}
		
		/**
		 * Internal function to update the current animation frame.
		 */
		override protected function calcFrame():void 
		{
			if(_regen)
			{
				//Need to generate a new buffer to store the text graphic
				var i:uint = 0;
				var nl:uint = _textField.numLines;
				height = 0;
				while(i < nl)
					height += _textField.getLineMetrics(i++).height;
				height += 4; //account for 2px gutter on top and bottom
				_pixels = new BitmapData(width,height,true,0);
				frameHeight = height;
				_textField.height = height*1.2;
				_flashRect.x = 0;
				_flashRect.y = 0;
				_flashRect.width = width;
				_flashRect.height = height;
				_regen = false;
				
				//generate our single line text fields;
				var heightCounter:int;
				_textFields = new Vector.<TextField>();
				i = 0;
				while (i < nl)
				{
					var tf:TextField = new TextField();
					tf.y = heightCounter;
					tf.width = _textField.width;
					tf.embedFonts = _textField.embedFonts;
					tf.selectable = false;
					tf.sharpness = 100;
					tf.multiline = false;
					tf.wordWrap = false;
					tf.text = _textField.getLineText(i);
					tf.defaultTextFormat = _textField.defaultTextFormat;
					tf.setTextFormat(_textField.defaultTextFormat);
					if(tf.text .length <= 0)
						tf.height = 1;
					else
						tf.height = 30;
					var lPos:Number = _textField.getLineMetrics(i).x;
					if ( lPos != Math.round(lPos)) { tf.x = Math.round(lPos)-lPos; }
					heightCounter += _textField.getLineMetrics(i++).height;
					_textFields.push(tf);
				}
			}
			else	//Else just clear the old buffer before redrawing the text
				_pixels.fillRect(_flashRect,0);
			
			if((_textField != null) && (_textField.text != null) && (_textField.text.length > 0))
			{
				//Now that we've cleared a buffer, we need to actually render the text to it
				var format:TextFormat = _textField.defaultTextFormat;
				var formatAdjusted:TextFormat = format;
				_matrix.identity();
				//If it's a single, centered line of text, we center it ourselves so it doesn't blur
				if((format.align == "center") && (_textField.numLines == 1))
				{
					formatAdjusted = new TextFormat(format.font,format.size,format.color,null,null,null,null,null,"left");
					_textField.setTextFormat(formatAdjusted);				
					_matrix.translate(Math.floor((width - _textField.getLineMetrics(0).width)/2),0);
				}
				//Render a single pixel shadow beneath the text
				if(_shadow > 0)
				{
					i = 0;
					while (i < _textFields.length)
					{
						_textFields[i].setTextFormat(new TextFormat(formatAdjusted.font,formatAdjusted.size,_shadow,null,null,null,null,null,formatAdjusted.align));				
						_matrix.translate(1+_textFields[i].x,1+_textFields[i].y);
						_pixels.draw(_textFields[i],_matrix,_colorTransform);
						_matrix.translate(-1-_textFields[i].x,-1-_textFields[i].y);
						_textFields[i].setTextFormat(new TextFormat(formatAdjusted.font, formatAdjusted.size, formatAdjusted.color, null, null, null, null, null, formatAdjusted.align));
						i++;
					}
				}
				//Actually draw the text onto the buffer
				i = 0;
				while (i < _textFields.length)
				{
					_matrix.translate(_textFields[i].x, _textFields[i].y);
					_pixels.draw(_textFields[i],_matrix,_colorTransform);
					_textFields[i].setTextFormat(new TextFormat(format.font, format.size, format.color, null, null, null, null, null, format.align));
					_matrix.translate(-_textFields[i].x,-_textFields[i].y);
					i++;
				}
			}
			
			//Finally, update the visible pixels
			if((framePixels == null) || (framePixels.width != _pixels.width) || (framePixels.height != _pixels.height))
				framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
			framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
		}
	}

}