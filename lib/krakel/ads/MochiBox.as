package krakel.ads {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import mochi.as3.MochiAd;
	import mochi.as3.MochiServices;
	/**
	 * ...
	 * @author George
	 */
	public dynamic class MochiBox extends AdBox {
		
		private var 
					preBox:MovieClip,
					dockBox:MovieClip,
					interBox:MovieClip,
					clickBox:MovieClip;
					
		protected var clickContainer:Sprite;
		
		public var txtSkip:TextField
		
		
		public var id:String;
		
		public function MochiBox(id:String) {
			super();
			this.id = id;
			// --- PRE-GAME AD CONTAINER
			addChild(preBox = new MovieClip());
			// --- DOCK CONTAINER
			addChild(dockBox = new MovieClip());
			// --- INTER-LEVEL CONTAINER
			addChild(interBox = new MovieClip());
			// --- CLICK AWAY ADS CONTAINER
			addChild(clickContainer = new Sprite()).visible = false;
			clickContainer.addChild(clickBox = new MovieClip());
			clickContainer.addChild(txtSkip = new TextField());
			txtSkip.text = "Support our sponsors!\nClick here to skip ad";
			txtSkip.height = txtSkip.textHeight + 10;
			txtSkip.width += 10;
			txtSkip.selectable = false;
		}
		override protected function onAdded(e:Event):void {
			super.onAdded(e);
			
			drawClickContainer();
			
			clickBox.x = (stage.stageWidth - 300) / 2;
			clickBox.y = (stage.stageHeight - 250) / 2;
			
			txtSkip.x = (stage.stageWidth - txtSkip.width) / 2;
			txtSkip.y = (stage.stageHeight - txtSkip.height - clickBox.y - 250) / 2 + clickBox.y + 250;
			txtSkip.name = "skip_ad";
		}
		
		protected function drawClickContainer():void {
			clickContainer.graphics.beginFill(0, .5);
			clickContainer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			clickContainer.graphics.endFill();
			clickContainer.name = "clickContainer";
		}
		
		
		override public function preloaderAd(onComplete:Function):void {
			super.preloaderAd(onComplete);
			
			var obj:Object = {
				clip:interBox,
				id:id,
				res:_width + "x" + _height
			};
			if (onComplete != null) obj.ad_finished = onComplete;
			
			MochiAd.showPreloaderAd(obj);
		}
		override protected function loadDock(position:String):void {
			super.loadDock(position);
			
			var obj:Object = {
				clip:dockBox,
				id:id,
				position:position
			};
			
			MochiAd.loadDock(obj);
		}
		
		override protected function interLevelAd(onComplete:Function):void {
			super.interLevelAd(onComplete);
			
			var obj:Object = {
				clip:interBox,
				id:id,
				res:_width + "x" + _height
			};
			if (onComplete != null) obj.ad_finished = onComplete;
			
			MochiAd.showInterLevelAd(obj);
		}
		override public function clickAwayAd(onComplete:Function):void {
			super.clickAwayAd(onComplete);
			
			clickContainer.visible = true;
			txtSkip.visible = false;
			
			var obj:Object = {
				id:id,
				clip:clickBox,
				ad_loaded:clickAwayLoaded
			}
			if (onComplete != null) obj.ad_finished = onComplete;
			MochiAd.showClickAwayAd(obj);
		}
		
		protected function clickAwayLoaded(width:Number, height:Number):void {
			txtSkip.visible = true;
			clickContainer.addEventListener(MouseEvent.CLICK, dismissClickAway);
		}
		
		protected function dismissClickAway(e:MouseEvent):void {
			MochiAd.unload(clickBox);
			clickContainer.removeEventListener(MouseEvent.CLICK, dismissClickAway);
			clickContainer.visible = false;
		}
		
		//private function getObj(onComplete:Function = null):Object {
			//var obj:Object = {
				//clip:this,
				//id:id,
				//res:_width + "x" + _height
			//};
			//if (onComplete != null) obj.ad_finished = onComplete;
			//return obj;
		//}
		
	}

}