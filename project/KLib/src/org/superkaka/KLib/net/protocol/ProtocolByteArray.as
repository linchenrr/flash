package org.superkaka.KLib.net.protocol
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		linchenrr@163.com
	 * @date		2015/3/20 星期五 14:48
	 */
	public class ProtocolByteArray extends ByteArray
	{
		
		public function ProtocolByteArray(stream:ByteArray = null):void
		{
			if (stream != null)
			writeBytes(stream);
			
			position = 0;
		}
		
		override public function readFloat():Number
        {
            var Integer:int = readInt();
            var Decimal:int = readInt();
            var str:String = Integer + "." + Decimal;
            return Number(str);
        }
		
		override public function writeFloat(value:Number):void
        {
            var str:String = value.toString();
            var index:int = str.indexOf(".");
            var Integer:int = int(str.substr(0, index));
            var Decimal:int =int(str.substr(index + 1));
            writeInt(Integer);
            writeInt(Decimal);
            return;
        }
		
		public function readDate():Date
		{
			return new Date(readUnsignedInt() * 1000);
		}
		
		public function writeDate(value:Date):void
		{
			writeUnsignedInt(value.getTime() / 1000);
		}
		
	}

}