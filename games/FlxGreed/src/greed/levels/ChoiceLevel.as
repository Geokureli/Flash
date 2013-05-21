package greed.levels {
	import org.flixel.FlxSprite;
	import greed.art.Gold;
	import greed.art.Hero;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author George
	 */
	public class ChoiceLevel extends GreedLevel{
		
		[Embed(source = "../../../res/graphics/greed_props.png")] static public const TILES:Class;
		
		private var coinsUI:FlxText;
		
		public function ChoiceLevel(csv:String) {
			super(csv, TILES);
		}
		override protected function addHUD():void {
			add(hud = new Hud());
			hud.add(coinsUI = new FlxText(FlxG.width - 50, 10, 50, "x 0/" + totalCoins));
			
			var gold:Gold;
			
			hud.add(gold = new Gold(FlxG.width - 60, 10));
			//gold.scale.x = gold.scale.y = 2;
			//gold.alpha = .5
			gold.play("ui");
			
			(hud as Hud).treasureTotal = 3;
		}
		
		override public function set coins(value:int):void {
			super.coins = value;
			if(coinsUI != null)
				coinsUI.text = "x " + coins + "/" + totalCoins;
		}
		
		override public function set treasure(value:uint):void {
			super.treasure = value;
			if (hud != null)
				(hud as Hud).treasureCollected = value;
		}
		
	}

}
import greed.art.Treasure;
import krakel.HUD;
import krakel.KrkSprite;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
class Hud extends HUD {
	
	private var _treasureCollected:uint;
	private var treasure:Vector.<Treasure>;
	
	public function Hud() {
		super();
		treasure = new <Treasure>[];
		treasureTotal = 0;
		treasureCollected = 0;
	}
	
	public function get treasureCollected():uint { return _treasureCollected; }
	public function set treasureCollected(value:uint):void {
		
		while (_treasureCollected < value) {
			treasure[_treasureCollected].filters.pop();
			treasure[_treasureCollected].dirty = true;
			_treasureCollected++;
		}
		
		while (_treasureCollected > value) {
			_treasureCollected--;
			treasure[_treasureCollected].dirty = true;
			treasure[_treasureCollected].filters.push(KrkSprite.desaturate);
		}
		
	}
	
	public function get treasureTotal():uint { return treasure.length; }
	
	public function set treasureTotal(value:uint):void {
		var gem:Treasure;
		while (treasure.length < value) {
			add(gem = new Treasure(FlxG.width - 60 + 16 * treasure.length, 20));
			gem.play(Treasure.ORDER[treasure.length]);
			gem.filters = new <Function>[KrkSprite.desaturate];
			gem.dirty = true;
			treasure.push(gem);
		}
		while (treasure.length > value)
			remove(treasure.pop());
	}
	override public function destroy():void {
		treasureTotal = 0;
		super.destroy();
	}
}