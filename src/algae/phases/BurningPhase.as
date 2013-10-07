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
	 * @author George
	 */
	public class BurningPhase extends Phase {
		
		private var fakeTileGroup:FlxGroup;
		
		public function BurningPhase(target:FlxBasic) {
			super(target);
			title = "Burning";
		}
		override public function start(endCallBack:Function = null):void {
			super.start(endCallBack);
			
			fakeTileGroup = new FlxGroup(0);
			for (var y:uint = 0; y < seaweed.heightInTiles; ++y)
			{
				for (var x:uint = 0; x < seaweed.widthInTiles; ++x)
				{
					if (seaweed.getTile(x,y) == AlgaeMap.BROWN_PLANT || seaweed.getTile(x,y) == AlgaeMap.RED_PLANT)
					{
						if (x > 0 && (seaweed.getTile(x - 1, y) == AlgaeMap.BROWN_PLANT || seaweed.getTile(x - 1, y) == AlgaeMap.RED_PLANT)) continue;
						if (x < seaweed.widthInTiles && (seaweed.getTile(x + 1, y) == AlgaeMap.BROWN_PLANT || seaweed.getTile(x + 1, y) == AlgaeMap.RED_PLANT)) continue;
						if (y > 0 && (seaweed.getTile(x, y - 1) == AlgaeMap.BROWN_PLANT || seaweed.getTile(x, y - 1) == AlgaeMap.RED_PLANT)) continue;
						if (y < seaweed.heightInTiles && (seaweed.getTile(x, y + 1) == AlgaeMap.BROWN_PLANT || seaweed.getTile(x, y + 1) == AlgaeMap.RED_PLANT)) continue;
						
						fakeTileGroup.maxSize += 2;
						var fakeTile:FlxSprite = new FlxSprite();
						fakeTile.loadGraphic(Imports.SEAWEED_TILES, true, false, 64, 64);
						fakeTile.addAnimation("CorrectFrame", (seaweed.getTile(x, y) == AlgaeMap.RED_PLANT) ? [3] : [4], 0); 
						fakeTile.play("CorrectFrame");
						fakeTile.x = seaweed.x + (64 * x);
						fakeTile.y = seaweed.y + (64 * y);
						var burnBadge:FlxSprite = new FlxSprite();
						//burnBadge.makeGraphic(16, 16, 0xFFFF0000);
						//burnBadge.loadGraphic(FLAME);
						burnBadge.loadGraphic(Imports.SEAWEED_TILES, true, false, 64, 64);
						burnBadge.addAnimation("Flame", [9]);
						burnBadge.play("Flame");
						burnBadge.x = fakeTile.x;
						burnBadge.y = fakeTile.y;
						fakeTileGroup.add(fakeTile);
						fakeTileGroup.add(burnBadge);
						seaweed.setTile(x, y, 0);
						heightMap.setTile(x, y, 0);
						UIMap.setTile(x, y, 0);
					}
				}
			}
			quadrat.add(fakeTileGroup);
			if (fakeTileGroup.members.length > 0)
				TweenMax.allTo(fakeTileGroup.members, 1, { alpha:0, ease:Linear.easeNone }, 0, end);
			else
				end();
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