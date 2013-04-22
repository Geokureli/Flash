import ui.*;

class ui.Notification
{
    private static var MARGINS:Number = 8;
    private static var ROUNDING:Number = 16;

    public static function create( message:String ):Void
    {
        var depth:Number = Init.overlay.getNextHighestDepth();
        var clip:MovieClip = Init.overlay.createEmptyMovieClip( '_notice' + depth, depth );            

        clip.createTextField( 'text', clip.getNextHighestDepth(), 0, 0, 1, 1 );
        var text:TextField = clip.text;

        text.setNewTextFormat( new TextFormat( "_sans", 18, 0xFFFFFF ) );
        text.text = message;
        text.selectable = false;
        text.autoSize = 'left';

        var onResize:Function = function():Void
        {
            text._x = (Stage.width - text._width) / 2;
            text._y = (Stage.height - text._height) / 2;
            
            clip.clear();

            clip.lineStyle();
            clip.beginFill( 0, 50 );
            Drawing.drawBox( clip, 0, 0, Stage.width, Stage.height );
            clip.endFill();

            clip.lineStyle( 3, 0xFFFFFF );
            clip.beginFill( 0x202020 );
            Drawing.drawRoundedBox( clip, 
                text._x - Notification.MARGINS, 
                text._y - Notification.MARGINS, 
                text._width + Notification.MARGINS*2, 
                text._height + Notification.MARGINS*2, 
                Notification.ROUNDING );
            clip.endFill();
        }
        
        clip.onMouseUp = function():Void
        {
            Core.removeEventListener( Core.RESIZED, onResize );

            clip.unloadMovie();
        }
        
        Core.addEventListener( Core.RESIZED, onResize );
        onResize();
    }
}
