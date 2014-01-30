package krakel.xml.dame {
	/**
	 * Serializes and exports all data in a .dam
	 * @author George
	 */
	public class Exporter {
		public var version
		public var bgColor
		public var viewPos
		public var firstLayersTop:Boolean;
		public var spriteEntries:Vector.<SpriteEntry>;
		public function Exporter(project:XML, exportPath:String) {
			
		}
	}
}
import krakel.xml.XMLParser;

class Node {
	
	public var data:XML;
	
	public function Node(data:XML) {
		this.data = data;
		
		setProperties();
	}
	
	protected function setProperties():void {
		XMLParser.setProperties(this, data);
	}
}

class SpriteEntry {
	
	public var idx:int
	public var width:int;
	public var height:int;
	public var preview:int;
	public var anchorX:int;
	public var anchorY:int;
	public var boundsX:int;
	public var boundsY:int;
	public var tileIndex:int;
	public var boundsWidth:int;
	public var boundsHeight:int;
	
	public var name:String;
	public var image:String;
	public var creation:String;
	public var className:String;
	public var constructor:String;
	 
	public var exports:Boolean;
	public var canScale:Boolean;
	public var canRotate:Boolean;
	public var centerAnchor:Boolean;
	public var lockRotation:Boolean;
	public var surfaceObject:Boolean;
	public var canEditFrames:Boolean;
	
	public function SpriteEntry(data:XML) {
		
	}
}