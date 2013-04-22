import mochi.as2.*;
import ui.*;

class Social
{
    public static function init():Void
    {
    }

    public static function get menu():Menu
    {
        var items:Array = [
            new MenuItem( showLoginWidget, 'Show login widget' ),
            new MenuItem( hideLoginWidget, 'Hide login widget' ),
            new MenuItem( showProfile, 'Show user profile' ),
            new MenuItem( inviteUser, 'Send a friend invitaton' ),
            new MenuItem( postToStream, "Post a message to the user's stream" ),
            new MenuItem( followDeveloper, 'Ask user to follow your stream' ),
            new MenuItem( doGetFriendsList, 'Get friends list' ),
            new MenuItem( Core.returnToMain, 'Return to Main Menu' )
        ];

        if( Coins.giftables && Coins.giftables.length > 0 )
        {
            items.unshift( new MenuItem( inviteUserGift, 'Invite user to play (with gift)' ) );
            items.unshift( new MenuItem( postToStreamGift, 'Post item offer to stream!' ) );
        }

        // This call only works if the user is not logged in.
        if( !UserProperties.loggedIn )
            items.unshift( new MenuItem( doLoginRequest, 'Request user login' ) );

        return new Menu( 'MochiSocial API Demonstration', items );
    }

    public static function showProfile():Void
    {
        MochiSocial.showProfile();
    }

    public static function doGetFriendsList():Void
    {
        MochiSocial.getFriendsList();
    }

    public static function followDeveloper():Void
    {
        MochiSocial.requestFan();

        MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
    }
    
    public static function inviteUser():Void
    {
        MochiSocial.inviteFriends( {
            message: 'Come join me in playing an API Example!',
            locked: true
        } );

        MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
    }
    
    public static function postToStream():Void
    {
        MochiSocial.postToStream( {
            message: "I'm totally posting this to my stream!",
            locked: true
        } );

        MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
    }
    
    public static function inviteUserGift():Void
    {
        MochiSocial.inviteFriends( {
            message: 'Play this game, get a free item!',
            item: Coins.giftables[0]
        } );

        MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
    }
    
    public static function postToStreamGift():Void
    {
        MochiSocial.postToStream( {
            message: "Greatest game evar!  Now with presents!",
            item: Coins.giftables[0]
        } );

        MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
    }
    
    private static function actionComplete( e:Object ):Void
    {
        MochiSocial.removeEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.removeEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );

        Core.popup( e.call + " completed successfully!" );
        
        // This is normally where you would reward a user for posting to their stream,
        // or successfully inviting their friends!
    }
    
    private static function actionCanceled( e:Object ):Void
    {
        MochiSocial.removeEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
        MochiSocial.removeEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );

        Core.popup( e.call + " was canceled!" );
    }
    
    public static function doLoginRequest():Void
    {
        MochiSocial.requestLogin();
    }
    
    public static function showLoginWidget():Void
    {
        MochiSocial.showLoginWidget( { 
            x: 350, 
            y: 5 
        } );
    }
    
    public static function hideLoginWidget():Void
    {
        MochiSocial.hideLoginWidget();
    }
}
