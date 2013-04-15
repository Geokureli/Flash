package baseball.scenes.editor {
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import relic.art.Popup;
	import relic.art.Text;
	import relic.audio.SoundManager;
	import relic.events.PopupEvent;
	
	/**
	 * ...
	 * @author George
	 */
	public class SongPopup extends Popup {
		public var txt_song:Text;
		public function SongPopup() {
			super(
				"Load Song",
				"Enter the name of the embedded song to use.",
				Popup.OK | Popup.CANCEL
			);
		}
		override protected function draw():void {
			super.draw();
			addChild(txt_song = new Text(""));
			txt_song.width = 200;
			txt_song.height = 20;
			txt_song.x = 100;
			txt_song.y = 200;
			txt_song.type = TextFieldType.INPUT;
			txt_song.selectable = txt_song.border = txt_song.background = true;
		}
		override protected function onBtnClick(e:MouseEvent):void {
			dispatchEvent(new PopupEvent(PopupEvent.COMPLETE, e.currentTarget.name, txt_song.text));
		}
		
	}

}