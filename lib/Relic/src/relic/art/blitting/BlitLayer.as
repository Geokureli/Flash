package relic.art.blitting 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import relic.data.events.BlitEvent;
	/**
	 * ...
	 * @author George
	 */
	public class BlitLayer {
		internal var parent:Blitmap;
		internal var children:Vector.<Blit>;
		public function BlitLayer() {
			children = new Vector.<Blit>();
		}
		public function add(blit:Blit):Blit {
			if (blit._layer)
				blit._layer.remove(blit);
			children.push(blit);
			blit._layer = this;
			blit.dispatchEvent(new BlitEvent(BlitEvent.ADDED_TO_BLITMAP));
			return blit;
		}
		
		public function remove(blit:Blit):Blit {
			var i:int = children.indexOf(blit);
			if (i == -1) return blit;
			children.splice(i, 1);
			blit._layer = null;
			blit.dispatchEvent(new BlitEvent(BlitEvent.REMOVED_TO_BLITMAP));
			return blit;
		}
		
		public function destroy():void {
			while (children.length > 0)
				remove(children.shift());
			children = null;
			parent = null;
		}
		internal function get stage():Stage { return parent.stage; }
	}

}