package org.superkaka.KLib.display.ui.controls 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class GridCellPositionCalculator extends EventDispatcher implements ICellPositionCalculator
	{
		
		private var _rowSpacing:Number = 100;
		private var _columnSpacing:Number = 100;
		
		public var column:int = 2;
		
		public function calculator(cellIndex:int):Point
		{
			
			var cellRow:int = int(cellIndex / column);
			var cellColumn:int = cellIndex - cellRow * column;
			return new Point(cellColumn * columnSpacing, cellRow * rowSpacing);
			
		}
		
		public function get rowSpacing():Number 
		{
			return _rowSpacing;
		}
		
		public function set rowSpacing(value:Number):void 
		{
			_rowSpacing = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get columnSpacing():Number 
		{
			return _columnSpacing;
		}
		
		public function set columnSpacing(value:Number):void 
		{
			_columnSpacing = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}