//Code generated with DAME. http://www.dambots.com

package greed.tilemaps
{
	import org.flixel.*;
	public class Level_test extends TileMap
	{
		//Embedded media...
		[Embed(source="../../../res/levels/mapCSV_main_bg.csv", mimeType="application/octet-stream")] public var CSV_mainbg:Class;
		[Embed(source="../../../res/graphics/testTile.png")] public var Img_mainbg:Class;

		//Tilemaps
		public var layermainbg:FlxTilemap;

		//Sprites
		public var mainspritesGroup:FlxGroup = new FlxGroup;


		public function Level_test(addToStage:Boolean = true, onAddSpritesCallback:Function = null)
		{
			// Generate maps.
			layermainbg = new FlxTilemap;
			layermainbg.loadMap( new CSV_mainbg, Img_mainbg, 8,8, FlxTilemap.OFF, 0, 1, 1 );
			layermainbg.x = 0.000000;
			layermainbg.y = 0.000000;
			layermainbg.scrollFactor.x = 1.000000;
			layermainbg.scrollFactor.y = 1.000000;
			
			//Add layers to the master group in correct order.
			masterLayer.add(mainspritesGroup);
			masterLayer.add(layermainbg);
			
			
			if ( addToStage )
			{
				addSpritesForLayermainsprites(onAddSpritesCallback);
				FlxG.state.add(masterLayer);
			}
			
			mainLayer = layermap;
			
		}
		
		override public function addSpritesForLayermainsprites(onAddCallback:Function = null):void
		{
			addSpriteToLayer(Avatar, mainspritesGroup , 104.000, 128.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 112.000, 128.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 128.000, 128.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 120.000, 128.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 248.000, 136.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 224.000, 112.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 200.000, 88.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 176.000, 64.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 152.000, 40.000, 0.000, false, 1, 1, onAddCallback );//""
			addSpriteToLayer(Avatar, mainspritesGroup , 128.000, 16.000, 0.000, false, 1, 1, onAddCallback );//""
		}


	}
}
