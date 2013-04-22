package
{
    import mochi.as3.*;
    import ui.*;
    
    public class Social
    {
        public static function init():void
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
            if( !MochiSocial.loggedIn )
                items.unshift( new MenuItem( doLoginRequest, 'Request user login' ) );

            return new Menu( 'MochiSocial API Demonstration', items );
        }

        public static function showProfile( e:* = null ):void
        {
            MochiSocial.showProfile();
        }

        public static function doGetFriendsList( e:* = null ):void
        {
            MochiSocial.getFriendsList();
        }

        public static function followDeveloper( e:* = null ):void
        {
            MochiSocial.requestFan();

            MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
        }
        
        public static function inviteUser( e:* = null ):void
        {
            MochiSocial.inviteFriends( {
                message: 'Come join me in playing an API Example!',
                locked: true
            } );

            MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
        }
        
        public static function postToStream( e:* = null ):void
        {
            MochiSocial.postToStream( {
                message: "I'm totally posting this to my stream!",
                locked: true
            } );

            MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
        }
        
        public static function inviteUserGift( e:* = null ):void
        {
            MochiSocial.inviteFriends( {
                message: 'Play this game, get a free item!',
                item: Coins.giftables[0]
            } );

            MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
        }
        
        public static function postToStreamGift( e:* = null ):void
        {
            MochiSocial.postToStream( {
                message: "Greatest game evar!  Now with presents!",
                item: Coins.giftables[0]
            } );

            MochiSocial.addEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.addEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );
        }
        
        private static function actionComplete( e:Object ):void
        {
            MochiSocial.removeEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.removeEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );

            Core.popup( e.call + " completed successfully!" );
            
            // This is normally where you would reward a user for posting to their stream,
            // or successfully inviting their friends!
        }
        
        private static function actionCanceled( e:Object ):void
        {
            MochiSocial.removeEventListener( MochiSocial.ACTION_COMPLETE, actionComplete );
            MochiSocial.removeEventListener( MochiSocial.ACTION_CANCELED, actionCanceled );

            Core.popup( e.call + " was canceled!" );
        }
        
        public static function doLoginRequest(e:* = null):void
        {
            MochiSocial.requestLogin();
        }
        
        public static function showLoginWidget(e:* = null):void
        {
            MochiSocial.showLoginWidget( { 
                x: 350, 
                y: 5 
            } );
        }
        
        public static function hideLoginWidget(e:* = null):void
        {
            MochiSocial.hideLoginWidget();
        }
    }
}