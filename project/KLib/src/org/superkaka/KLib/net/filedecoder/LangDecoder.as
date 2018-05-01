package org.superkaka.KLib.net.filedecoder 
{
	import flash.utils.ByteArray;
	
	import org.superkaka.KLib.i18n.lang.*;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 16:10
	 */
	public class LangDecoder extends FileDecoder 
	{
		
		public function LangDecoder():void 
		{
			
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			
			try
			{
				complete(new KDataLanguagePack(source));
				return;
			}
			catch(e:Error) { };
			
			try
			{
				complete(new XMLLanguagePack(source));
				return;
			}
			catch(e:Error) { };
			
			throw new Error("未知的语言包文件格式");
			
		}
		
	}

}