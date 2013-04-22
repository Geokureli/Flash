import mochi.as2.*;
import ui.*;

class Ads
{
    private static var MARGINS:Number = 4;
    private static var _ad:MovieClip;
    
    public static function init():Void
    {
    }
    
    public static function get menu():Menu
    {            
        var items:Array = [
            new MenuItem( showClickAway, 'Show click-away ad' ),
            new MenuItem( hideAd, 'Hide click-away ad' ),
            new MenuItem( showInterLevel, 'Show inter-level ad' ),
            new MenuItem( returnToMain, 'Return to Main Menu' )
        ];

        return new Menu( 'MochiAds API Demonstration', items );
    }
    
    private static function showClickAway():Void
    {
        if( _ad )
            return ;
        
        var depth:Number = Init.clip.getNextHighestDepth();
        
        _ad = Init.clip.createEmptyMovieClip( '_adClip'+depth, depth );
        _ad._x = Stage.width - 300 - MARGINS;
        _ad._y = MARGINS;
        
        MochiAd.showClickAwayAd( {
            id: Init.AD_ID,             // This is the game ID for displaying ads!
            clip: _ad                   // We are displaying in a container (which is dynamic)
        } );
    }
    
    private static function hideAd():Void
    {
        if( !_ad )
            return ;

        MochiAd.unload(_ad);

        _ad.unloadClip();
        _ad = null;
    }
    
    private static function showInterLevel():Void
    {
        if( _ad )
            hideAd();

        Core.hideMenu();
            
        var depth:Number = Init.clip.getNextHighestDepth();
        _ad = Init.clip.createEmptyMovieClip( '_adClip'+depth, depth );
        
        MochiAd.showInterLevelAd( {
            id: Init.AD_ID,             // This is the game ID for displaying ads!
            clip: _ad,                  // We are displaying in a container (which is dynamic)
            ad_finished: returnToMain   // Ad has completed
        } );
    }
    
    private static function returnToMain():Void
    {
        hideAd();
        Core.returnToMain();
    }
}
