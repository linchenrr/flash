package org.superkaka.KLib.display.ui.components 
{
	import flash.events.IEventDispatcher;
	import org.superkaka.KLib.struct.CellData;
	
	/**
	 * ICellRenderer 接口提供单元格渲染器需要的方法和属性。
	 * 所有用户定义的单元渲染器都应实现此接口。
	 * @author ｋａｋａ
	 */
	
	[Event(name = "click", type = "flash.events.MouseEvent")]
	
	public interface ICellRender extends IEventDispatcher
	{
		
		function set x(value:Number):void;
		function get x():Number;
		
		function set y(value:Number):void;
		function get y():Number;
		
		function get cellData():CellData;
		
		function set cellData(value:CellData):void;
		
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		function noData():void;
		
	}
	
}