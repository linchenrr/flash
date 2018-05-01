package org.superkaka.KLib.utils 
{
	/**
	 * 用于简化关联数组(Object)操作的方法
	 * @author ｋａｋａ
	 */
	public class ObjectUtil
	{
		
		/**
		 * 将多个关联数组的键值合并并返回新的关联数组。
		 * 如果传入的关联数组存在相同的键，则位于参数靠前位置的键值会被覆盖
		 * @param	...objs
		 * @return
		 */
		static public function joinObject(...objs):Object
		{
			
			var newObj:Object = new Object();
			
			var i:int = 0;
			var c:int = objs.length;
			while (i < c) 
			{
				
				var obj:Object = objs[i];
				
				for (var key:String in obj)
				{
					newObj[key] = obj[key];
				}
				
				i++;
			}
			
			return newObj;
			
		}
		
		/**
		 * 潜复制关联数组
		 * @param	obj
		 * @return
		 */
		static public function copyObject(obj:Object):Object
		{
			
			var newObj:Object = { };
			
			for (var key:String in obj)
			{
				
				newObj[key] = obj[key];
				
			}
			
			return newObj;
			
		}
		
		/**
		 * 将源对象的所有属性复制到目标对象上
		 * @param	source
		 * @param	target
		 */
		static public function copyTo(source:Object, target:Object):void
		{
			
			for (var key:String in source)
			{
				
				target[key] = source[key];
				
			}
			
		}
		
		/**
		 * 获取关联数组键的数量
		 * @param	obj
		 * @return
		 */
		static public function getKeyNum(obj:Object):int
		{
			
			return getKeys(obj).length;
			
		}
		
		/**
		 * 获取包含关联数组所有键的数组
		 * @param	obj
		 * @return
		 */
		static public function getKeys(obj:Object):Array
		{
			
			var keys:Array = [];
			for(var key:String in obj)
			{
				
				keys.push(key);
				
			}
			
			return keys;
			
		}
		
		/**
		 * 获取包含关联数组所有值的数组
		 * @param	obj
		 * @return
		 */
		static public function getValues(obj:Object):Array
		{
			
			var values:Array = [];
			for each(var value:Object in obj)
			{
				
				values.push(value);
				
			}
			
			return values;
			
		}
		
		/**
		 * 清空关联数组的所有键和值
		 * @param	obj
		 */
		static public function clearObject(obj:Object):void
		{
			
			for(var key:String in obj)
			{
				
				obj[key] = null;
				delete obj[key];
				
			}
			
		}
		
	}

}