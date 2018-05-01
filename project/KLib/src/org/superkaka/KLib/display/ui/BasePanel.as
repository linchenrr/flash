package org.superkaka.KLib.display.ui 
{
	import flash.display.MovieClip;
	/**
	 * UI面板基类
	 * @author ｋａｋａ
	 */
	public class BasePanel extends BaseUI
	{
		
		/**
		 * 绑定的资源内容
		 */
		protected var _panelMC:MovieClip;
		
		public function BasePanel():void
		{
			
		}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			this._panelMC = _content as MovieClip;
			
		}
		
	}

}