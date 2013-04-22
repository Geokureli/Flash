package ui
{
    import flash.display.Sprite;
    import flash.text.*;
    
    import flash.events.*;
    
    public class Notification extends Sprite
    {
        private static const MARGINS:int = 8;
        private static const ROUNDING:int = 16;

        private var _text:TextField;

        public function Notification( message:String ):void
        {
            _text = new TextField();
            _text.defaultTextFormat = new TextFormat( "_sans", 18, 0xFFFFFF );
            _text.text = message;
            _text.selectable = false;
            _text.autoSize = TextFieldAutoSize.LEFT;
            
            addChild( _text );

            addEventListener( MouseEvent.MOUSE_UP, remove );
            addEventListener( Event.ADDED_TO_STAGE, added );
            addEventListener( Event.ENTER_FRAME, bringToTop );
        }

        private function added(e:* = null):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, added );

            stage.addEventListener( Event.RESIZE, refresh );
            refresh();
        }

        private function refresh( e:* = null ):void
        {
            _text.x = (stage.stageWidth - _text.width) / 2;
            _text.y = (stage.stageHeight - _text.height) / 2;

            graphics.clear();

            graphics.lineStyle();
            graphics.beginFill( 0, 0.5 );
            graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
            graphics.endFill();

            graphics.lineStyle( 3, 0xFFFFFF );
            graphics.beginFill( 0x202020 );
            graphics.drawRoundRect( 
                _text.x - MARGINS, 
                _text.y - MARGINS, 
                _text.width + MARGINS*2, 
                _text.height + MARGINS*2, 
                ROUNDING, ROUNDING );
            graphics.endFill();
        }
        
        private function bringToTop( e:* = null ):void
        {
            parent.setChildIndex( this, parent.numChildren - 1 );
        }

        private function remove( e:* = null ):void
        {
            if( !parent )
                return ;

            removeEventListener( MouseEvent.MOUSE_UP, remove );
            removeEventListener( Event.ENTER_FRAME, bringToTop );
            stage.removeEventListener( Event.RESIZE, refresh );

            parent.removeChild(this);
        }
    }
}