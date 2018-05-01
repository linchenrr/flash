package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class ProgressBar extends MovieClipComponent
	{
		
		public var masker:MovieClip;
		public var bar:MovieClip;
		
		protected var _progress:Number = 0;
		
		public function ProgressBar():void
		{
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			if (null != masker)
			bar.mask = masker;
			
			progress = 0;
			
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			
			_progress = value;
			
			if (_progress < 0)
			_progress = 0;
			else
			if (_progress > 1)
			_progress = 1;
			
			bar.x = -bar.width * (1 - _progress);
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.UPDATE, _progress));
			
		}
		
		
		
	}

}