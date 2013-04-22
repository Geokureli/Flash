package ui
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Menu extends Sprite
    {
        public static const CHANGED:String = "onChanged";

        private static const ROUNDING:uint = 12;
        private static const SPACER:uint = 8;
        private static const MARGINS:uint = 4;
        
        private var _items:Array;
        private var _title:TextField;
        
        public function Menu( title:String, items:Array ):void
        {
            // --- Menu title
            _title = new TextField();
            _title.defaultTextFormat = new TextFormat( '_sans', 16, 0 );
            _title.text = title;
            _title.autoSize = TextFieldAutoSize.LEFT;
            _title.selectable = false;
            addChild( _title );
            
            // ---
            _items = items.concat();
            for each( var mi:MenuItem in _items )
            {
                mi.addEventListener( MenuItem.CHANGED, redraw );
                addChild( mi );
            }
            
            redraw();
        }

        private function findWidth():int
        {
            var m:int = _title.width;
           
            for each( var mi:MenuItem in _items )
                m = Math.max( mi.contentWidth, m );
            
            return m;
        }
        
        private function redraw( e:Event = null ):void
        {
            
            var w:int = findWidth();
            var edge:int = _title.height + MARGINS;
            var dy:int = edge + SPACER;
            
            _title.y = MARGINS;
            _title.x = MARGINS;

            for each( var item:MenuItem in _items )
            {
                item.y = dy;
                item.boxWidth = w;
                item.x = MARGINS;
                
                dy += item.boxHeight;
            }        
            
            var g:Graphics = graphics;

            g.clear();
            g.lineStyle( 3, 0x404040, 1.0, true );
            g.beginFill( 0x404040 );
            g.drawRoundRect( 0, 0, w + MARGINS * 2, dy + MARGINS, ROUNDING, ROUNDING );
            g.endFill();

            g.beginFill( 0xFFFFFF );
            g.drawRoundRect( 0, 0, w + MARGINS * 2, edge + MARGINS, ROUNDING, ROUNDING );
            g.endFill();
            
            dispatchEvent( new Event( CHANGED ) );
        }
    }
}