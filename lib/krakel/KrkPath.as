package krakel {
	import flash.display.Graphics;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author George
	 */
	public class KrkPath extends FlxPath {
		public var links:Array;
		
		public function KrkPath(nodes:Array=null) {
			super(nodes);
		}
		
		/**
		 * While this doesn't override <code>FlxBasic.drawDebug()</code>, the behavior is very similar.
		 * Based on this path data, it draws a simple lines-and-boxes representation of the path
		 * if the visual debug mode was toggled in the debugger overlay.  You can use <code>debugColor</code>
		 * and <code>debugScrollFactor</code> to control the path's appearance.
		 * 
		 * @param	Camera		The camera object the path will draw to.
		 */
		override public function drawDebug(camera:FlxCamera=null):void {
			if(nodes.length <= 0)
				return;
			
			if(camera == null)
				camera = FlxG.camera;
			
			//Set up our global flash graphics object to draw out the path
			var gfx:Graphics = FlxG.flashGfx;
			gfx.clear();
			
			//Then fill up the object with node and path graphics
			var node:FlxPoint;
			var nextNode:FlxPoint;
			var i:uint = 0;
			var l:uint = nodes.length;
			var j:uint;
			var nextIndex:uint;
			
			var linksDrawn:Array = [];
			var drawTo:FlxPoint = new FlxPoint();
			
			while(i < l) {
				//get a reference to the current node
				node = nodes[i] as FlxPoint;
				
				//find the screen position of the node on this camera
				_point.x = node.x - int(camera.scroll.x*debugScrollFactor.x); //copied from getScreenXY()
				_point.y = node.y - int(camera.scroll.y*debugScrollFactor.y);
				_point.x = int(_point.x + ((_point.x > 0)?0.0000001:-0.0000001));
				_point.y = int(_point.y + ((_point.y > 0)?0.0000001:-0.0000001));
				
				//decide what color this node should be
				var nodeSize:uint = 10;
				var nodeColor:uint = debugColor;
				
				//draw a box for the node
				gfx.beginFill(nodeColor);
				gfx.lineStyle();
				gfx.drawRect(_point.x-nodeSize*0.5,_point.y-nodeSize*0.5,nodeSize,nodeSize);
				gfx.endFill();
				
				j = 0;
				while(j < links[i].length) {
					
					//then find the next node in the path
					var linealpha:Number = 1;
					nextIndex = links[i][j];
					nextNode = nodes[nextIndex];
					
					if (linksDrawn.length <= nextIndex || linksDrawn[nextIndex].indexOf(i) == -1) {
						
						//then draw a line to the next node
						gfx.moveTo(_point.x,_point.y);
						gfx.lineStyle(1,debugColor,linealpha);
						drawTo.x = nextNode.x - int(camera.scroll.x*debugScrollFactor.x); //copied from getScreenXY()
						drawTo.y = nextNode.y - int(camera.scroll.y*debugScrollFactor.y);
						drawTo.x = int(drawTo.x + ((drawTo.x > 0)?0.0000001:-0.0000001));
						drawTo.y = int(drawTo.y + ((drawTo.y > 0)?0.0000001:-0.0000001));
						gfx.lineTo(drawTo.x, drawTo.y);
						
						if(i in linksDrawn)
							linksDrawn[i].push(nextIndex);
						else linksDrawn[i] = [nextIndex];
					}
					j++;
				}
				
				i++;
			}
			
			//then stamp the path down onto the game buffer
			camera.buffer.draw(FlxG.flashGfxSprite);
		}
		
		public function applyTree(links:Array):void {
			this.links = links;
			
			for (var i:String in links) 
				for (var j:String in links[i]) {
					if(links[links[i][j]].indexOf(int(i)) == -1)
						links[links[i][j]].push(int(i));
				}
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
	}

}