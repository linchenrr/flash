package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	/**
	 * 包含MovieClip的组件
	 * @author ｋａｋａ
	 */
	public class MovieClipComponent extends BaseUIComponent
	{
		
		protected var movieClip:MovieClip;
		
		public function MovieClipComponent():void
		{
			
		}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			this.movieClip = _content as MovieClip;
			movieClip.stop();
			
		}
		
	}

}