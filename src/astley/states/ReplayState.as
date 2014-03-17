package astley.states {
	import astley.art.ReplayRick;
	import astley.art.Tilemap;
	import astley.data.Beat;
	import astley.data.Recordings;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author George
	 */
	public class ReplayState extends BaseState {
		
		private var _ghosts:FlxGroup;
		private var _finishedGhosts:FlxGroup;
		
		override public function create():void {
			
			//Tilemap.addPipes = false;
			super.create();
			
			onStart();
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			FlxG.worldBounds.width = FlxG.width;
			_ghosts = new FlxGroup();
			_finishedGhosts = new FlxGroup();
		}
		
		override protected function addTileMap():void {
			add(_map = new Tilemap(true));
		}
		
		override protected function addFG():void {
			super.addFG();
			
			add(_ghosts);
			
			var shroud:FlxSprite;
			add(shroud = new FlxSprite());
			shroud.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			shroud.scrollFactor.x = 0;
			shroud.alpha = .5;
		}
		
		override protected function addMG():void {
			super.addMG();
			
			var replay:String;
			var ghost:ReplayRick;
			var longest:int = 0;
			var leadGhost:ReplayRick;
			var length:int;
			do {
				replay = Recordings.getReplay();
				if (replay != null) {
					ghost = new ReplayRick(32, 64, replay);
					_ghosts.add(ghost);
					ghost.playSounds = false;
					length = replay.split('\n').length;
					if (length > longest) {
						
						longest = length;
						leadGhost = ghost;
					}
				} else break;
			} while (replay != null);
			
			leadGhost.playSounds = true;
			setCameraFollow(leadGhost);
		}
		
		override protected function onStart():void {
			super.onStart();
			
			var ghost:ReplayRick;
			var count:int = 0;
			for each(ghost in _ghosts.members) {
				
				if (ghost != null) {
					
					count++;
					ghost.reset(0, 0);
					ghost.start();
				}
			}
		}
		
		override public function update():void {
			super.update();
			for each(var ghost:ReplayRick in _ghosts){
				if (ghost != null && ghost.replayFinished){
					_finishedGhosts.add(ghost);
				}
			}
			FlxG.collide(_finishedGhosts, _map, onGhostHit);
		}
		
		override protected function updateWorldBounds():void {
			super.updateWorldBounds();
			
			FlxG.worldBounds.x = FlxG.camera.scroll.x-1;
		}
		
		private function onGhostHit(ghost:ReplayRick, map:Tilemap):void {
			
			ghost.kill();
		}
	}
}