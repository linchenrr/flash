package  
{
	import org.superkaka.kakalib.valueobject.BitmapFrameInfo;
	import org.superkaka.kakalib.view.BitmapMovieClip;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 * 带速度属性的BitmapMovieClip
	 */
	public class VBitmapMovieClip extends BitmapMovieClip
	{
		
		public var vx:Number;
		public var vy:Number;
		
		public function VBitmapMovieClip(frameInfo:Vector.<BitmapFrameInfo> = null):void
		{
			super(frameInfo);
		}
		
	}

}