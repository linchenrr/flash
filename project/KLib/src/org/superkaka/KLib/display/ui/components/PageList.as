package org.superkaka.KLib.display.ui.components 
{
	import flash.geom.Point;
	import org.superkaka.KLib.display.ui.controls.GridCellPositionCalculator;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class PageList extends PageContainer
	{
		
		private var _count:int;
		
		private var gridPosCal:GridCellPositionCalculator;
		
		public function PageList(cellRender:* = null, count:int = 10, spacing:Number = 40):void
		{
			
			gridPosCal = new GridCellPositionCalculator();
			gridPosCal.rowSpacing = spacing;
			gridPosCal.columnSpacing = 0;
			gridPosCal.column = 1;
			
			super(cellRender, gridPosCal);
			
			this.count = count;
			
		}
		
		public function get count():int 
		{
			return _count;
		}
		
		public function set count(value:int):void 
		{
			
			_count = value;
			
			//pageSize = _count;
			setPageSize(_count);
			
		}
		
		public function get spacing():Number 
		{
			return gridPosCal.rowSpacing;
		}
		
		public function set spacing(value:Number):void 
		{
			
			gridPosCal.rowSpacing = value;
			
		}
		
		override public function get height():Number
		{
			
			return gridPosCal.rowSpacing * _count * scaleY;
			
		}
		
	}

}