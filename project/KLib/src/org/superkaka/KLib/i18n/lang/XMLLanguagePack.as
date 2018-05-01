package org.superkaka.KLib.i18n.lang 
{
	/**
	 * 基于xml数据的国际化语言包
	 * @author ｋａｋａ
	 */
	public class XMLLanguagePack extends BaseLanguagePack
	{
		private var textXML:XML;
		/**
		 * 初始化基于xml数据的国际化语言包
		 */
		public function XMLLanguagePack(data:*= null):void
		{
			super(data);
		}
		
		
		/**
		 * 根据传入的原始数据对象添加文本
		 * @param	data
		 */
		override protected function addTextByData(data:*):void
		{
			
			var xml:XML;
			if (data is XML)
			xml = data;
			else
			xml = XML(String(data));
			
			for each(var textXML:XML in xml.text)
			{
				
				addText(String(textXML.@id), textXML.toString());
				
			}
			
		}
		
	}

}