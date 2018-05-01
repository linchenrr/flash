package org.superkaka.KLib.utils 
{
	import org.superkaka.KLib.struct.INIConfig;
	/**
	 * ini 配置文件解析
	 * @author		ｋａｋａ
	 * @Email			superkaka.org@gmail.com
	 * @date			2013/11/29/星期五 10:17
	 */
	public class INIParser 
	{
		/**
		 * (?=pattern)  神器
		 * 执行正向预测先行搜索的子表达式，该表达式匹配处于匹配 pattern 的字符串的起始点的字符串。它是一个非捕获匹配，即不能捕获供以后使用的匹配。例如“Windows (?=95|98|NT|2000)”匹配“Windows 2000”中的“Windows”，而不匹配“Windows 3.1”中的“Windows”。预测先行不占用字符，即发生匹配后，下一匹配的搜索紧随上一匹配之后，而不是在组成预测先行的字符后。
		 */
		static private var reg_section:RegExp =/\[(.*)\]([\s\S]*?)((?=\[.*\])|$)/g;
		static private var reg_keyValue:RegExp =/(.+?)=(.+)/g;
		static private var reg_comment  :RegExp =/^[ \f\t\v]*(#|\/\/|;).*/gm;
		
		static public function parse(source:String):INIConfig
		{
			
			reg_section.lastIndex = 0;
			reg_keyValue.lastIndex = 0;
			reg_comment.lastIndex = 0;
			
			//先去除注释
			source = source.replace(reg_comment, "");
			
			var iniConfig:INIConfig = new INIConfig();
			
			while (true)
			{
				var sectionResult:Object = reg_section.exec(source);
				if (sectionResult == null)
				{
					break;
				}
				
				var sectionName:String = sectionResult[1];
				iniConfig.createSection(sectionName);
				
				var keyValueString:String = sectionResult[2];
				while (true)
				{
					var keyValueResult:Object = reg_keyValue.exec(keyValueString);
					if (keyValueResult == null)
					{
						break;
					}
					
					iniConfig.setValue(sectionName, keyValueResult[1], keyValueResult[2]);
				}
				
			}
			return iniConfig;
		}
		
	}

}