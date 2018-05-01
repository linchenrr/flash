package org.superkaka.KLib.i18n 
{
	import org.superkaka.KLib.i18n.interfaces.I18NComponent;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 国际化组件更新管理器   实验性
	 */
	public class I18NComponentManager
	{
		/**
		 * 已注册的国际化组件列表
		 */
		static private const list_component:Array = [];
		
		/**
		 * 注册组件
		 * @param	textDriver		要添加注册的组件
		 */
		static public function registerComponent(component:I18NComponent):void
		{
			var index:int = list_component.indexOf(component);
			if (index != -1) return;
			
			list_component.push(component);
		}
		
		/**
		 * 移除组件
		 * @param	textDriver		要移除的组件
		 */
		static public function removeComponent(component:I18NComponent):void
		{
			var index:int = list_component.indexOf(component);
			if (index == -1) return;
			
			list_component.splice(index, 1);
		}
		
		/**
		 * 更新所有组件
		 */
		static public function changeLanguage(langId:String):void
		{
			for each(var component:I18NComponent in list_component)
			{
				component.languageChanged(langId);
			}
		}
		
	}

}