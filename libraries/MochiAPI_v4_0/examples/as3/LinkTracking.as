package
{
    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    
    import mochi.as3.*;
    
    public class LinkTracking extends Sprite
    {
        private static const PADDING:int = 4;
        
        public function LinkTracking():void
        {
            var tf:TextField = new TextField();
            tf.text = "Go To MochiGames.com";
            tf.autoSize = TextFieldAutoSize.LEFT; 
            tf.x = PADDING;           
            tf.y = PADDING;           
            tf.selectable = false;
            addChild(tf);
            
            var g:Graphics = graphics;
            g.beginFill( 0xFFFFFF );
            g.lineStyle( 1, 0 );
            g.drawRect( 0, 0, tf.width + PADDING * 2, tf.height + PADDING * 2 );
            g.endFill();

            // Auto position!
            addEventListener( Event.ADDED_TO_STAGE, hook );
        }
        
        private function hook(e:* = null ):void
        {
            MochiServices.addLinkEvent('http://x.mochiads.com/link/4f552b6e009369dc', 'http://www.mochigames.com', this);

            stage.addEventListener( Event.RESIZE, move );
            move();
        }
        
        private function move(e:* = null):void
        {
            x = stage.stageWidth - width;
            y = stage.stageHeight - height;
        }
    }
}