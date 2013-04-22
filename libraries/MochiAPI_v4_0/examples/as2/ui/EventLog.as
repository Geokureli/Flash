import mochi.as2.*;
import ui.JSON;

class ui.EventLog
{        
    private static var HOOKS:Array = [ 'MochiServices', 'MochiSocial', 'MochiCoins', 'MochiEvents', 'MochiInventory' ];
    private static var _log:TextField;

    public static function init():Void
    {
        Init.clip.createTextField('_EventLog', _log.getNextHighestDepth(), 0, 0, Stage.width, Stage.height )
        _log = Init.clip._EventLog;

        var styleSheet:TextField.StyleSheet = new TextField.StyleSheet();
        styleSheet.setStyle( '.log', {        
            fontFamily: 'sans-serif',
            fontSize: 12,
            textAlign: 'right',
            color: '#000000'
        } );

        _log.styleSheet = styleSheet;
        _log.multiline = true;
        _log.wordWrap = true;
        
        for( var i:Number = 0; i < HOOKS.length; i++ )
        {
            var name:String = HOOKS[i];
            var space:Object = _global.mochi.as2[name];
            
            for( var constant:String in space )
            {
                if( constant == constant.toUpperCase() && typeof(space[constant]) == 'string' )
                    attach( space, name, constant );
            }
        }

        Core.addEventListener( Core.RESIZED, resize );        
    }
    
    private static function attach( space, name:String, event:String ):Void
    {
        space.addEventListener( space[event], function(o:Object):Void { 
            EventLog._log.htmlText += 
                "<span class='log'>" + 
                "<br><br>" + ((new Date()).toString()) +
                "<br><b>" + name + "." + event + "</b>" + 
                "<br>" + JSON.stringify( o ) + 
                "</span>"; 
                
            EventLog._log.scroll = EventLog._log.maxscroll;
        } );
    }
        
    private static function resize():Void
    {
        _log._width = Stage.width;
        _log._height = Stage.height;
        _log.scroll = _log.maxscroll;
    }
}
