package org.superkaka.KLib.display.ui.components 
{
	import flash.text.TextField;
	/**
	 * 带文字标签的按钮
	 * @author ｋａｋａ
	 */
	public class LabelButton extends Button
	{
		
		protected var _textField:TextField;
		
		public function LabelButton():void
		{
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			_textField = movieClip.getChildByName("textField") as TextField;
			
		}
		
		public function get label():String 
		{
			return _textField.text;
		}
		
		public function set label(value:String):void 
		{
			_textField.text = value;
		}
		
		public function get textField():TextField
		{
			
			return _textField;
			
		}
		
	}

}