package relic.art.blitting 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author George
	 */
	public class BlitLayer {
		internal var children:Vector.<Blit>;
		public function BlitLayer() {
			children = new Vector.<Blit>();
		}
		public function add(blit:Blit):Blit {
			if (blit._parent)
				blit._parent.remove(blit);
			children.push(blit);
			blit._parent = this;
			return blit;
		}
		
		public function remove(blit:Blit):Blit {
			var i:int = children.indexOf(blit.name);
			if (i == -1) return blit;
			children.splice(i, 1);
			return blit;
		}
		
		public function destroy():void {
			while (children.length > 0)
				remove(children.shift());
			children = null;
		}
	}

}