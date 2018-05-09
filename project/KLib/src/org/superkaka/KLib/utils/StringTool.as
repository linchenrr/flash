package org.superkaka.KLib.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class StringTool
	{
		
		/**
		 * 比较两个字符串是否相等
		 * @param	s1
		 * @param	s2
		 * @param	ignoreCase			是否忽略大小写，默认为false
		 * @return
		 */
		public static function equal(s1:String, s2:String, ignoreCase:Boolean = false):Boolean
		{
			
			if(ignoreCase)
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
			else
			{
				return (s1 == s2);
			}
			
		}
		
		/**
		 * 根据制定字符集获取字符串的实际字符数
		 * @param	str
		 * @param	charSet					指定计算的编码方式。默认gb2312编码,一个汉字算2个字符，如果是utf-8编码，则一个汉字算3个字符
		 * @return
		 */
		static public function getStringCharLength(str:String, charSet:String = "gb2312"):uint
		{
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, charSet);
			return bytes.length;
			
		}
		
		/**
		 * 将 String 对象根据指定的模式拆分为一个子字符串数组。此方法与String自身的split不同的是：对空字符串将返回一个长度为0的数组
		 * @param	str
		 * @param	delimiter				指定拆分此字符串的位置的模式。此模式可以是任何类型的对象，但通常为字符串或正则表达式。如果 delimiter 不是正则表达式或字符串，则该方法在执行前会将其转换为字符串。 
		 * @return
		 */
		static public function split(str:String, delimiter:*):Array
		{
			
			if (str == null || str.length == 0)
			{
				return [];
			}
			else
			{
				
				return str.split(delimiter);
				
			}
			
		}
		
		/**
		 * 在指定的索引位置插入字符串
		 * @param	str
		 * @param	insertString			需要插入的字符串
		 * @param	insertIndex				指定插入的位置
		 * @return
		 */
		static public function insert(str:String, insertString:String, insertIndex:int):String
		{
			
			if (insertIndex < 0) insertIndex = str.length + insertIndex;
			return str.substr(0, insertIndex) + insertString + str.substring(insertIndex, str.length);
			
		}
		
		/**
		 * 根据给定的不定数量字符串拼接url，并去掉URL中重复的斜杠"//"转换为单个"/"
		 * @param	...parts
		 * @return
		 */
		static public function joinURL(...parts):String
		{
			
			var str_url:String = "";
			
			var i:int = 0;
			var c:int = parts.length;
			
			while (i < c) 
			{
				
				str_url += parts[i] + "/";
				
				i++;
				
			}
			
			return fixURL(str_url);
			
		}
		
		/**
		 * 修正URL中的斜杠错误
		 * 去除开头和结尾的斜杠
		 * 将URL中重复的两个及以上斜杠"//"转换为单个"/"
		 * @param	str_url
		 * @return
		 */
		static public function fixURL(str_url:String):String
		{
			
			str_url = str_url.replace(/(^\/+)|(\/+$)/g, "");
			str_url=str_url.replace(/\/{2,}/g, "/");
			str_url= str_url.replace(/^http:\/{0,}/, "http://");
			return str_url;
			
		}
		
		/**
		 * 从 String 对象移除指定的前导字符。
		 * @param	str
		 * @param	trimString			指定的字符集，指定要移除的字符串或字符串数组。如果不传此参数，则默认使用所有空白字符集
		 * @return
		 */
		static public function trimStart(str:String, trimString:*= null):String
		{
			
			return doTrim(str, trimString, true, false);
			
		}
		
		/**
		 * 从 String 对象移除指定的尾随字符。
		 * @param	str
		 * @param	trimString			指定的字符集，指定要移除的字符串或字符串数组。如果不传此参数，则默认使用所有空白字符集
		 * @return
		 */
		static public function trimEnd(str:String, trimString:*= null):String
		{
			
			return doTrim(str, trimString, false, true);
			
		}
		
		/**
		 * 从 String 对象移除指定的前导字符和尾随字符。
		 * @param	str
		 * @param	trimString			指定的字符集，指定要移除的字符串或字符串数组。如果不传此参数，则默认使用所有空白字符集
		 * @return
		 */
		static public function trim(str:String, trimString:*= null):String
		{
			
			return doTrim(str, trimString, true, true);
			
		}
		
		static private function doTrim(str:String, trimString:*, trimStart:Boolean, trimEnd:Boolean):String
		{
			
			var regString:String = "(";
			
			if (trimString == null) 
			{
				regString += "\\s";
			}
			else if (trimString is String)
			{
				regString += trimString;
			}
			else if(trimString is Array)
			{
				
				var trimArr:Array = trimString;
				var i:int = 0;
				var c:int = trimArr.length - 1;
				
				while (i < c)
				{
					
					regString += trimArr[i] + "|";
					
					i++;
					
				}
				
				regString += trimArr[i];
				
			}
			
			regString += ")+";
			
			if (trimStart) str = str.replace(new RegExp("^" + regString), "");
			
			if (trimEnd) str = str.replace(new RegExp(regString + "$"), "");
			
			return str;
			
		}
		
		/**
		 * 将字符串中指定的子字符串替换为目标字符串
		 * 相对于String自身的replace不同，此方法会替换所有匹配的字符串
		 * @param	str
		 * @param	pattern
		 * @param	replaceTo
		 * @return
		 */
		static public function replaceAll(str:String, pattern:String, replaceTo:String):String
		{
			
			//正则存在正则字符转义问题，需要在[]\^$.|?*+()前面加上\\
			//return str.replace(new RegExp(pattern, "g"), replaceTo);
			
			//效率稍低
			return str.split(pattern).join(replaceTo);
			
			return str;
			
		}
		
		/**
		 * 判断字符串是否为空字符串
		 * @param	str
		 * @return
		 */
		static public function isEmpty(str:String):Boolean
		{
			
			return str == null || str == "";
			
		}
		
	}

}