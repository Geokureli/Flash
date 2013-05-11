package krakel {
	/**
	 * ...
	 * @author George
	 */
	public class KrkGraphic {
		private var embed:Class;
		private var animated:Boolean;
		private var reverse:Boolean;
		private var width:uint;
		private var height:uint;
		private var anims:Object;
		
		public function KrkGraphic(embed:Class, animated:Boolean = false, reverse:Boolean = false, width:uint = 0, height:uint = 0, anims:Object = null) {
			this.embed = embed;
			this.animated = animated;
			this.reverse = reverse;
			this.width = width;
			this.height = height;
			this.anims = anims;
		}
		public function load(target:KrkSprite):void {
			target.loadGraphic(embed, animated, reverse, width, height);
			for (var anim:String in anims) {
				if(anims[anim] is Array)
					target.addAnimation(anim, anims[anim]);
				else 
					target.addAnimation(
						anim,
						anims[anim].frames,
						anims[anim].frameRate,
						anims[anim].looped
					);
			}
			if (target.anim != null)
				target.play(target.anim);
		}
	}

}