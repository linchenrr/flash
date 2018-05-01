package org.superkaka.KLib.net 
{
	/**
	 * 文件类型枚举
	 * @author ｋａｋａ
	 */
	public class FileType
	{
		
		/**
		 * 二进制
		 */
		static public const BIN:String = "bin";
		
		/**
		 * 文本
		 */
		static public const TEXT:String = "text";
		
		/**
		 * XML文件
		 */
		static public const XML:String = "xml";
		
		/**
		 * 语言包
		 */
		static public const LANG:String = "lang";
		
		/**
		 * 数据表
		 */
		static public const TABLE:String = "table";
		
		/**
		 * SWF文件
		 */
		static public const SWF:String = "swf";
		
		/**
		 * 图像（JPG、PNG 或 GIF）文件
		 */
		static public const IMAGE:String = "image";
		
		/**
		 * 声音文件
		 */
		static public const SOUND:String = "sound";
		
		static public function getType(str:String):String
        {
			
			var idx:int = str.lastIndexOf(".");
			if (idx != -1) str = str.substr(idx + 1);
			
            switch (str.toLocaleLowerCase())
            {
                case "swf":
                    return SWF;
                case "image":
                case "jpg":
				case "png":
                case "gif":
                    return IMAGE;
                case "text":
                case "txt":
                    return TEXT;
				case "xml":
				case "html":
                case "htm":
                    return XML;
                case "sound":
                case "mp3":
                case "wav":
                    return SOUND;
				case "table":
				case "ktable":
					return TABLE;
				case "lang":
					return LANG;
					
                default:
                    return BIN;
            };
        }
		
	}

}