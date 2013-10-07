package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import krakel.helpers.Random;
	
	/**
	 * ...
	 * @author George
	 */
	public class Main extends Sprite {
		static private var MAX_NODES:int = 3;
		static public const 
						GRAV:Number = 0.175,
						RADIUS:Number = 12,
						MAX_RADIUS:Number = 20,
						FRICTION:Number = .80;
		
		private var nodes:Vector.<Node>;
		private var dots:Vector.<Dot>;
		private var mouseNode:Node;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//var bg:Shape = new Shape();
			//bg.graphics.beginFill(0x0080FF);
			//bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			//addChild(bg);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			
			createNodes();
			
			//var node:Node = new Node(new Point(stage.stageWidth / 2, stage.stageHeight / 2));
			//addChild(node);
			//nodes = new <Node>[node];
			
			createDots();
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createDots():void {
			
			dots = new <Dot>[];
			
			var points:Vector.<Point> = Random.points(20, stage.stageWidth / 6, stage.stageHeight / 6, stage.stageWidth / 3 * 2, stage.stageHeight / 3 * 2);
			var dot:Dot;
			for each(var point:Point in points) {
				addChild(dot = new Dot(Vec2.castPoint(point)));
				dots.push(dot);
			}
		}
		
		private function createNodes():void {
			nodes = new <Node>[mouseNode = new Node(new Vec2(), 0)];
			
			var node:Node;
			for (var i:int = 0; i < 15; i++) {
				addChild(
					node = new Node(
						Vec2.polarAt(
							// --- CENTER CIRCLE
							stage.stageWidth / 2,
							stage.stageHeight / 2,
							// --- DRAW NODES IN CIRCLE VIA POLAR COORD
							150,
							i / 15 * Math.PI * 2
						),
						RADIUS
					)
				);
				nodes.push(node);
			}
		}
		
		private function mouseHandler(e:MouseEvent):void {
			var p:Vec2 = new Vec2(e.stageX, e.stageY);
			if (getObjectsUnderPoint(p).length > 0) return;
			var node:Node = new Node(p, RADIUS);
			addChild(node);
			nodes.push(node);
		}
		
		private function update(e:Event):void {
			
			var node:Node;
			var closest:Vector.<int>;
			for each(var dot:Dot in dots) {
				dot.acceleration.x = dot.acceleration.y = 0;
				
				for each(node in nodes)
					node.setDistance(dot);
				
				nodes.sort(sortByDistance)
				if (nodes.length == 1) dot.applyGravity(nodes[0]);
				else {
					for (var i:int = 0; i < Math.min(MAX_NODES, nodes.length); i++) {
						dot.applyGravity(nodes[i]);
					}
				}
				dot.update();
			}
		}
		
		private function sortByDistance(node1:Node, node2:Node):Number {
			//if (node1.radius == 0 || node1.radius > node1.distance.length) return -1;
			//if (node2.radius == 0 || node2.radius > node2.distance.length) return 1;
			return node1.distance.length > node2.distance.length ? 1 : -1;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			if (child is Node) {
				var i:int = nodes.indexOf(child);
				if (i > -1) nodes.splice(i, 1);
			}
			return super.removeChild(child);
		}
	}
	
}

import flash.events.Event;
import flash.events.MouseEvent;
import krakel.helpers.Random;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
class Node extends Sprite {
	
	public var position:Vec2,
				distance:Vec2;
	public var radius:Number,
				value:Number;
	
	public var hilite:Boolean,
				drag:Boolean,
				canEdit:Boolean;
	
	public function Node(position:Vec2, radius:Number) {
		this.radius = radius;
		this.position = position;
		
		x = position.x;
		y = position.y;
		
		canEdit = true;
		
		draw();
		
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function draw():void {
		graphics.clear();
		graphics.beginFill(hilite ? 0x3399FF : 0x0044AA);
		graphics.drawCircle(0, 0, radius);
	}
	
	private function onAdded(e:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		
		if (canEdit) {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseHandle);
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandle);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandle);
		}
	}
	
	private function mouseHandle(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				drag = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandle);
				break;
			case MouseEvent.MOUSE_UP:
				if (drag) {
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandle)
					drag = false;
				}
				break;
			case MouseEvent.MOUSE_MOVE:
				position.x = x = e.stageX;
				position.y = y = e.stageY;
				break;
			case MouseEvent.MOUSE_WHEEL:
				radius += e.delta;
				trace(e.delta);
				if (radius > Main.MAX_RADIUS) radius = Main.MAX_RADIUS;
				if (radius <= 0) destroy();
				else draw();
				
				break;
			case MouseEvent.MOUSE_OVER:
				hilite = true;
				draw();
				break;
			case MouseEvent.MOUSE_OUT:
				hilite = false;
				draw();
				break;
		}
	}
	
	public function setDistance(dot:Dot):void {
		distance = position.subtract(dot.position) as Vec2;
		value = distance.dot(dot.velocity)/(dot.velocity.length*distance.length);
	}
	
	public function destroy():void {
		graphics.clear();
		position = distance = null;
		parent.removeChild(this);
	}
}
class Dot extends Shape {
	
	private var path:Vector.<Vec2>;
	
	public var position:Vec2,
				velocity:Vec2,
				acceleration:Vec2;
	
	public function Dot(point:Vec2) {
		this.position = point;
		x = point.x;
		y = point.y;
		
		velocity = new Vec2();
		acceleration = new Vec2();
		
		path = new <Vec2>[];
	}
		
	public function draw():void {
		graphics.clear();
		
		if (path.length < 2) {
			graphics.drawCircle(0, 0, 2);
			return;
		}
		var pos:Vec2 = new Vec2();
		graphics.moveTo(0, 0);
		for (var i:int = path.length - 1; i >= 0; i--) {
			pos.offset(-path[i].x, -path[i].y);
			
			graphics.lineStyle(1, 0xFFFFFF, i/path.length);
			graphics.lineTo(pos.x, pos.y);
		}
	}
	public function update():void {
		
		//acceleration.x *= Random.between(.5, 4, 0);
		//acceleration.y *= Random.between(.5, 4, 0);
		
		position.offset(velocity.x, velocity.y);
		
		x = position.x;
		y = position.y;
		
		if (path.length > 10) {
			path[0].x = velocity.x;
			path[0].y = velocity.y;
			path.push(path.shift());
		} else path.push(velocity.clone());
		draw();
		
		
		velocity.offset(acceleration.x, acceleration.y);
		velocity = velocity.scale(Main.FRICTION);
	}
	
	public function applyGravity(node:Node):void {
		var d:Vec2 = node.distance;
		if (d.length < node.radius) d.normalize(node.radius);
		d.normalize(Math.pow(node.radius * Math.PI, 2) / d.length * Main.GRAV);
		acceleration.offset(d.x, d.y);
	}
}

class Vec2 extends Point {
	public function Vec2(x:Number = 0, y:Number = 0) { super(x, y); }
	
	public function isSameDir(v:Vec2):Boolean {
		return dot(v) > 0;
	}
	
	public function dot(v:Vec2):Number {
		return x * v.x + y * v.y;
	}
	
	override public function add(v:Point):Point {
		return new Vec2(x + v.x, y + v.y);
	}
	
	override public function subtract(v:Point):Point {
		return new Vec2(x - v.x, y - v.y);
	}
	
	public function scale(value:Number):Vec2 {
		return new Vec2(x * value, y * value);
	}
	
	public function get length2():Number { return x * x + y * y; }
	
	public function set length(value:Number):void { 
		var scaler:Number = value/length;
		x = x * scaler;
		y = y * scaler;
	}
	
	public function get angle():Number { return Math.atan2(y, x); }
	public function set angle(value:Number):void { 
		var length:Number = this.length;
		x = length * Math.cos(value);
		y = length * Math.sin(value);
	}
	
	public function get rotation():Number { return angle * 180 / Math.PI; }
	public function set rotation(value:Number):void { angle = value / 180 * Math.PI; }
	
	override public function clone():Point {
		return new Vec2(x, y);
	}
	
	static public function castPoint(p:Point):Vec2 { return new Vec2(p.x, p.y); }
	
	static public function polar(len:Number, angle:Number):Vec2 {
		var v:Vec2 = new Vec2(len);
		v.angle = angle;
		return v;
	}
	static public function polarAt(x:Number, y:Number, len:Number, angle:Number):Vec2 {
		var v:Vec2 = polar(len, angle);
		v.x += x;
		v.y += y;
		return v;
	}
}