package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.display.ui.controls.GridCellPositionCalculator;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class List extends ScrollList
	{
		
		private var gridPosCal:GridCellPositionCalculator;
		
		public function List():void
		{
			
			gridPosCal = new GridCellPositionCalculator();
			gridPosCal.rowSpacing = spacing;
			gridPosCal.columnSpacing = 0;
			gridPosCal.column = 1;
			
			cellPositionCalculator = gridPosCal;
			
		}
		
		public function get spacing():Number 
		{
			return gridPosCal.rowSpacing;
		}
		
		public function set spacing(value:Number):void 
		{
			
			gridPosCal.rowSpacing = value;
			
		}
		
	}

}