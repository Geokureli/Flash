package
{
    /** 
     **  Please note!  This API is considered deprecated, please refer to the UserData API!
     **  The data size is limited to 4k after JSON enocding.  These limitations do not apply
     **  to the Mochi User Data API.
     **/

    import mochi.as3.*;
    import ui.*;
    
    public class UserProperties
    {
        public static var myData:Object;
        
        public static function init():void
        {
            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, onDataGet );
            MochiSocial.addEventListener(MochiSocial.PROPERTIES_SAVED, onDataSet);
            
            myData = { 'value': "Still loading" };
        }
        
        private static function onDataGet( e:Object ):void
        {
            myData = e.userProperties;
        }
        
        public static function get menu():Menu
        {
            if( !MochiSocial.loggedIn )
            {
                Core.popup("You need to be logged in to use UserProperties");
                return Core.menu;
            }

            var menu:Array = [ 
                itemSetData('A'),
                itemSetData('B'),
                itemSetData('C'),
                new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
             ];

            return new Menu( "User Properties API Demonstration: " + JSON.stringify(myData) , menu );
        }
        
        public static function itemSetData( item:String ):MenuItem
        {
            return new MenuItem( function(e:* = null):void {
                myData = { string: item };
                Core.MainMenu.menu = menu;            
                
                MochiSocial.saveUserProperties( myData );
            }, 'Set data to: ' + item.toUpperCase() );
        }
        
        private static function onDataSet( e:* = null ):void
        {
            Core.popup("Properties were sent to the server");
        }
    }
}