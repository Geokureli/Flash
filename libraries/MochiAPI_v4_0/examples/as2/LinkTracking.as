import ui.Drawing;
import mochi.as2.*;

class LinkTracking 
{
    private static var PADDING:Number = 4;
    
    private static var clip:MovieClip;
    
    public static function init():Void
    {
        clip = Init.clip.createEmptyMovieClip( '_linkTracking', Init.clip.getNextHighestDepth() );
        clip.createTextField( '_label', clip.getNextHighestDepth(), PADDING, PADDING, 1, 1 );

        var tf:TextField = clip._label;

        tf.text = "Go To MochiGames.com";
        tf.autoSize = 'left';
        tf.selectable = false;    
        
        clip.beginFill( 0xFFFFFF );
        clip.lineStyle( 1, 0 );
        Drawing.drawBox( clip, 0, 0, tf._width + PADDING * 2, tf._height + PADDING * 2 );
        clip.endFill();

        MochiServices.addLinkEvent('http://x.mochiads.com/link/4f552b6e009369dc', 'http://www.mochigames.com', clip );

        Core.addEventListener( Core.RESIZED, move );
        move();
    }
    
    private static function move():Void
    {
        clip._x = Stage.width - clip._width;
        clip._y = Stage.height - clip._height;
    }
}
