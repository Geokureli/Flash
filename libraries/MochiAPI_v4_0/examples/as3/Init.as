package
{
    import flash.utils.getDefinitionByName;
    import flash.display.*;

    import mochi.as3.*;

    public dynamic class Init extends MovieClip
    {
        public static const GAME_ID:String = "84993a1de4031cd8";
        public static const AD_ID:String = "test";  // This is normally your GAME_ID


        public function Init():void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            stop();

            MochiAd.showPreGameAd( {
                skip: true,
                id: AD_ID,              // This is the game ID for displaying ads!
                clip: this,             // We are displaying in a container (which is dynamic)
                ad_finished: start      // Ad has completed
            } );
        }

        private function start():void
        {
            Core;
            var mainClass:Class = getDefinitionByName("Core") as Class;
            stage.addChild( new mainClass() );

            MochiServices.connect( GAME_ID, stage, onFailure );
        }

        private function onFailure(e:* = null):void
        {
            getDefinitionByName("Core").popup('MochiServices failed to connect.');
        }
    }
}