package org.superkaka.KLib.common.keyboard 
{
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2013-7-7-星期日 16:27
	 */
	public class KeyDirection 
	{
		
		public static const NONE:int = 0;
        public static const LEFT_UP:int = 1;
        public static const UP:int = 2;
        public static const RIGHT_UP:int = 3;
        public static const RIGHT:int = 4;
        public static const RIGHT_DOWN:int = 5;
        public static const DOWN:int = 6;
        public static const LEFT_DOWN:int = 7;
        public static const LEFT:int = 8;
        
        public static const X_TAG_LEFT:int = 1;
        public static const X_TAG_CENTER:int = 2;
        public static const X_TAG_RIGHT:int = 4;
        public static const Y_TAG_UP:int = 8;
        public static const Y_TAG_MIDDLE:int = 16;
        public static const Y_TAG_DOWN:int = 32;
        private static const TAG:Array = [18, 9, 10, 12, 20, 36, 34, 33, 17];
		
		static public function getDirection(tag_x:int, tag_y:int):int
		{
			
			var index:int = TAG.indexOf(tag_x + tag_y);
			if (index < 0)
			throw new Error("无效的方向值");
			
			return index;
			
		}
		
		static public function getTagX(direction:int):int
		{
			
			var flag:int = TAG[direction];
			
			if (flag & X_TAG_LEFT) return X_TAG_LEFT;
			else if (flag & X_TAG_CENTER) return X_TAG_CENTER;
			else if (flag & X_TAG_RIGHT) return X_TAG_RIGHT;
			
			throw new Error("无效的方向值");
			
		}
		
		static public function getTagY(direction:int):int
		{
			
			var flag:int = TAG[direction];
			
			if (flag & Y_TAG_UP) return Y_TAG_UP;
			else if (flag & Y_TAG_MIDDLE) return Y_TAG_MIDDLE;
			else if (flag & Y_TAG_DOWN) return Y_TAG_DOWN;
			
			throw new Error("无效的方向值");
			
		}
		
		static public function getDirectionX(direction:int):int
		{
			
			var flag:int = TAG[direction];
			
			if (flag & X_TAG_LEFT) return -1;
			else if (flag & X_TAG_CENTER) return 0;
			else if (flag & X_TAG_RIGHT) return 1;
			
			throw new Error("无效的方向值");
			
		}
		
		static public function getDirectionY(direction:int):int
		{
			
			var flag:int = TAG[direction];
			
			if (flag & Y_TAG_UP) return -1;
			else if (flag & Y_TAG_MIDDLE) return 0;
			else if (flag & Y_TAG_DOWN) return 1;
			
			throw new Error("无效的方向值");
			
		}
		
	}

}