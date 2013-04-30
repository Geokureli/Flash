package krakel {
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkButtonGroup extends FlxGroup {
		private var x:int,
					y:int;
					
		private var rows:Array;
		
		public var loop:Boolean;
		
		public function KrkButtonGroup() {
			super();
			loop = false;
			x = y = 0;
			rows = [[]];
		}
		
		override public function update():void {
			super.update();
			
			if (members.length > 0 && pressed("W", "A", "S", "D", "UP", "LEFT", "DOWN", "RIGHT")) {
				selected.color = 0xFFFFFF;
				if (pressed("A", "LEFT") && (x > 0 || loop)) {
					if (x == 0) x = rows[y].length - 1;
					else x--;
				} else if (pressed("D", "RIGHT") && (x < rows[y].length - 1 || loop)) {
					if (x == rows[y].length - 1) x = 0;
					else x++;
				} else if (pressed("W", "UP") && (y > 0 || loop) && rows.length > 1) {
					if (y == 0) y = rows.length - 1;
					else y--;
					if (x > rows[y].length) x = rows[y].length - 1;
				} else if (pressed("S", "DOWN") && (y < rows.length - 1 || loop) && rows.length > 1) {
					if (y == rows.length - 1) y = 0;
					else y++;
					if (x > rows[y].length - 1) x = rows[y].length - 1;
				}
				
				selected.color = 0xFFFF00;
			}
			
			if (FlxG.keys.justReleased("ENTER")) selected.onUp();
		}
		public function addButton(btn:FlxButton, row:int = 0):FlxButton {
			while (row >= rows.length) rows.push([]);
			rows[row].push(btn);
			return add(btn) as FlxButton;
		}
		override public function add(object:FlxBasic):FlxBasic {
			maxSize++;
			return super.add(object);
		}
		private function get selected():FlxButton {
			return rows[y][x];
		}
		private function pressed(... args):Boolean {
			for each(var arg:String in args)
				if (FlxG.keys.justPressed(arg)) return true;
			return false;
		}
		
	}

}