package org.superkaka.KLib.data 
{
	/**
	 * 带类型的数据
	 * @author ｋａｋａ
	 */
	public class KTypeData
	{
		
		/**
		 * 类型
		 */
		public var type:int;
		
		/**
		 * 值
		 */
		public var value:*;
		
		/**
		 * 
		 * @param	type			类型
		 * @param	value			值
		 */
		public function KTypeData(type:int = 0, value:*= null):void
		{
			
			this.type = type;
			this.value = value;
			
		}
		
		
	}

}