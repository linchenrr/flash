package ui 
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.superkaka.kakalib.core.Application;
	import org.superkaka.kakalib.view.ui.BasePanel;
	import org.superkaka.kakalib.view.ui.components.ScrollBar;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestScrollBar extends BasePanel
	{
		
		public var scrBar:ScrollBar = new ScrollBar(true, true);
		
		public var txt:TextField;
		
		public function TestScrollBar():void
		{
			
		}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		override protected function bindComplete():void
		{
			
			trace("TestScrollBar init", scrBar);
			//txt.width = scrBar.width-200;
			//txt.height = scrBar.height-200;
			txt.autoSize = TextFieldAutoSize.LEFT;
			scrBar.target = txt;
			//scrBar.scaleX = 1.3;
			
			//scrBar.x = 0;
			//scrBar.y = 0;
			scrBar.width*=0.8
			scrBar.height*=0.6
			//scrBar.viewWidth = 400;
			//scrBar.viewHeight = 400;
			
			//scrBar.width = 300;
			//scrBar.height = 300;
			
			//scrBar.scaleX = 0.8;
			//scrBar.scaleY = 0.8;
			
			Application.stage.addEventListener(FocusEvent.FOCUS_IN, sss);
			Application.stage.addEventListener(FocusEvent.FOCUS_OUT, sss);
			
		}
		
		private function sss(evt:FocusEvent):void
		{
			trace(evt.type, evt.target,stage.focus);
		}
		
	}

}