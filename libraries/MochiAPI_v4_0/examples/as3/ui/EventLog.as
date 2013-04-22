package ui
{
    import flash.utils.getDefinitionByName;
    import flash.utils.describeType;
    import flash.events.Event;
    import flash.text.*;
    
    import flash.display.MovieClip;
    
    import mochi.as3.*;
    
    public class EventLog extends TextField    
    {        
        private static const HOOKS:Array = [ 'MochiServices', 'MochiSocial', 'MochiCoins', 'MochiEvents', 'MochiInventory' ];

        private static var _log:EventLog;

        public function EventLog():void
        {
            styleSheet = new StyleSheet();

            styleSheet.setStyle( ".log", {
                fontFamily: 'sans-serif',
                fontSize: 12,
                textAlign: 'right',
                color: '#000000'
            } );
            
            wordWrap = true;
            multiline = true;
            
            _log = this;
            
            addEventListener( Event.ADDED_TO_STAGE, added );
        }
        
        public static function init():void
        {
            for each( var name:String in HOOKS )
            {
                var space:* = getDefinitionByName("mochi.as3."+name);
                var description:XML = describeType(space);

                for each( var con:XML in description.child('constant') )
                {
                    var constant:String = con.@name.toString();
                    if( constant.toUpperCase() == constant )
                        attach( space, name, constant );
                }
            }
        }
        
        private static function attach( space:*, name:String, event:String ):void
        {
            space.addEventListener( space[event], function(o:Object):void { 
                _log.htmlText += 
                    "<span class='log'>" + 
                    "<br><br>" + (new Date().toString()) +
                    "<br><b>" + name + "." + event + "</b>" + 
                    "<br>" + JSON.stringify( o ) + 
                    "</span>"; 
                    
                _log.scrollV = _log.maxScrollV;
            } );
        }
        
        private function added(e:*=null):void
        {
            stage.addEventListener( Event.RESIZE, fill );
            fill();
        }
        
        private function fill( e:* = null ):void
        {
            _log.width = stage.stageWidth;
            _log.height = stage.stageHeight;
        }
    }
}