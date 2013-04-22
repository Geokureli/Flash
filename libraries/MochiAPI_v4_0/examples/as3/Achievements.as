package
{
    import mochi.as3.*;
    import ui.*;
    
    public class Achievements
    {
        private static var _gameAchievements:Array;
        private static var _userAchievements:Array;
    
        public static function init():void
        {
            // We create an empty bundle
            _gameAchievements = new Array();
            _userAchievements = new Array();
            
            MochiEvents.addEventListener( MochiEvents.GAME_ACHIEVEMENTS, onGameAchievements );
            MochiEvents.addEventListener( MochiEvents.ACHIEVEMENTS_OWNED, onUserAchievements );
            MochiEvents.addEventListener( MochiEvents.ACHIEVEMENT_NEW, onNewAchievement );
        }

        public static function get achievements():Array
        {
            var output:Array = new Array();
            var pack:Object = new Object();
            var ach:Object;
            
            for each( ach in _gameAchievements )
            {
                pack[ach.id] = { 
                    owned:false, 
                    score:ach.score,
                    description:ach.description,
                    hidden:ach.hidden,
                    name:ach.name,
                    id: ach.id,
                    imgURL:ach.imgURL };
            }
            
            for each( ach in _userAchievements )
            {
                if( !pack[ach.id] )
                    continue ;

                if( ach.imgURL )
                    pack[ach.id].imgURL = ach.imgURL;
                
                pack[ach.id].owned = true;
                pack[ach.id].name = ach.name;
                pack[ach.id].description = ach.description + " (OWNED)";
            }

            for( var tag:String in pack )
                output.push( pack[tag] );

            return output;
        }

        public static function get menu():Menu
        {
            MochiEvents.setNotifications( { 
                format: MochiEvents.FORMAT_SHORT,
                align: MochiEvents.ALIGN_BOTTOM_RIGHT
            } );
            
            var menu:Array = [ 
                new MenuItem( showAwards, 'Show Awards' ),
                new MenuItem( Core.returnToMain, 'Return to Main Menu' )                
             ];
        
            for each( var ach:Object in achievements )
            {
                menu.unshift( new MenuItem( 
                    getAwardCallback( ach.id ), 
                    ach.name + ": " + ach.description + " (" + ach.score + ")", 
                    ach.imgURL ) );
            }

            return new Menu( "Achievements API Demonstration", menu );
        }
        
        private static function showAwards(e:* = null):void {
            MochiEvents.showAwards();
        }
        
        private static function getAwardCallback(id:String):Function
        {
            return function(e:* = null):void {                
                MochiEvents.unlockAchievement( { id: id } );
            };
        }
        
        private static function onGameAchievements( list:Array ):void
        {
            _gameAchievements = list;
        }
        
        private static function onUserAchievements( list:Array ):void
        {
            _userAchievements = list;
        }
        
        private static function onNewAchievement( obj:Object ):void
        {
            _userAchievements.push(obj);
            Core.MainMenu.menu = menu;
        }
    }
}