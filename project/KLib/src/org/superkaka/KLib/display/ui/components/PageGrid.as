package org.superkaka.KLib.display.ui.components 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import org.superkaka.KLib.utils.DisplayObjectTool;
	import org.superkaka.KLib.display.ui.controls.GridCellPositionCalculator;
	
	/**
	 * PageGrid 类提供呈行和列分布的网格
	 * @author ｋａｋａ
	 */
	
	public class PageGrid extends PageContainer
	{
		
		private var _row:int;
		private var _column:int;
		
		private var gridPosCal:GridCellPositionCalculator;
		
		public function PageGrid(cellRender:* = null, row:int = 10, column:int = 2, rowSpacing:Number = 100, columnSpacing:Number = 100):void
		{
			
			gridPosCal = new GridCellPositionCalculator();
			gridPosCal.rowSpacing = rowSpacing;
			gridPosCal.columnSpacing = columnSpacing;
			
			super(cellRender, gridPosCal);
			
			this.row = row;
			this.column = column;
			
		}
		
		/**
		 * 显示行数
		 */
		public function get row():int 
		{ 
			
			return _row;
			
		}
		
		/**
		 * 显示行数
		 */
		public function set row(value:int):void 
		{
			
			_row = value;
			
			//pageSize = _row * _column;
			setPageSize(_row * _column);
			
		}
		
		/**
		 * 显示列数
		 */
		public function get column():int 
		{ 
			
			return _column;
			
		}
		
		/**
		 * 显示列数
		 */
		public function set column(value:int):void 
		{
			
			_column = value;
			gridPosCal.column = value;
			
			//pageSize = _row * _column;
			setPageSize(_row * _column);
			
		}
		
		/**
		 * 行间距
		 */
		public function get rowSpacing():Number
		{
			
			return gridPosCal.rowSpacing;
			
		}
		
		/**
		 * 行间距
		 */
		public function set rowSpacing(value:Number):void 
		{
			
			gridPosCal.rowSpacing = value;
			
		}
		
		/**
		 * 列间距
		 */
		public function get columnSpacing():Number 
		{ 
			
			return gridPosCal.columnSpacing;
			
		}
		
		/**
		 * 列间距
		 */
		public function set columnSpacing(value:Number):void 
		{
			
			gridPosCal.columnSpacing = value;
			
		}
		
		
		override public function get width():Number
		{
			
			return gridPosCal.columnSpacing * _column * scaleX;
			
		}
		
		override public function get height():Number
		{
			
			return gridPosCal.rowSpacing * _row * scaleY;
			
		}
		
	}

}