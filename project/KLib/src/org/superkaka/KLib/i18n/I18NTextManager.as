package org.superkaka.KLib.i18n 
{
	import org.superkaka.KLib.i18n.interfaces.I18NLanguagePack;
	/**
	 * 国际化多国语言包管理类
	 * @author ｋａｋａ
	 */
	public class I18NTextManager
	{
		/**
		 * 语言包集合
		 */
		static private const map_lang:Object = new Object();
		
		/**
		 * 获取或设置当前语言id
		 */
		static public var currentLangId:String;
		
		/**
		 * 注册语言包
		 * @param	languagePack
		 * @param	langId
		 */
		static public function addLang(languagePack:I18NLanguagePack, langId:String = null):void
		{
			if (langId != null) languagePack.langId = langId;
			if (languagePack.langId == null) throw new Error("语言包没有指定有效的语言id");
			map_lang[languagePack.langId] = languagePack;
			
			///如果还没设置当前语言包则使用此语言包
			if (null == currentLangId)
			currentLangId = langId;
		}
		
		/**
		 * 获取原始文本内容
		 * @param	textId					文本id
		 * @param	langId					语言id，如果省略此参数，则使用当前语言id
		 * @param	compatibleMode		是否启用兼容模式，在兼容模式下此方法会先尝试根据传入的语言id获取文本，如果未取到则会使用当前语言id再次进行获取。默认值为false
		 * @return
		 */
		static public function getRawText(textId:String, langId:String = null, compatibleMode:Boolean = false):String
		{
			
			var str:String = doGetText(textId, langId, compatibleMode);
			
			if (str == null)
			{
				//str = "缺少文本:{" + textId + "}";
				str = "{" + textId + "}";
			}
			
			return str;
			
		}
		
		/**
		 * 查询语言包是否包含指定的文本
		 * @param	textId					文本id
		 * @param	langId					语言id，如果省略此参数，则使用当前语言id
		 * @param	compatibleMode		是否启用兼容模式，在兼容模式下此方法会先尝试根据传入的语言id获取文本，如果未取到则会使用当前语言id再次进行获取。默认值为false
		 * @return
		 */
		static public function hasText(textId:String, langId:String = null, compatibleMode:Boolean = false):Boolean
		{
			
			return doGetText(textId, langId, compatibleMode) != null;
			
		}
		
		/**
		 * 获取文本内容
		 * @param	textId					文本id
		 * @param	param					文本参数 (参数名/参数值对的Object对象)
		 * @param	langId					语言id，如果省略此参数，则使用当前语言id
		 * @return
		 */
		static public function getText(textId:String = null, param:Object = null, langId:String = null):String
		{
			
			return (new I18NText(textId, param, langId)).toString();
			
		}
		
		static private function doGetText(textId:String, langId:String = null, compatibleMode:Boolean = false):String
		{
			
			if (langId == null)
			{
				langId = currentLangId;
			}
			
			var languagePack:I18NLanguagePack = map_lang[langId];
			
			//if (null == languagePack) throw new Error("语言包未设置！");
			if (null == languagePack) return null;
			
			var str:String = languagePack.getText(textId);
			
			if (str == null)
			{
				if (compatibleMode)
				{
					languagePack = map_lang[langId];
					
					str = languagePack.getText(textId);
				}
				
			}
			
			return str;
			
		}
		
	}

}