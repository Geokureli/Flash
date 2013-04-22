package ui
{
    import flash.display.*;
    import flash.net.*;
    import flash.text.*;
    import flash.events.*;
    
    public class MenuItem extends Sprite
    {
        public static const CHANGED:String = "onChanged";
        
        private static const MARGINS:uint = 4;
        private static const SPACING:uint = 4;
        private static const ROUNDING:uint = 8;
        private static const ICON_HEIGHT:uint = 24;
        
        private var _icon:DisplayObject;
        private var _text:TextField;
        private var _width:int;
        
        public function MenuItem( callback:Function, text:String, image:String = null ):void
        {
            hitArea = new Sprite();
            addChild( hitArea );

            hideHighlight();

            _text = new TextField();
            _text.defaultTextFormat = new TextFormat( "_sans", 12, 0xFFFFFF );
            _text.text = text;
            _text.autoSize = TextFieldAutoSize.LEFT;
            _text.selectable = false;
            addChild( _text );
            
            if( image )
            {
                var l:Loader = new Loader();
                l.load( new URLRequest( image ) );
                l.contentLoaderInfo.addEventListener( Event.COMPLETE, loaded );
                addChild( l );

                _icon = l;
            }
            
            addEventListener( MouseEvent.MOUSE_UP, callback );
            addEventListener( MouseEvent.MOUSE_OVER, showHighlight ); 
            addEventListener( MouseEvent.MOUSE_OUT, hideHighlight );
        }

        private function showHighlight( e:Event = null ):void
        {
            hitArea.visible = true;
        }
    
        private function hideHighlight( e:Event = null ):void
        {
            hitArea.visible = false;
        }
    
        public function get contentWidth():int
        {
            var n:int = _text.width + MARGINS * 2;

            if( _icon )
                n += SPACING + _icon.width;
            
            return n;
        }
        
        private function loaded( e:Event ):void
        {
            _icon.scaleX = _icon.scaleY = ICON_HEIGHT / (_icon.width * _icon.scaleX);
            
            layout();
        }
        
        public function set boxWidth( v:int ):void
        {
            if( _width == v )
                return ;
                        
            _width = v;
            layout();
        }

        public function get boxWidth():int
        {
            return _width;
        }
        
        public function get boxHeight():int
        {
            if( _icon )
                return Math.max( _icon.height, _text.height ) + MARGINS * 2;
            else
                return _text.height + MARGINS * 2;
         }
        
        private function layout( e:Event = null ):void
        {
            if( _icon )
            {
                _icon.x = MARGINS;
                _icon.y = MARGINS;
                _text.x = MARGINS + SPACING + _icon.width;
                _text.y = MARGINS;
            }
            else
            {
                _text.x = MARGINS;
                _text.y = MARGINS;
            }
            
            hitArea.graphics.clear();
            hitArea.graphics.beginFill( 0xFFFFFFF, 0.25 );
            hitArea.graphics.drawRoundRect( 0, 0, boxWidth, boxHeight, ROUNDING, ROUNDING );
            hitArea.graphics.endFill();            

            dispatchEvent( new Event( CHANGED ) );
        }
    }
}