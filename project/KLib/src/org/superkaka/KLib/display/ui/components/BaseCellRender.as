package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.struct.CellData;
	/**
	 * 单元渲染器基类
	 * @author ｋａｋａ
	 */
	public class BaseCellRender extends BaseUIComponent implements ICellRender
	{
		
		protected var _cellData:CellData;
		protected var _selected:Boolean;
		
		public function BaseCellRender(link:String = null):void
		{
			
			if (null != link)
			{
				this.bind(link);
			}
			
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			onSelectChange();
		}
		
		public function get cellData():CellData 
		{
			return _cellData;
		}
		
		public function set cellData(value:CellData):void 
		{
			_cellData = value;
			super.data = _cellData.data;
		}
		
		protected function onSelectChange():void
		{
			
			///选中状态改变，由子类覆写更改显示状态
			
		}
		
		/**
		 * 没有数据提供给此单元格渲染时调用
		 * 通常是用来通知其移除一些显示占用和侦听避免bug
		 */
		final public function noData():void
		{
			_data = null;
			onNoData();
		}
		
		protected function onNoData():void
		{
			
			///没有数据提供给此单元格渲染
			
		}
		
	}

}