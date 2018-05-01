package org.superkaka.KLib.net.filedecoder 
{
	import flash.utils.ByteArray;
	/**
	 * 文件解码器
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 15:55
	 */
	public class FileDecoder
	{
		
		private var onComplete:Function;
		
		public function FileDecoder():void
		{
			
		}
		
		/**
		 * 解码文件
		 * @param	source					需要进行解码文件的原始二进制
		 * @param	onComplete				解码完成接收结果的处理函数
		 * @param	decodeContext		解码需要的自定义附加选项
		 */
		final public function decode(source:ByteArray, onComplete:Function):void
		{
			this.onComplete = onComplete;
			onDecode(source);
		}
		
		protected function onDecode(source:ByteArray):void
		{
			///由子类实现具体文件的解码过程
		}
		
		final protected function complete(result:*):void
		{
			onComplete(result);
		}
		
	}

}