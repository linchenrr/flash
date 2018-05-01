package org.superkaka.KLib.net.filedecoder 
{
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * 音频文件解码器
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 16:32
	 */
	public class SoundDecoder extends FileDecoder 
	{
		
		public function SoundDecoder():void 
		{
			
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			var sound:Sound = new Sound();
			sound.loadCompressedDataFromByteArray(source, source.length);
			complete(sound);
		}
		
	}

}