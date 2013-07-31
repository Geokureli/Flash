package  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author George
	 */
	public class TestGraph extends Sprite {
		
		public var graphs:Vector.<Graph>;
		
		public function TestGraph() {
			super();
			
			graphs = new <Graph>[];
			
			var graph:Graph;
			for (var i:int = 0; i < 5; i++) {
				graph = new Graph(0xFF0000);
				addChild(graph);
				graph.y = stage.stageHeight / 2;
				graphs.push(graph);
			}
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			for each(var graph:Graph in graphs)
				graph.tick();
		}
		
	}

}
import flash.display.Shape;
class Graph extends Shape {
	private var color:uint;
	public var weight:Number,
				strength:Number,
				pos:Number,
				interval:Number;
	
	public var values:Vector.<Number>;
	
	public function Graph(color:uint, interval:Number = 5, strength:Number = 20, weight:Number = .5) {
		this.interval = interval;
		this.strength = strength;
		this.weight = weight;
		this.color = color;
		pos = 0;
		graphics.lineStyle(1, color);
		graphics.moveTo(0, 0);
		values = new <Number>[];
	}
	
	public function tick():void {
		var rise:Number = Math.random() * strength * 2 - strength - (Math.random() * pos / strength * weight);
		pos += rise;
		values.push(rise);
		graphics.lineTo(interval * values.length, pos);
	}
}