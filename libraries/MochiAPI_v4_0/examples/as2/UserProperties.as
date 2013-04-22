import mochi.as2.*;
import ui.*;

class UserProperties
{
    public static var myData:Object;
    public static var loggedIn:Boolean;
    
    public static function init():Void
    {
        MochiSocial.addEventListener( MochiSocial.LOGGED_IN, onDataGet );
        MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, clearLogged );
        MochiSocial.addEventListener(MochiSocial.PROPERTIES_SAVED, onDataSet);
        
        myData = { value: "Still loading" };
    }
    
    private static function onDataGet( e:Object ):Void
    {
        loggedIn = true;
        myData = e.userProperties;
    }

    private static function clearLogged():Void
    {
        loggedIn = false;
    }
    
    public static function get menu():Menu
    {
        if( !loggedIn )
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
        return new MenuItem( function():Void {
            UserProperties.myData = { string: item };
            Menu.menu = UserProperties.menu;            
            
            MochiSocial.saveUserProperties( UserProperties.myData );
        }, 'Set data to: ' + item.toUpperCase() );
    }
    
    private static function onDataSet():Void
    {
        Core.popup("Properties were sent to the server");
    }
}
