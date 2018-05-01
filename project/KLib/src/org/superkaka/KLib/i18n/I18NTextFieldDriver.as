package org.superkaka.KLib.i18n 
{
	import flash.text.TextField;
	import org.superkaka.KLib.i18n.interfaces.I18NComponent;
	/**
	 * 国际化文本组件驱动
	 * @author ｋａｋａ
	 */
	public class I18NTextFieldDriver implements I18NComponent
	{
		
		/**
		 * 被驱动的TextField
		 */
		private var _textField:TextField;
		
		/**
		 * 此驱动组件的国际化文字对象
		 */
		private var _i18nText:I18NText;
		
		/**
		 * 是否开启驱动行为
		 */
		private var _enabled:Boolean = true;
		
		public function I18NTextFieldDriver(textField:TextField = null, i18nText:I18NText = null):void
		{
			
			this._textField = textField;
			
			this._i18nText = i18nText;
			
			///向国际化组件管理器注册自身
			I18NComponentManager.registerComponent(this);
			
			renderText();
			
		}
		
		/**
		 * 获取或设置驱动的TextField实例
		 */
		public function get textField():TextField 
		{
			
			return _textField;
			
		}
		
		public function set textField(value:TextField):void
		{
			
			_textField = value;
			renderText();
			
		}
		
		/**
		 * 获取或设置是否开启驱动行为
		 */
		public function get enabled():Boolean 
		{ 
			
			return _enabled; 
			
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			renderText();
		}
		
		/**
		 * 获取或设置此驱动组件的国际化文字对象
		 */
		public function get i18nText():I18NText 
		{
			return _i18nText;
		}
		
		public function set i18nText(value:I18NText):void 
		{
			_i18nText = value;
			renderText();
		}
		
		/**
		 * 获取或设置文本框的内容
		 */
		public function get text():String 
		{
			return _textField.text;
		}
		
		public function set text(value:String):void 
		{
			_textField.text = value;
		}
		
		/**
		 * 渲染文本
		 */
		private function renderText():void
		{
			
			if (_enabled)
			{
				
				if (_textField == null) return;
				
				if (_i18nText == null) 
				{
					_textField.text = "";
					return;
				}
				
				_textField.text = _i18nText.toString();
				
			}
			
		}
		
		
		/**
		 * 语言切换
		 */
		public function languageChanged(langId:String):void
		{
			renderText();
		}
		
		public function dispose():void
		{
			I18NComponentManager.removeComponent(this);
		}
		
	}

}