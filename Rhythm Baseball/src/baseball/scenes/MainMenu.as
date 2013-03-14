package baseball.scenes 
{
	import baseball.Imports;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import relic.art.MenuScene;
	import relic.data.events.SceneEvent;
	import relic.data.Global;
	/**
	 * ...
	 * @author George
	 */
	public class MainMenu extends MenuScene 
	{
		private var editorBtn:Btn, rdmBtn:Btn, testBtn:Btn;
		public function MainMenu() { super(); }
		override protected function addStaticChildren():void {
			super.addStaticChildren();
			
			addChild(editorBtn	= new Btn("Level Editor",	200, 30)).addEventListener(MouseEvent.CLICK, btnClick);
			//addChild(
			testBtn	= new Btn("TMOTTBG",		200, 30)//).addEventListener(MouseEvent.CLICK, testClick);
			addChild(rdmBtn		= new Btn("Random Level",	200, 30)).addEventListener(MouseEvent.CLICK, btnClick);
			editorBtn.name = "editor";
			testBtn.name = "song";
			rdmBtn.name = "random";
		}
		
		private function testClick(e:MouseEvent):void {
			Global.VARS.userLevel = <level bpm="100" speed="10" song="tmottbg"/>
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:e.currentTarget.name } ));
		}
		
		private function btnClick(e:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_CHANGE, { next:e.currentTarget.name } ));
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			editorBtn.x = rdmBtn.x = testBtn.x = stage.stageWidth / 2;
			editorBtn.y = 50;
			testBtn.y = 100;
			rdmBtn.y = 150;
		}
		
		override public function destroy():void {
			super.destroy();
			removeChild(editorBtn);
			editorBtn = null;
			removeChild(rdmBtn);
			rdmBtn = null;
			//removeChild(testBtn);
			testBtn = null;
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