package baseball.scenes 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import relic.art.MenuScene;
	import relic.data.events.SceneEvent;
	/**
	 * ...
	 * @author George
	 */
	public class MainMenu extends MenuScene 
	{
		private var editorBtn:Btn, testBtn:Btn, rdmBtn:Btn;
		public function MainMenu() { super(); }
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			addChild(editorBtn = new Btn("Level Editor", 400, 40)).addEventListener(MouseEvent.CLICK, btnClick);
			addChild(testBtn = new Btn("Test Level", 400, 40)).addEventListener(MouseEvent.CLICK, btnClick);
			addChild(rdmBtn = new Btn("Random Level", 400, 40)).addEventListener(MouseEvent.CLICK, btnClick);
			editorBtn.name = "editor";
			testBtn.name = "test";
			rdmBtn.name = "random";
		}
		
		private function btnClick(e:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:e.currentTarget.name } ));
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			testBtn.x = editorBtn.x = rdmBtn.x = stage.stageWidth / 2;
			editorBtn.y = 150;
			testBtn.y = 250;
			rdmBtn.y = 350;
		}
		
		override public function destroy():void {
			super.destroy();
			removeChild(editorBtn);
			editorBtn = null;
			removeChild(testBtn);
			testBtn = null;
			removeChild(rdmBtn);
			rdmBtn = null;
		}
	}

}
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
class Btn extends Sprite {
	static private const textFormat:TextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true, null, null, null, null, "center");
	
	private var onColor:uint = 0x808080,
				offColor:uint = 0xFF;
	private var rect:Rectangle;
	private var text:TextField;
	
	
	public function Btn(txt:String, width:int, height:int) {
		super();
		rect = new Rectangle( -width / 2, -height / 2, width, height);
		addChild(text = new TextField());
		text.text = txt;
		text.width = 150;
		text.setTextFormat(textFormat);
		text.x = -text.width / 2;
		text.y = -10;
		text.selectable = false;
		draw(false);
	}
	public function draw(selected:Boolean):void{
		graphics.beginFill(selected ? onColor : offColor);
		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
	}
}