package art 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author George
	 */
	public class Piano extends Sprite 
	{
		static public const BLACK_KEYS:Vector.<Boolean> = Vector.<Boolean>(
			[false, true, false, true, false, false, true, false, true, false, true, false] // --- MAJOR HEPTONIC WWHWWWH
			//[false, true, false, false, true, false, false, true, false, false, true, false] // --- OCTONIC WHWHWHWH
			//[false, true, false, true, false, false, false, false, true, false, true, false] // --- BLUES OCTONIC WWHHHWWH
			//[false, true, false, true, false, true, false, true, false, true, false, true] // --- BLUES OCTONIC WWHHHWWH
			
		); // ---
		
		static public const TOP_KEYS:Vector.<int> = Vector.<int>([87,69,82,84,89,85,73,79,80,219,221]); // --- WERTYUIOP[] (NO Q)
		static public const BOT_KEYS:Vector.<int> = Vector.<int>([65,83,68,70,71,72,74,75,76,186,222,220]); // --- ASDFGHJKL;'\
		
		static public const A_POS:int = 20; // index of A4 (440hz)
		
		public var keyboardMap:Vector.<int>;
		public var keys:Vector.<PianoKey>;
		private var keyLayer:Sprite;
		private var mouseKey:PianoKey;
		private var mouseDown:Boolean;
		
		private var handPos:int,
					keySig:int;
		
		public function Piano(range:int = 4) 
		{
			octave = 0,
			keySig = 0;
			mouseDown = false;
			super();
			redrawHandPosition();
			addChild(keyLayer = new Sprite());
			
			keys = new Vector.<PianoKey>();
			var x:int = 0;
			var key:PianoKey;
			for (var octave:int = 0; octave < range; octave++) {
				for (var i:int = 0; i < 12; i++) {
					if (BLACK_KEYS[i]) {
						key = new PianoKey(keys.length - A_POS, true);
						keys.push(key);
						key.x = x + PianoKey.WHITE_SIZE.width / 2 - PianoKey.WHITE_SIZE.width;
						keyLayer.addChild(key);
					} else {
						key = new PianoKey(keys.length - A_POS);
						key.x = x;
						keyLayer.addChildAt(key,0);
						keys.push(key);
						x += PianoKey.WHITE_SIZE.width;
					}
				}
			}
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function redrawHandPosition():void 
		{
			// --- DRAW RECT
			graphics.clear();
			graphics.lineStyle(1);
			graphics.beginFill(0x8080FF);
			
			var drawPos:int = 0;
			for(var i:int = 0; i < handPos; i++)
				if (!BLACK_KEYS[i%12]) drawPos++;
			graphics.drawRect(drawPos * PianoKey.WHITE_SIZE.width, -20, PianoKey.WHITE_SIZE.width * BOT_KEYS.length, PianoKey.WHITE_SIZE.height + 40);
			
			// --- SET KEY MAPPING
			var b:int = 0;
			i = 0
			keyboardMap = new Vector.<int>();
			//if (handPos > 0 && BLACK_KEYS[(handPos + 11) % 12]){ // --- DOES ROOT HAVE FLAT
				//keyboardMap.push(TOP_KEYS[0]); // --- ADD Q FIRST
				//b++;
			//}
			
			while (i < BOT_KEYS.length) {
				keyboardMap.push(BOT_KEYS[i]);
				//trace(
				if (BLACK_KEYS[(handPos + i+b+1) % 12] && i < BOT_KEYS.length-1){
					keyboardMap.push(TOP_KEYS[i]);
					b++;
				}
				i++;
			}
		}
		private function init(e:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandle);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
		}
		public function destroy():void {
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandle);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyHandle);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			removeEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
		}
		private function keyHandle(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case 16:
					if (e.type == KeyboardEvent.KEY_UP) break;
					if(e.keyLocation == 2)
						shiftHandPos(octave);
					else
						shiftHandPos(-octave);
					break;
				case 39:
					if (e.type == KeyboardEvent.KEY_DOWN)
						shiftHandPos(1);
					break;
				case 37:
					if (e.type == KeyboardEvent.KEY_DOWN)
						shiftHandPos(-1);
					break;
				default:
					var keyPress:int = keyboardMap.indexOf(e.keyCode) + handPos;
					if (e.keyCode == 81) keyPress = handPos-1;
					if(e.type == KeyboardEvent.KEY_DOWN){
						if ((keyPress >= handPos || e.keyCode == 81) && keys[keyPress] != mouseKey) {
							if (mouseKey != null) mouseKey.release();
							mouseKey = keys[keyPress];
							mouseKey.press();
							//sound.play();
						}
					} else if (mouseKey != null && keyPress >= 0 && keys[keyPress] == mouseKey) {
						mouseKey.release();
						mouseKey = null;
					}
			}
		}
		private function shiftHandPos(steps:int):void {
			if (steps > 0) {
				var max:int = keys.length; // --- FURTHEST RIGHT
				for each(var b:Boolean in BLACK_KEYS) if (!b) max--; // --- NUMBER OF WHITE KEYS FROM RIGHT
				
				for (var i:int = 0; i <= steps; i++) {
					if(BLACK_KEYS[(handPos + i) % BLACK_KEYS.length])
						steps++;
				}
				if (handPos + steps < max) {
					handPos += steps;
					redrawHandPosition();
				} else if (handPos < max) {
					handPos = max;
					redrawHandPosition();
				}
			} else {
				for (i = 0; i >= steps; i--) {
					if(BLACK_KEYS[(handPos + 12 + i) % BLACK_KEYS.length])
						steps--;
				}
				//if (BLACK_KEYS[(handPos + 11) % BLACK_KEYS.length])
					//steps--; // --- WHOLE STEP
				if (handPos + steps > 0) {
					trace ( steps);
					handPos += steps;
					redrawHandPosition();
				} else {
					handPos = 0;// --- SHIFT LEFT-MOST
					redrawHandPosition();
				}
			}
		}
		private function mouseHandle(e:MouseEvent):void 
		{
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					if (e.target is PianoKey) {
						var start:Boolean = mouseKey == null;
						mouseKey = e.target as PianoKey;
						//if (start) sound.play();
						mouseKey.press();
					}
					mouseDown = true;
					break;
				case MouseEvent.MOUSE_UP:
					if (mouseKey != null) mouseKey.release();
					mouseKey = null;
					mouseDown = false;
					break;
				case MouseEvent.MOUSE_MOVE:
					if (mouseDown && e.target is PianoKey && e.target != mouseKey) {
						if(mouseKey != null) mouseKey.release();
						mouseKey = e.target as PianoKey;
						mouseKey.press();
					}
					break;
			}
		}
		private function get octave():int {
			var wholeSteps:int = 0;
			for each(var i:Boolean in BLACK_KEYS) {
				if (!i) wholeSteps++;
			}
			return wholeSteps;
		}
		//function getAddSyn(harmonics:Array, time:Number):Number {
			//if (harmonics.length == 1){ // We do not need to perform AS here
				//return getSquarePhase(harmonics[0]["amplitude"], harmonics[0]["wavelength"], time);
			//} else {
				//var hs:Number = 0;
				//hs += 0.5 * (harmonics[0].amplitude * Math.cos(getSquarePhase(harmonics[0]["amplitude"], harmonics[0]["wavelength"], time)));
				// ^ You can try to remove the line above if it does not sound right.
				//for (var i:int = 1; i < harmonics.length; i++){
					//hs += (harmonics[0]["amplitude"] * Math.cos(getSquarePhase(harmonics[0]["amplitude"], harmonics[0]["wavelength"], time)) * Math.cos((Math.PI * 2 * harmonics[0]["frequency"] / samplingFrequency) * time);
					//hs -= Math.sin(getSquarePhase(harmonics[0]["amplitude"], harmonics[0]["wavelength"], time)) * Math.sin((Math.PI * 2 * harmonics[0]["frequency"] / samplingFrequency) * time);
				//}
//
				//return hs;
			//}
		//}
	}
}