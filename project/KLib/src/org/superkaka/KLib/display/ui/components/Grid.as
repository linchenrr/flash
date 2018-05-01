package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.display.ui.controls.GridCellPositionCalculator;
	/**
	 * Grid 类默认提供呈行和列分布的网格，同时支持自定义的分布方式。
	 * 如果数据项较多超出了规定的显示区域，则会显示滚动条
	 * @author ｋａｋａ
	 */
	public class Grid extends ScrollList
	{
		
		private var _row:int;
		private var _column:int;
		
		protected var gridPosCal:GridCellPositionCalculator;
		
		public function Grid(cellRender:* = null, column:int = 2, rowSpacing:Number = 100, columnSpacing:Number = 100):void
		{
			
			gridPosCal = new GridCellPositionCalculator();
			gridPosCal.rowSpacing = rowSpacing;
			gridPosCal.columnSpacing = columnSpacing;
			
			super(cellRender, gridPosCal);
			
			this.column = column;
			
		}
		
		public function get row():int 
		{
			return Math.ceil(_dataList.length / _column);
		}
		
		public function get column():int 
		{
			return _column;
		}
		
		public function set column(value:int):void 
		{
			_column = value;
			gridPosCal.column = value;
		}
		
	}

}