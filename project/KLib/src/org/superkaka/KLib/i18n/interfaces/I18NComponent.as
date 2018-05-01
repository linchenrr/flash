package org.superkaka.KLib.i18n.interfaces 
{
	
	/**
	 * 国际化组件接口
	 * @author ｋａｋａ
	 */
	public interface I18NComponent
	{
		
		/**
		 * 切换语言
		 * @param	langId		语言id
		 */
		function languageChanged(langId:String):void;
		
	}
	
}