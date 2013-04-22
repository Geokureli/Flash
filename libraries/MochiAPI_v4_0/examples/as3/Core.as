package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.*;
    
    import mochi.as3.*;
    import ui.*;
    
    /**
     **  TODO: MochiSocial data calls (blocked)
     **/
    
    public class Core extends Sprite
    {
        public static var MainMenu:Core;
        private var _menu:Menu;
        
        public function Core():void
        {         
            Core.MainMenu = this;
            
            addChild(new EventLog());
            addChild(new LinkTracking());

            addEventListener( Event.ADDED_TO_STAGE, init );
        }

        public static function init( e:Event ):void
        {            
            e.target.removeEventListener( Event.ADDED_TO_STAGE, init );

            popup(  "Welcome to the API Example!\n" +
                    "Click these notices to dismiss them.\n\n" + 
                    "The main menu will appear once\nMochi Services finishes initalizing." );

            MochiServices.addEventListener( MochiServices.CONNECTED, returnToMain );
            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, returnToMain );
            MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, returnToMain );

            Coins.init();
            Social.init();
            UserData.init();
            UserProperties.init();
            Achievements.init();
            Ads.init( e.target );
            
            EventLog.init();
        }

        public static function get menu():Menu
        {
            return new Menu( "Mochi Media Services API " + MochiServices.getVersion(), [ 
               new MenuItem( showAdsMenu, 'Ads API' ),
               new MenuItem( showCoinsMenu, 'Coins API' ),
               new MenuItem( showSocialMenu, 'Social Networking API' ),
               new MenuItem( showUserDataMenu, 'User Data API' ),
               new MenuItem( showAchievementMenu, 'Achievements API' ),
               new MenuItem( showUserPropertiesMenu, 'User Properties API' ),
               new MenuItem( newBallGame, 'Score enabled game example' )
            ] );
        }
        
        public static function popup( message:String ):void
        {
            MainMenu.addChild( new Notification( message ) );
        }

        public static function newBallGame( e:* = null ):void
        {
            MainMenu.addChild( new Score() );
            MainMenu.menu = null;
        }

        public static function hideMenu():void
        {
            MainMenu.menu = null;
        }

        public static function returnToMain(e:* = null):void
        {
            MainMenu.menu = Core.menu;
        }
        
        public static function showAdsMenu(e:* = null):void
        {
            MainMenu.menu = Ads.menu;
        }
        
        public static function showAchievementMenu(e:* = null):void
        {
            MainMenu.menu = Achievements.menu;
        }
    
        public static function showUserDataMenu(e:* = null):void
        {
            MainMenu.menu = UserData.menu;
        }
        
        public static function showUserPropertiesMenu(e:* = null):void
        {
            MainMenu.menu = UserProperties.menu;
        }
        
        public static function showCoinsMenu(e:*):void
        {
            MainMenu.menu = Coins.menu;
        }
        
        public static function showSocialMenu(e:*):void
        {
            MainMenu.menu = Social.menu;
        }
        
        // --- Main menu handlers
        
        public function set menu( menu:Menu ):void
        {
            if( _menu == menu )
                return ;
            
            if( _menu )
                removeChild(_menu);

            _menu = menu;

            if( menu )
            {
                _menu.x = 4;
                _menu.y = 4;

                addChild(menu);
            }
        }        
    }
}