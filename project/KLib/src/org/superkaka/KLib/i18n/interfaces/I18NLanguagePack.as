package org.superkaka.KLib.i18n.interfaces 
{
	
	/**
	 * 国际化语言包接口
	 * @author ｋａｋａ
	 */
	public interface I18NLanguagePack 
	{
		
		/**
		 * 设置或获取语言id
		 * @return
		 */
		function get langId():String;
		
		function set langId(id:String):void;
		
		/**
		 * 获取文本内容
		 * @param	textId			文本id
		 * @return
		 */
		function getText(textId:String):String;
		
		/**
		 * 添加文本
		 * @param	textId			文本id
		 * @param	text				文本内容
		 */
		function addText(textId:String, text:String):void;
		
		/**
		 * 根据传入的原始数据对象添加文本
		 * @param	data
		 */
		function fill(data:*):void;
		
	}
	
}