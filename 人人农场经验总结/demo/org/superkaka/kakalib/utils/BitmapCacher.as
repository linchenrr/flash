package org.superkaka.kakalib.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.superkaka.kakalib.valueobject.BitmapFrameInfo;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 位图缓存类
	 */
	public class BitmapCacher
	{
		/**
		 * 缓存单张位图
		 * @param	source			要被绘制的目标对象
		 * @param	transparent	是否透明
		 * @param	fillColor			填充色
		 * @return
		 */
		static public function cacheBitmap(source:DisplayObject, transparent:Boolean = true, fillColor:uint = 0x00000000):BitmapFrameInfo
		{
			var rect:Rectangle = source.getBounds(source);
			var x:int = Math.round(rect.x);
			var y:int = Math.round(rect.y);
			var bitData:BitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), transparent, fillColor);
			bitData.draw(source, new Matrix(1, 0, 0, 1, -x, -y));
			
			var bitInfo:BitmapFrameInfo = new BitmapFrameInfo();
			bitInfo.x = x;
			bitInfo.y = y;
			bitInfo.bitData = bitData;
			
			return bitInfo;
		}
		
		/**
		 * 缓存位图动画
		 * @param	mc				要被绘制的影片剪辑
		 * @param	transparent	是否透明
		 * @param	fillColor			填充色
		 * @return
		 */
		static public function cacheBitmapMovie(mc:MovieClip, transparent:Boolean = true, fillColor:uint = 0x00000000):Vector.<BitmapFrameInfo>
		{
			var i:int = 0;
			var c:int = mc.totalFrames;
			
			mc.gotoAndStop(1);
			
			var v_bitInfo:Vector.<BitmapFrameInfo> = new Vector.<BitmapFrameInfo>(c, true);
			
			while (i < c)
			{
				mc.nextFrame();
				v_bitInfo[i] = cacheBitmap(mc, transparent, fillColor);
				i++;
			}
			
			return v_bitInfo;
		}
		
	}

}