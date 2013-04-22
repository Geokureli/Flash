package
{
    import flash.display.Sprite;
    import flash.display.Graphics;

    import flash.geom.Point;
    import flash.text.*;
    import flash.events.*;
    
    import mochi.as3.*;
    
    public class Score extends Sprite
    {
        private static const WALL_WIDTH:int = 16;
        private static const BALL_SIZE:int = 8;
        
        private static const PADDLE_WIDTH:int = 48;
        private static const PADDLE_HEIGHT:int = 16;
        private static const PLAYFIELD_WIDTH:int = 400;
        private static const PLAYFIELD_HEIGHT:int = 300;
                
        // BOARD_O is the board ID, obfuscated to help prevent hacking
        // This value is private and should never be stored plain-text.
        private static const BOARD_O:Object = { n: [11, 12, 5, 13, 10, 15, 0, 11, 1, 6, 0, 3, 2, 3, 5, 5], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
        private static const BOARD_ID:String = BOARD_O.f(0,"");

        private var _scoreDisplay:TextField;
        private var _score:MochiDigits;

        private var _ballPos:Point;
        private var _ballVelocity:Point;
        private var _paddlePos:int;
        private var _speed:Number;
                
        public function Score():void
        {
            _scoreDisplay = new TextField();
            _scoreDisplay.defaultTextFormat = new TextFormat( '_typewriter', 18, 0xFFFFFF, true );
            _scoreDisplay.x = WALL_WIDTH;
            _scoreDisplay.y = WALL_WIDTH;
            _scoreDisplay.selectable = false;
                        
            addChild(_scoreDisplay);
            
            addEventListener( Event.ENTER_FRAME, step );
            addEventListener( Event.ADDED_TO_STAGE, center );
            addEventListener( MouseEvent.MOUSE_MOVE, movePaddle );
            
            MochiSocial.addEventListener( MochiSocial.LOGGED_IN, remove );
            MochiSocial.addEventListener( MochiSocial.LOGGED_OUT, remove );
            
            reset();
        }
        
        private function endGame():void
        {
            MochiScores.showLeaderboard({
                boardID: BOARD_ID, 
                score: _score.value,
                onClose: Core.returnToMain
            });
        }
        
        private function remove( e:* = null ):void
        {
            removeEventListener( Event.ENTER_FRAME, step );
            removeEventListener( Event.ADDED_TO_STAGE, center );
            removeEventListener( MouseEvent.MOUSE_MOVE, movePaddle );
            
            MochiSocial.removeEventListener( MochiSocial.LOGGED_IN, remove );
            MochiSocial.removeEventListener( MochiSocial.LOGGED_OUT, remove );
            
            if( parent )
                parent.removeChild(this);
        }        
        
        public function reset():void
        {
            _score = new MochiDigits(0);
            _scoreDisplay.text = '0';

            _ballVelocity = new Point( 0, 1 );
            _ballPos = new Point( PLAYFIELD_WIDTH / 2, PLAYFIELD_HEIGHT / 2 );
            _paddlePos = (PLAYFIELD_WIDTH - PADDLE_WIDTH) / 2;
            _speed = 4;
            
            redraw();
        }
        
        private function movePaddle( e:MouseEvent = null ):void
        {
            _paddlePos = e.localX - PADDLE_WIDTH / 2;
            
            if( _paddlePos < WALL_WIDTH )
                _paddlePos = WALL_WIDTH;
            else if( _paddlePos >= (PLAYFIELD_WIDTH - PADDLE_WIDTH - WALL_WIDTH) )
                _paddlePos = PLAYFIELD_WIDTH - PADDLE_WIDTH - WALL_WIDTH;
        }
        
        private function center( e:* = null ):void
        {
            x = (stage.stageWidth - width) / 2;
            y = (stage.stageHeight - height) / 2;
        }
        
        private function step( e:* = null ):void
        {
            _ballVelocity.normalize(_speed);
            _ballPos.offset( _ballVelocity.x, _ballVelocity.y );
             
            // HIT THE TOP!
            if( _ballPos.y < WALL_WIDTH + BALL_SIZE )
            {
                _ballPos.offset( -_ballVelocity.x, -_ballVelocity.y );
                _ballVelocity.y = -_ballVelocity.y;
                _speed += 0.05;
            }
            if( _ballPos.x < WALL_WIDTH + BALL_SIZE || _ballPos.x >= PLAYFIELD_WIDTH - WALL_WIDTH - BALL_SIZE )
            {
                _ballPos.offset( -_ballVelocity.x, -_ballVelocity.y );
                _ballVelocity.x = -_ballVelocity.x;
                _speed += 0.05;
            }
            
            if( _ballPos.y > PLAYFIELD_HEIGHT - PADDLE_HEIGHT - BALL_SIZE )
            {
                _ballPos.offset( -_ballVelocity.x, -_ballVelocity.y );
                if( Math.abs( _paddlePos + PADDLE_WIDTH / 2 - _ballPos.x ) > PADDLE_WIDTH / 2 )
                {
                    endGame();
                    remove();
                }
                else
                {                    
                    _ballVelocity = _ballPos.subtract(
                        new Point( _paddlePos + PADDLE_WIDTH / 2, PLAYFIELD_HEIGHT - PADDLE_HEIGHT / 2 ) );
                
                    _scoreDisplay.text = (++_score.value).toString();

                    _speed += 0.1;
                }
            }

            redraw();
        }
        
        private function redraw():void
        {
            var g:Graphics = graphics;

            g.clear();

            // Draw walls
            g.beginFill( 0xFFFFFF );
            g.drawRect( 0, 0, PLAYFIELD_WIDTH, PLAYFIELD_HEIGHT );
            g.endFill();
            
            // Clear playfield
            g.beginFill( 0 );
            g.drawRect( 
                WALL_WIDTH, 
                WALL_WIDTH, 
                PLAYFIELD_WIDTH - WALL_WIDTH * 2, 
                PLAYFIELD_HEIGHT - WALL_WIDTH );
            g.endFill();
            
            // Draw the ball
            g.beginFill( 0xFFFFFF );
            g.drawCircle( _ballPos.x, _ballPos.y, BALL_SIZE );
            g.endFill();
            
            // Draw the paddle
            g.beginFill( 0xFFFFFF );
            g.drawRect( 
                _paddlePos,
                PLAYFIELD_HEIGHT - PADDLE_HEIGHT,
                PADDLE_WIDTH,
                PADDLE_HEIGHT             
                 );
            g.endFill();
        }
    }
}