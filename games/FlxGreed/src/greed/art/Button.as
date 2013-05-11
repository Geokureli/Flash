package greed.art {
	import krakel.KrkSprite;
	import krakel.KrkTile;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class Button extends KrkSprite {
		[Embed(source = "../../../res/graphics/button.png")] static private const SHEET:Class;
		private var _style:String,
					_state:String;
		
		public var target:String;
		
		public function Button() {
			super();
			
			loadGraphic(SHEET, true);
			
			addAnimation('up_blue',		[0]);
			addAnimation('down_blue',	[1]);
			addAnimation('up_orange',	[2]);
			addAnimation('down_orange',	[3]);
			_state = "up";
			style = "blue";
		}
		
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			play(_state + '_' + _style);
		}
		
		public function get style():String { return _style; }
		public function set style(value:String):void {
			_style = value;
			play(_state + '_' + _style);
		}
		
		override public function kill():void {
			//super.kill();
			alive = false;
			state = "down";
		}
		override public function revive():void {
			super.revive();
			state = "up";
		}
		
	}

}