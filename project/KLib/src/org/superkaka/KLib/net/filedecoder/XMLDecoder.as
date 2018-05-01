package org.superkaka.KLib.net.filedecoder 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 16:09
	 */
	public class XMLDecoder extends FileDecoder 
	{
		
		public function XMLDecoder():void 
		{
			
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			complete(XML(String(source)));
		}
		
	}

}