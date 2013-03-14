package relic.art {
	import baseball.scenes.ButtonTestScene;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import relic.data.events.PopupEvent;
	/**
	 * ...
	 * @author George
	 */
	public class Popup extends Asset {
		static public const	OK:uint = 1,
							CANCEL:uint = 2;
		
		static private const	MARGIN:Number = 10,
								HEADER:int = 30;
		private var _width:Number, _height:Number;
		public var title:String, dialogue:String;
		private var txt_title:Text, txt_dialogue:Text;
		private var buttons:uint;
		public function Popup(title:String, dialogue:String, buttons:uint = 0) {
			this.title = title;
			this.dialogue = dialogue;
			this.buttons = buttons;
			super();
			draw();
		}
		override protected function setDefaultValues():void {
			super.setDefaultValues();
			_width = 400;
			_height = 300;
			
			addChild(txt_title = new Text(title));
			addChild(txt_dialogue = new Text(dialogue));
		}
		override protected function init(e:Event):void {
			super.init(e);
			x = (stage.stageWidth - _width) / 2;
			y = (stage.stageHeight - _height) / 2;
		}
		protected function createButton(label:String):Button {
			return new Btn(label);
		}
		protected function draw():void {
			graphics.clear();
			graphics.lineStyle(1);
			graphics.beginFill(0xA0A0A0);
			graphics.drawRect(0, 0, _width, HEADER);
			graphics.beginFill(0x808080);
			graphics.drawRect(0, HEADER, _width, _height-HEADER);
			
			txt_title.width = _width;
			txt_title.height = 20;
			txt_title.y = (HEADER - 20) / 2;
			
			txt_dialogue.width = _width - MARGIN * 2;
			txt_dialogue.x = MARGIN;
			txt_dialogue.y = HEADER + MARGIN;
			
			var numBtns:int = buttons.toString(2).split('1').length - 1;
			var x:int = (_width - (numBtns * (100 + MARGIN) - MARGIN)) / 2;
			var btn:Button;
			if (buttons & OK > 0) {
				addChild(btn = createButton("ok"));
				btn.x = x;
				btn.y = _height - 30 - MARGIN;
				x += 100 + MARGIN;
				btn.name = "ok";
				btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			if (buttons & CANCEL > 0) {
				addChild(btn = createButton("cancel"));
				btn.x = x;
				x += 100 + MARGIN;
				btn.y = _height - 30 - MARGIN;
				btn.name = "cancel";
				btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			
		}
		
		protected function onBtnClick(e:MouseEvent):void {
			dispatchEvent(new PopupEvent(PopupEvent.COMPLETE, e.currentTarget.name));
		}
		
		override public function get width():Number { return super.width; }
		override public function set width(value:Number):void {
			_width = value;
			draw();
			super.width = value;
		}
		override public function get height():Number { return super.height; }
		override public function set height(value:Number):void {
			_height = value;
			draw();
			super.height = value;
		}
	}

}
import relic.art.Button;
import relic.art.Text;

class Btn extends Button {
	public var label:String;
	public var txt_label:Text;
	public function Btn(label:String) {
		this.label = label;
		super();
	}
	override protected function setDefaultValues():void {
		super.setDefaultValues();
		graphics.beginFill(0xFFFFFF);
		graphics.drawRect(0, 0, 100, 30);
		addChild(txt_label = new Text(label));
		txt_label.y = 5;
		txt_label.height = 20;
		txt_label.width = 100;
	}
}