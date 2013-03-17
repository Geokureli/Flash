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
		override public function parse(entry:String = null):void {
			for each(var asset:XML in source.assets.children()) {
				parseNode(asset);
			}
		}
		override protected function parseNode(node:XML):void {
			var special:Object = XMLParser.removeAttributes(SPECIAL_PARAMS);
			var obj:Asset = XMLClasses.createObject(node) as Asset;
			if ("layer" in special) special.layer = "front";
			scene.place(special.layer, scene.add(obj, obj.name, special.groups));
		}
		protected function get scene():IScene { return target as IScene; }
	}

}