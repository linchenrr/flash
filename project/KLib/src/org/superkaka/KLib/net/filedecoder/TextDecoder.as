package org.superkaka.KLib.net.filedecoder 
{
	import flash.utils.ByteArray;
	/**
	 * 文本文件解码器
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 16:07
	 */
	public class TextDecoder extends FileDecoder 
	{
		
		public function TextDecoder():void 
		{
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			complete(String(source));
		}
		
	}

}