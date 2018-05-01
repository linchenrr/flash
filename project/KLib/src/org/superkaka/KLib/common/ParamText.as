package org.superkaka.KLib.common 
{
	import org.superkaka.KLib.utils.ObjectUtil;
	/**
	 * 支持参数替换的文字对象
	 * @author ｋａｋａ
	 */
	public class ParamText
	{
		
		public var text:String;
		
		/**
		 * 文本参数集合
		 */
		public var param:Object;
		
		/**
		 * 用于搜索并替换文本参数的正则表达式
		 */
		private const reg:RegExp =/<%(.*?)%>/g;
		
		
		public function ParamText(text:String = "", param:Object = null):void
		{
			
			this.text = text;
			this.param = null == param ? { } : param;
			
		}
		
		/**
		 * 获取此文本的求解字符串
		 * 此方法会根据param参数中定义的参数值对最终文本中对应的参数占位符进行替换，拼接出新的字符串之后再返回
		 * 如果param参数的值是ParamText及其子类同样会调用其toString方法从而形成递归求解
		 * @return
		 */
		public function toString():String
		{
			
			return text.replace(reg, replaceParam);
			
		}
		
		/**
		 * 替换字符串
		 * @param	...args
		 * @return
		 */
		private function replaceParam(...args):String
		{
			
			var paramName:String = args[1];
			
			var par:* = param[paramName];
			
			if (par == null)
			{
				
				return "{未设置参数: <%" + paramName + "%>}";
				
			}
			
			return par.toString();
			
		}
		
	}

}