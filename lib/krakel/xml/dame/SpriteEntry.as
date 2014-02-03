package krakel.xml.dame {
	import krakel.KrkData;
	/**
	 * ...
	 * @author George
	 */
	public class SpriteEntry extends krakel.xml.dame.Node {
		
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
		
		public var animations:Object;
		public var properties:Object;
		
		public function SpriteEntry(data:XML) { super(data); }
		
		override protected function setProperties():void {
			super.setProperties();
			
			if(data.anims.length() > 0)
				setAnims(data.anims[0].anim);
			
			if(data.properties.length() > 0)
				setCustomProperties(data.properties[0].type.(@hidden == "false"));
		}
		
		private function setAnims(data:XMLList):void {
			animations = { };
			
			for each(var animData:XML in data) {
				
				var anim:Anim = new Anim(animData);
				animations[anim.name] = anim;
			}
		}
		
		private function setCustomProperties(data:XMLList):void {
			properties = { };
			
			for each(var propertyData:XML in data) {
				
				properties[propertyData.@name] = KrkData.CLASS_REFS[propertyData["@typeof"]](propertyData.@value);
			}
		}
	}

}