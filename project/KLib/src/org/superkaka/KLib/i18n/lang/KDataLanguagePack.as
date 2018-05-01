package org.superkaka.KLib.i18n.lang
{
	import flash.utils.ByteArray;
	import org.superkaka.KLib.data.KDataPackager;
	import org.superkaka.KLib.data.KTable;
	/**
	 * 基于KData数据的国际化语言包
	 * @author ｋａｋａ
	 */
	public class KDataLanguagePack extends BaseLanguagePack
	{
		
		public function KDataLanguagePack(data:*= null):void
		{
			super(data);
		}
		
		/**
		 * 根据传入的原始数据对象添加文本
		 * @param	data
		 */
		override protected function addTextByData(data:*):void
		{
			
			var table:KTable;
			
			if (data is ByteArray)
			{
				var kd:KDataPackager = new KDataPackager(data);
				table = kd.readTable();
			}
			else
			{
				table = data;
			}
			
			var dataTable:Object = table.getDataHashTable();
			
			for each(var textItem:Object in dataTable)
			{
				
				addText(textItem["id"], textItem["text"]);
				
			}
			
		}
		
	}

}