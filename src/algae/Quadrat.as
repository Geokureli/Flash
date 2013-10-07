package algae {
	import algae.phases.BurningPhase;
	import algae.phases.GreenPhase;
	import algae.phases.GrowPhase;
	import algae.phases.Phase;
	import algae.phases.PlayerPhase;
	import algae.phases.PredatorPhase;
	import algae.phases.ShadingPhase;
	import algae.phases.TideInPhase;
	import algae.phases.TideOutPhase;
	import krakel.KrkButton;
	import krakel.KrkLevel;
	import krakel.KrkPhase;
	import krakel.KrkSprite;
	import krakel.KrkText;
	import krakel.KrkTilemap;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author George
	 */
	public class Quadrat extends KrkLevel {
		
		public var txt_b_energy:KrkText,
					txt_r_energy:KrkText,
					txt_phase:KrkText,
					txt_round:KrkText;
		
		public var test_path:FlxPath;
		
		public var btn_continue:KrkButton;
		
		public var tide:KrkSprite;
		
		public var seaweed:AlgaeMap;
		public var heightMap:FlxTilemap;
		public var UIMap:FlxTilemap;
		
		private var _energy1:uint;
		private var _energy2:uint;
		public var phaseNum:uint;
		public var startingPlayer:uint;
		public var roundNum:uint;
		
		public function Quadrat() {
			super();
		}
		
		override public function setParameters(data:XML):void {
			super.setParameters(data);
			
			var heightCsv:String = "";
			var uiCsv:String = "";
			var separator:String;
			var tile:uint;
			
			for (var i:int = 0; i < seaweed.totalTiles; i++) {
				uiCsv += '0';
				tile = seaweed.getTileByIndex(i);
				if (tile == AlgaeMap.BROWN_PLANT
					|| tile == AlgaeMap.RED_PLANT) {
					//
					heightCsv += '1';
				} else heightCsv += '0';
				
				separator = i > 0 && (i+1) % seaweed.widthInTiles == 0 ? '\n' : ',';
				heightCsv += separator;
				uiCsv += separator;
			}
			
			add(heightMap = new FlxTilemap());
			heightMap.loadMap(heightCsv, Imports.HEIGHT_TILES, 64, 64);
			
			add(UIMap = new FlxTilemap());
			UIMap.loadMap(uiCsv, Imports.GROW_TILES, 64, 64);
			
			startGame();
		}
		
		private function startGame():void {
			
			phases = new <KrkPhase>[
				new PlayerPhase(this, true),
				new PlayerPhase(this, false),
				new GreenPhase(this),
				new ShadingPhase(this),
				new BurningPhase(this),
				new TideInPhase(this),
				new PredatorPhase(this),
				new GrowPhase(this),
				new TideOutPhase(this)
			];
			
			roundNum = 0;
			startingPlayer = 1;
			energy1 = energy2 = 99;
			startRound();
		}
		
		public function startRound():void {
			phaseNum = 0;
			roundNum++;
			startNextPhase();
		}
		public function startNextPhase():void {
			if (phaseNum == phases.length)
				endRound();
			else {	
				phase = phases[phaseNum];
				phase.start(endPhase);
			}
		}
		
		private function endRound():void {
			startingPlayer = startingPlayer == 1 ? 2 : 1;
			var temp:KrkPhase = phases[0];
			phases[0] = phases[1];
			phases[1] = temp;
			startRound();
		}
		
		public function endPhase(phase:KrkPhase):void {
			phaseNum++;
			startNextPhase();
		}
		
		public function get energy1():uint { return _energy1; }
		public function set energy1(value:uint):void {
			_energy1 = value;
			txt_b_energy.text = value.toString();
		}
		
		public function get energy2():uint { return _energy2; }
		public function set energy2(value:uint):void {
			_energy2 = value;
			txt_r_energy.text = value.toString();
		}
		
	}

}