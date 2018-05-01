package org.superkaka.KLib.data 
{
	/**
	 * K数据类型
	 * 以单字节形式写入，值的范围从0-255
	 * @author ｋａｋａ
	 */
	public class KDataFormat
	{
		
		/**
		 * 未定义类型  不要在代码中使用此类型
		 */
		static public const NONE:int = 0;
		
		static public const BYTE:int = 1;
		
		static public const SHORT:int = 2;
		
		static public const INT:int = 4;
		
		static public const UINT:int = 6;
		
		static public const NUMBER:int = 10;
		
		static public const BOOLEAN:int = 15;
		
		static public const STRING:int = 20;
		
		static public const BINARY:int = 30;
		
		static public const ARRAY:int = 40;
		
		/**
		 * 类型化数组
		 */
		static public const TYPEARRAY:int = 41;
		
		static public const TABLE:int = 50;
		
		static public const DATE:int = 60;
		
		/**
		 * 关联数组	键为字符串
		 */
		static public const OBJECT:int = 120;
		
		/**
		 * 类型化关联数组   值为固定类型的对象
		 */
		static public const TYPEOBJECT:int = 121;
		
		/**
		 * 以对象为键的字典
		 */
		static public const DICTIONARY:int = 123;
		
		
		///字节最高127
		static public const NULL:int = 127;
		
	}

}