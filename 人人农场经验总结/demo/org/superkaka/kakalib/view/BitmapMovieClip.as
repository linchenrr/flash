package org.superkaka.kakalib.view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.superkaka.kakalib.valueobject.BitmapFrameInfo;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class BitmapMovieClip extends Sprite
	{
		
		private var v_frame:Vector.<BitmapFrameInfo>;
		
		private var bitmap:Bitmap;
		
		private var curIndex:int;
		private var maxIndex:int;
		
		public function BitmapMovieClip(frameInfo:Vector.<BitmapFrameInfo> = null):void
		{
			bitmap = new Bitmap();
			addChild(bitmap);
			
			this.frameInfo = frameInfo;
		}
		
		public function play():void
		{
			//nextFrame();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function nextFrame():void
		{
			if (curIndex >= maxIndex)
			{
				curIndex = 0;
			}
			
			var f_info:BitmapFrameInfo = v_frame[curIndex];
			bitmap.bitmapData = f_info.bitData;
			bitmap.x = f_info.x;
			bitmap.y = f_info.y;
			
			curIndex += 1;
		}
		
		private function enterFrameHandler(evt:Event):void
		{
			nextFrame();
		}
		
		public function get frameInfo():Vector.<BitmapFrameInfo> { return v_frame; }
		
		public function set frameInfo(value:Vector.<BitmapFrameInfo>):void
		{
			v_frame = value;
			
			bitmap.bitmapData = null;
			
			if (v_frame != null)
			{
				curIndex = 0;
				maxIndex = v_frame.length;
				
				play();
			}
			else
			{
				stop();
			}
		}
		
		//public function get smoothing():Boolean { return bitmap.smoothing; }
		//
		//public function set smoothing(value:Boolean):void 
		//{
			//bitmap.smoothing = value;
		//}
		
		
		
	}

}