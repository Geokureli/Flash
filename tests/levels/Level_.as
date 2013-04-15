//Code generated with DAME. http://www.dambots.com

package com
{
	import org.flixel.*;
	public class Level_ extends BaseLevel
	{
		//Embedded media...
		[Embed(source="mapCSV_Group1_Map4.csv", mimeType="application/octet-stream")] public var CSV_Group1Map4:Class;
		[Embed(source="../flixelTest/res/killWalls.png")] public var Img_Group1Map4:Class;

		//Tilemaps
		public var layerGroup1Map4:FlxTilemap;

		//Sprites
		public var Group1Layer1Group:FlxGroup = new FlxGroup;


		public function Level_(addToStage:Boolean = true, onAddSpritesCallback:Function = null)
		{
			// Generate maps.
			layerGroup1Map4 = new FlxTilemap;
			layerGroup1Map4.loadMap( new CSV_Group1Map4, Img_Group1Map4, 8,8, FlxTilemap.OFF, 0, 1, 1 );
			layerGroup1Map4.x = 0.000000;
			layerGroup1Map4.y = -11.000000;
			layerGroup1Map4.scrollFactor.x = 1.000000;
			layerGroup1Map4.scrollFactor.y = 1.000000;

			//Add layers to the master group in correct order.
			masterLayer.add(Group1Layer1Group);
			masterLayer.add(layerGroup1Map4);


			if ( addToStage )
			{
				addSpritesForLayerGroup1Layer1(onAddSpritesCallback);
				FlxG.state.add(masterLayer);
			}

			mainLayer = layer;

			boundsMinX = 0;
			boundsMinY = -11;
			boundsMaxX = 416;
			boundsMaxY = 285;

		}

		override public function addSpritesForLayerGroup1Layer1(onAddCallback:Function = null):void
		{
		}


	}
}
