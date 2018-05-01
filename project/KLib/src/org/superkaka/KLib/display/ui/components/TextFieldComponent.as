package org.superkaka.KLib.display.ui.components 
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	/**
	 * 基于文本框的组件基类
	 * @author ｋａｋａ
	 */
	
	[Event(name="textInput", type="flash.events.TextEvent")] 

	[Event(name="scroll", type="flash.events.Event")] 

	[Event(name="link", type="flash.events.TextEvent")] 

	[Event(name = "change", type = "flash.events.Event")] 
	
	public class TextFieldComponent extends BaseUIComponent
	{
		
		protected var _textField:TextField;
		
		public function TextFieldComponent():void
		{
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			this._textField = _content as TextField;
			
			_textField.addEventListener(Event.SCROLL, dispatchEvent);
			
		}
		
		/**
		 * 获取此组件内部的TextField实例
		 */
		public function get textField():TextField 
		{
			return _textField;
		}
		
	}

}