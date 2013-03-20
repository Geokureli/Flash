package relic.data.xml {
	import relic.art.Asset;
	import relic.art.IScene;
	import relic.art.Scene;
	import relic.data.StringHelper;
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
			var obj:Asset = XMLClasses.createObject(node) as Asset;
			if (special.layer == "") special.layer = "front";
			scene.place(special.layer, scene.add(obj, obj.name, special.groups));
		}
		protected function get scene():IScene { return target as IScene; }
	}

}