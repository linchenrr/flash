package org.superkaka.kakalib.manager 
{
	import org.superkaka.kakalib.valueobject.BitmapFrameInfo;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class BitmapFrameInfoManager
	{
		
		static private const map_data:Object = { };
		
		/**
		 * 存储位图帧信息序列
		 * @param	id
		 * @param	data
		 */
		static public function storeBitmapFrameInfo(id:String, data:Vector.<BitmapFrameInfo>):void
		{
			map_data[id] = data;
		}
		
		
		/**
		 * 获取位图帧信息序列
		 * @param	id
		 * @return
		 */
		static public function getBitmapFrameInfo(id:String):Vector.<BitmapFrameInfo>
		{
			return map_data[id];
		}
		
	}

}