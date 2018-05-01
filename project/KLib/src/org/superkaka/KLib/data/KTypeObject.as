package org.superkaka.KLib.data 
{
	import org.superkaka.KLib.utils.ObjectUtil;
	/**
	 * 类型化的关联数组
	 * @author ｋａｋａ
	 */
	public class KTypeObject
	{
		
		/**
		 * 值的类型
		 */
		public var type:int;
		
		public var object:Object = { };
		
		public function KTypeObject(type:int = 0, object:Object = null):void
		{
			
			this.type = type;
			
			if (object != null)
			{
				this.object = object;
			}
			
		}
		
	}

}