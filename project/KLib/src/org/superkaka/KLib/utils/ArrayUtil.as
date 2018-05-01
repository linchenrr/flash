package org.superkaka.KLib.utils 
{
	import flash.utils.Dictionary;

	/**
	 * 用于简化数组(Array)操作的方法
	 * @author ｋａｋａ
	 */
	public class ArrayUtil
	{
		
		/**
		 * 潜复制数组
		 * @param	arr
		 * @return
		 */
		static public function copyArray(arr:Array):Array
		{
			
			return arr.concat();
			
		}
		
		/**
		 * 获取数组中是否包含指定的对象
		 * @param	arr
		 * @param	value
		 * @return
		 */
		public static function containsValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}
		
		/**
		 * 搜索数组中的相同元素并返回带有相同元素位置信息的键\值对象
		 * @param	array
		 * @return
		 */
		static public function searchSameElementPosition(array:Array):Dictionary
		{
			
			var key_obj:Dictionary=new Dictionary();
			var p:uint =array.length;
			while (p-->0) 
			{
				key_obj[array[p]]?key_obj[array[p]].push(p):key_obj[array[p]] = [p];
			}
			
			var key_obj_c:Object = ObjectUtil.copyObject(key_obj);
			
			for (var key:* in key_obj_c) 
			{
				if (key_obj[key].length == 1)
				{
					key_obj[key] = null;
					delete key_obj[key];
				}
			}
			
			return key_obj;
			
		}
		
		/**
		 * 搜索数组中的相同元素并返回包含符合出现相同元素的元素数组
		 * @param	array
		 * @return
		 */
		static public function searchSameElement(array:Array):Array
		{
			
			var obj_same:Dictionary = searchSameElementPosition(array);
			
			array = [];
			
			for (var key:* in obj_same) 
			{
				
				array.push(key);
				
			}
			
			return array;
			
		}
		
		/**
		 * 快速排序算法
		 * 此方法只用于收藏，不推荐使用。因为内置的 Array.sort(Array.NUMERIC) 方法比这个快十倍
		 * @param	arr			目标数组
		 * @param	left			左边界
		 * @param	right			右边界
		 */
		static public function qsort(arr:Array, left:int, right:int):void
		{
			
			if (left >= right)
			return;
			
			var i:int = left - 1;
			var j:int = right + 1;
			var m:Number = arr[int((i + j) / 2)];
			
			while (true)
			{
				
				while (arr[++i] < m) { };
				
				while (arr[--j] > m) { };
				
				if (i >= j)
				{
					break;
				}
				
				var t:Number = arr[i];
				arr[i] = arr[j];
				arr[j] = t;
				
			}
			
			qsort(arr, left, i - 1);
			qsort(arr, j + 1, right);
			
		}
		
		/**
		 * 冒泡排序算法
		 * 此方法只用于收藏，不推荐使用。因为它实在是非常非常慢...
		 * @param	arr
		 */
		static public function bsort(arr:Array):void
		{
			
			var i:int = 0;
			var c:int = arr.length;
			while (i < c)
			{
				
				var j:int = 0;
				var k:int = c - i - 1;
				while (j < k)
				{
					
					var cur:Number = arr[j];
					var next:Number = arr[j + 1];
					if (cur > next)
					{
						arr[j] = next;
						arr[j + 1] = cur;
					}
					
					j++;
				}
				
				i++;
			}
			
		}
		
	}

}