package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 与PageGrid相比，提供了翻页功能
	 * @author ｋａｋａ
	 */
	public class FilpGrid extends PageGrid
	{
		
		public var pageCtrl:PageUpDown;
		
		public function FilpGrid():void
		{
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			pageCtrl.addEventListener(UIComponentEvent.CHANGE, filpPageHandler);
			addEventListener(UIComponentEvent.PAGE_CHANGE, gridPageChangeHandler);
			
		}
		
		protected function gridPageChangeHandler(evt:UIComponentEvent):void
		{
			
			pageCtrl.number = curPage;
			pageCtrl.max = maxPage;
			
		}
		
		protected function filpPageHandler(evt:UIComponentEvent):void
		{
			
			gotoPage(int(evt.data));
			
		}
		
	}

}