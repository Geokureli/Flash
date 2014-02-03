package krakel.xml.dame {
	import krakel.xml.dame.delegates.VarDelegate;
	import krakel.xml.XMLParser;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author George
	 */
	public class DameParser extends krakel.xml.dame.Node {
		
		public var version:String
		public var bgColor:uint
		public var viewPos:FlxPoint
		public var firstLayersTop:Boolean;
		public var spriteEntries:Object;
		
		public function DameParser(data:XML) {
			super(data);
		}
		
		override protected function setDefaults():void {
			super.setDefaults();
			
			viewPos = new FlxPoint();
		}
		
		override protected function setProperties():void {
			super.setProperties();
			
			var spriteList:XMLList = data.spriteEntries..sprite;
			
			spriteEntries = { };
			
			var sprite:SpriteEntry;
			for each(var node:XML in spriteList){
				
				sprite = new SpriteEntry(node);
				
				spriteEntries[sprite.name] = sprite;
			}
			
			trace("");
		}
		
		override protected function setChildDelegates():void {
			super.setChildDelegates();
			childDelegates.push(new VarDelegate("version"));
			childDelegates.push(new VarDelegate("bgColor"));
			childDelegates.push(new VarDelegate("viewPos"));
			childDelegates.push(new VarDelegate("firstLayersTop"));
		}
	}
}