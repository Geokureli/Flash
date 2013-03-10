package relic.art.blitting 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
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
			if (blit._parent)
				blit._parent.remove(blit);
			children.push(blit);
			blit._parent = this;
			blit.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
			return blit;
		}
		
		public function remove(blit:Blit):Blit {
			var i:int = children.indexOf(blit.name);
			if (i == -1) return blit;
			children.splice(i, 1);
			blit._parent = null;
			blit.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
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