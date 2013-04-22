package
{
    import mochi.as3.*;
    import ui.*;
    
    public class UserData
    {
        private static const MY_KEY:String = 'UserDataKey';
        
        public static var myData:Object;
        
        public static function init():void
        {
            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, getData );
            
            myData = { 'value': "Still loading" };
        }
        
        private static function getData(e:* = null):void
        {
            MochiUserData.get( MY_KEY, onData );
        }
        
        public static function onData(e:MochiUserData):void
        {
            myData = e.data;
            Core.returnToMain();
        }

        public static function get menu():Menu
        {
            if( !MochiSocial.loggedIn )
            {
                Core.popup("You need to be logged in to use MochiUserData");
                return Core.menu;
            }

            var menu:Array = [ 
                itemSetData('A'),
                itemSetData('B'),
                itemSetData('C'),
                new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
             ];

            return new Menu( "User Data API Demonstration: " + JSON.stringify(myData) , menu );
        }
        
        public static function itemSetData( item:String ):MenuItem
        {
            return new MenuItem( function(e:* = null):void {
                myData = { string: item };
                Core.MainMenu.menu = menu;            
                
                MochiUserData.put( MY_KEY, myData, onDataSet );                    
            }, 'Set data to: ' + item.toUpperCase() );
        }
        
        private static function onDataSet( e:* = null ):void
        {
            Core.popup("Data was sent to the server");
        }
    }
}