package ui 
{
	import org.superkaka.kakalib.view.ui.components.Grid;
	import org.superkaka.kakalib.view.ui.components.MovieClipComponent;
	import org.superkaka.kakalib.view.ui.components.PageGrid;
	import org.superkaka.kakalib.view.ui.events.UIComponentEvent;

	/**
	 * ...
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