package krakel.xml {
	import krakel.helpers.StringHelper;
	import krakel.serial.Serializer;
	/**
	 * ...
	 * @author George
	 */
	public class XMLLevelParser extends XMLParser {
		static public const SPECIAL_PARAMS:String = "layer"
		public function XMLLevelParser(src:XML, target:IScene) {
			super(src, target);
		}
		//override protected function setDefaultProperies():void { super.setDefaultProperies(); }
		
		override public function parse(entry:String = null):void {
			for each(var asset:XML in source.assets.children()) {
				parseNode(asset);
			}
		}
		
		override protected function parseNode(node:XML):void {
			super.parseNode(node);
			
			var special:Object = XMLParser.removeAttributes(node, SPECIAL_PARAMS);
			var obj:Asset = Serializer.createXMLObject(node) as Asset;
			
			if("layer" in special && special.layer != "")
				scene.placeOnLayer(special.layer, scene.assets.add(obj, obj.id, special.groups));
				
			else
				scene.place(scene.assets.add(obj, obj.id, special.groups));
		}
		protected function get scene():IScene { return target as IScene; }
	}

}