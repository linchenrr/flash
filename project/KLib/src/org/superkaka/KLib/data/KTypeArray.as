package org.superkaka.KLib.data 
{
	/**
	 * 类型化的数组
	 * @author ｋａｋａ
	 */
	public class KTypeArray
	{
		
		/**
		 * 值的类型
		 */
		public var type:int;
		
		public var array:Array = [];
		
		public function KTypeArray(type:int = 0, array:Array = null):void
		{
			
			this.type = type;
			
			if (array != null)
			{
				this.array = array;
			}
			
		}
		
	}

}