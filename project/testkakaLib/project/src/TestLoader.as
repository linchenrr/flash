package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.superkaka.kakalib.control.KeyCode;
	import org.superkaka.kakalib.events.KLoaderEvent;
	import org.superkaka.kakalib.net.loader.KLoader;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	[SWF(width=800, height=600, frameRate=30)]
	public class TestLoader extends Sprite
	{
		var loader:KLoader;
		var txt:TextField = new TextField();
		public function TestLoader():void
		{
			
			loader = new KLoader();
			loader.addEventListener(KLoaderEvent.COMPLETE, comp);
			
			txt.type = TextFieldType.INPUT;
			txt.border = true;
			txt.multiline = false;
			txt.width = stage.stageWidth;
			txt.addEventListener(KeyboardEvent.KEY_DOWN, kd);
			
			txt.y = 200;
			addChild(txt);
			
		}
		
		private function comp(evt:KLoaderEvent):void
		{
			
			trace(String(evt.kLoader.data));
			
		}
		
		private function kd(evt:KeyboardEvent):void
		{
			
			if (evt.keyCode == KeyCode.ENTER)
			{
				loader.load(txt.text);
			}
			
		}
		
	}

}