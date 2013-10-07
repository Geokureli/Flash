package algae.phases {
	import algae.AlgaeMap;
	import algae.Imports;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Anthony
	 */
	public class ShadingPhase extends Phase {
		private var fakeTileGroup:FlxGroup;
		
		public function ShadingPhase(target:FlxBasic) {
			super(target);
			title = "Shading";
		}
		
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			
			var turns:Array = [AlgaeMap.BROWN_PLANT, AlgaeMap.RED_PLANT];
			if(startingPlayer == 2)
				turns = turns.reverse();
			
			fakeTileGroup = new FlxGroup(0);
			for each (var player:uint in turns)
			{
				for (var y:uint = 0; y < seaweed.heightInTiles; ++y)
				{
					for (var x:uint = 0; x < seaweed.widthInTiles; ++x)
					{
						if (seaweed.getTile(x, y) == player)
						{
							if (x > 0)
								killIfShorter(x - 1, y, seaweed.getTile(x, y), heightMap.getTile(x, y));
								
							if (x < seaweed.widthInTiles)
								killIfShorter(x + 1, y, seaweed.getTile(x, y), heightMap.getTile(x, y));
								
							if ( y > 0)
								killIfShorter(x, y - 1, seaweed.getTile(x, y), heightMap.getTile(x, y));
								
							if (y < seaweed.heightInTiles)
								killIfShorter(x, y + 1, seaweed.getTile(x, y), heightMap.getTile(x, y));
						}
					}
				}
			}
			quadrat.add(fakeTileGroup);
			if (fakeTileGroup.members.length > 0)
				TweenMax.allTo(fakeTileGroup.members, 1, { alpha:0, ease:Linear.easeNone }, 0, end);
			else
				end();
		}
		
		protected function killIfShorter(x:uint, y:uint, player:uint, height:uint):void
		{
			var thisHeight:uint = heightMap.getTile(x, y);
			var thisPlayer:uint = seaweed.getTile(x, y);
			if (((thisPlayer == AlgaeMap.GREEN_PLANT || thisPlayer == 1) && height - 1 > thisHeight) 
				|| (thisPlayer != 2 && thisHeight > 0 && height > thisHeight && thisPlayer != 0 && player != thisPlayer))
			{
				fakeTileGroup.maxSize += 1;
				seaweed.setTile(x, y, 0);
				heightMap.setTile(x, y, 0);
				UIMap.setTile(x, y, 0);
				var fakeTile:FlxSprite = new FlxSprite();
				fakeTile.loadGraphic(Imports.SEAWEED_TILES, true, false, 64, 64);
				fakeTile.addAnimation("CorrectFrame", [thisPlayer+10], 0); 
				fakeTile.play("CorrectFrame");
				fakeTile.x = seaweed.x + (64 * x);
				fakeTile.y = seaweed.y + (64 * y);
				fakeTileGroup.add(fakeTile);
			}
		}
		
		override public function end():void {
			fakeTileGroup.clear();
			quadrat.remove(fakeTileGroup);
			
			super.end();
		}
		
		override public function destroy():void {
			super.destroy();
			
			if(fakeTileGroup != null)
				fakeTileGroup.clear();
			fakeTileGroup = null;
		}
		
	}

}