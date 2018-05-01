package org.superkaka.KLib.display.ui.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.superkaka.KLib.display.ui.controls.ICellPositionCalculator;
	
	import org.superkaka.KLib.struct.CellData;
	import org.superkaka.KLib.utils.DisplayObjectTool;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * PageContainer 类提供自定义的单元格分布，并通过翻页方式提供大量数据的呈现。
	 * 使用此类必须提供单元格渲染器和单元格坐标计算器以实现单元格的渲染
	 * @author ｋａｋａ
	 */
	
	
	public class PageContainer extends BaseList
	{
		
		protected var _pageSize:int = 10;
		
		protected var _curPage:int;
		
		protected var _maxPage:int;
		
		public function PageContainer(cellRender:* = null, cellPositionCalculator:ICellPositionCalculator = null):void
		{
			
			super(cellRender, cellPositionCalculator);
			
		}
		
		
		/**
		 * 下一页
		 */
		public function nextPage():void
		{
			
			changeCurPage(_curPage + 1);
			
		}
		
		/**
		 * 上一页
		 */
		public function prevPage():void
		{
			
			changeCurPage(_curPage - 1);
			
		}
		
		
		/**
		 * 转到页
		 * @param	index		页数
		 */
		public function gotoPage(index:int):void
		{
			
			changeCurPage(index - 1);
			
		}
		
		protected function changeCurPage(index:int):void
		{
			
			var maxPage:int = _maxPage - 1;
			
			if (maxPage < 0) maxPage = 0;
			
			if (index < 0)
			{
				
				index = 0;
				
			}
			else
			if (index > maxPage)
			{
				
				index = maxPage;
				
			}
			
			if (_curPage != index)
			{
				
				_curPage = index;
				
				update();
				
				dispatchEvent(new UIComponentEvent(UIComponentEvent.PAGE_CHANGE, _curPage));
				
			}
			
		}
		
		/**
		 * 获取最大页数
		 */
		public function get maxPage():int 
		{
			
			return _maxPage;
			
		}
		
		override protected function onListDataChanged():void
		{
			
			updateMaxPage();
			
		}
		
		protected function updateMaxPage():void
		{
			
			_maxPage = Math.ceil(_dataList.length / _pageSize);
			if (_maxPage < 1) _maxPage = 1;
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.PAGE_CHANGE, _curPage));
			
		}
		
		/**
		 * 获取当前页数
		 */
		public function get curPage():int
		{
			return _curPage + 1;
		}
		
		//protected function get pageSize():int 
		public function get pageSize():int 
		{
			return _pageSize;
		}
		
		//protected function set pageSize(value:int):void 
		protected function setPageSize(value:int):void 
		{
			
			_pageSize = value;
			
			updateMaxPage();
			
			update();
			
		}
		
		override protected function update(...args):void
		{
			
			var startIndex:int = _curPage * _pageSize;
			
			var endIndex:int = startIndex + _pageSize;
			
			if (endIndex >= _dataList.length) endIndex = _dataList.length;
			
			renderCell(startIndex, endIndex);
			
		}
		
	}

}