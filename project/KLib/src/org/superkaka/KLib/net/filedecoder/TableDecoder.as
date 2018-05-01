package org.superkaka.KLib.net.filedecoder 
{
	import flash.utils.ByteArray;
	import org.superkaka.KLib.data.KDataPackager;
	/**
	 * 数据表解码器
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 20:44
	 */
	public class TableDecoder extends FileDecoder
	{
		
		public function TableDecoder():void 
		{
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			var packager:KDataPackager = new KDataPackager(source);
			complete(packager.readTable());
		}
		
	}

}