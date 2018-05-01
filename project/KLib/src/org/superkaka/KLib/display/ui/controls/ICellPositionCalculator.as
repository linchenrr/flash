package org.superkaka.KLib.display.ui.controls 
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	/**
	 * 此接口实现计算指定索引单元格的坐标
	 * @author ｋａｋａ
	 */
	[Event(name = "change", type = "flash.events.Event")]
	public interface ICellPositionCalculator extends IEventDispatcher
	{
		
		function calculator(cellIndex:int):Point;
		
	}
	
}