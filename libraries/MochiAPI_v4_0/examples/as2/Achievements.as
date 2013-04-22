import mochi.as2.*;
import ui.*;

class Achievements
{
    private static var _gameAchievements:Array;
    private static var _userAchievements:Array;

    private static var _update:Boolean = false;

    public static function init():Void
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
        
        for( var i = 0; i < _gameAchievements.length; i++ )
        {
            ach = _gameAchievements[i];
            
            pack[ach.id] = { 
                owned:false, 
                score:ach.score,
                description:ach.description,
                hidden:ach.hidden,
                name:ach.name,
                id: ach.id,
                imgURL:ach.imgURL };
        }
        
        for( var i = 0; i < _userAchievements.length; i++ )
        {
            ach = _userAchievements[i];

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
            align: MochiEvents.ALIGN_BOTTOM,
            format: MochiEvents.FORMAT_SHORT
        } );
        
        var menu:Array = [ 
            new MenuItem( showAwards, 'Show Awards' ),
            new MenuItem( Core.returnToMain, 'Return to Main Menu' )           
         ];
    
        var a = achievements;
        for( var i = 0; i < a.length; i++ )
        {
            var ach:Object = a[i];
            
            menu.unshift( new MenuItem( 
                getAwardCallback( ach.id ), 
                ach.name + ": " + ach.description + " (" + ach.score + ")", 
                ach.imgURL ) );
        }

        return new Menu( "Achievements API Demonstration", menu );
        
        _update = true;
    }

    public static function showAwards():Void
    {
        MochiEvents.showAwards();
    }
    
    private static function getAwardCallback(id:String):Function
    {
        return function():Void {                
            MochiEvents.unlockAchievement( { id: id } );
        };
    }
    
    private static function onGameAchievements( list:Array ):Void
    {
        _gameAchievements = list;
    }
    
    private static function onUserAchievements( list:Array ):Void
    {
        _userAchievements = list;
    }
    
    private static function onNewAchievement( obj:Object ):Void
    {
        _userAchievements.push(obj);
        Menu.menu = menu;
    }
}
