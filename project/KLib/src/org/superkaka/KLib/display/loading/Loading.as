package org.superkaka.KLib.display.loading 
{
	import flash.display.MovieClip;
	/**
	 * loading控制
	 * @author ｋａｋａ
	 */
	public class Loading implements ILoading
	{
		
		protected var _content:MovieClip;
		
		public function Loading():void
		{
			
			
		}
		
		protected function onContentReady():void
		{
			
			
			
		}
		
		public function get content():MovieClip
		{
			
			return _content;
			
		}
		
		public function set content(mc:MovieClip):void
		{
			
			_content = mc;
			
			if (null == _content) return;
			
			onContentReady();
			
		}
		
		public function setProgress(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void
		{
			
			if (null == _content) return;
			
			onProgressChanged(bytesLoaded, bytesTotal, customData);
			
		}
		
		protected function onProgressChanged(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void
		{
			
			
			
		}
		
		public function dispose():void
		{
			
			if (null == _content) return;
			
			_content.stop();
			
			if (_content.parent)
			{
				_content.parent.removeChild(_content);
			}
			
		}
		
	}

}