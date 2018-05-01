package org.superkaka.KLib.i18n.lang 
{
	import org.superkaka.KLib.i18n.interfaces.I18NLanguagePack;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class BaseLanguagePack implements I18NLanguagePack
	{
		
		/**
		 * 设置或获取语言id
		 */
		private var _langId:String;
		
		protected var dic_text:Object = { };
		
		public function BaseLanguagePack(data:*= null):void
		{
			
			fill(data);
			
		}
		
		/**
		 * 根据传入的原始数据对象添加文本
		 * @param	data
		 */
		final public function fill(data:*):void
		{
			
			if (null != data)
			addTextByData(data);
			
		}
		
		/**
		 * 根据传入的原始数据对象添加文本
		 * @param	data
		 */
		protected function addTextByData(data:*):void
		{
			
			///被子类覆写
			
		}
		
		/**
		 * 添加文本
		 * @param	textId			文本id
		 * @param	text				文本内容
		 */
		public function addText(textId:String, text:String):void
		{
			
			dic_text[textId] = text;
			
		}
		
		/**
		 * 获取文本内容
		 * @param	textId			文本id
		 * @return
		 */
		public function getText(textId:String):String
		{
			return dic_text[textId];
		}
		
		
		/**
		 * 设置或获取语言id
		 */
		public function get langId():String 
		{
			return _langId;
		}
		
		public function set langId(value:String):void 
		{
			_langId = value;
		}
		
	}

}