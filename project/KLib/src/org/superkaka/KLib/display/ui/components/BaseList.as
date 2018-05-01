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
	 * BaseList 类提供自定义的单元格分布
	 * 使用此类必须提供单元格渲染器和单元格坐标计算器以实现单元格的渲染
	 * @author ｋａｋａ
	 */
	[Event(name = "UIComponentEvent_CHANGE", type = "org.superkaka.KLib.display.ui.events.UIComponentEvent")]
	public class BaseList extends MovieClipComponent
	{
		
		protected var _dataList:Array = [];
		
		protected var _cellRender:Class;
		
		protected var list_cell:Array;
		
		protected var container:Sprite = new Sprite();
		
		protected var _cellPositionCalculator:ICellPositionCalculator;
		
		protected var _selectedData:CellData;
		
		protected var nullCellData:CellData;
		
		public function BaseList(cellRender:* = null, cellPositionCalculator:ICellPositionCalculator = null):void
		{
			
			if (null != cellPositionCalculator) this.cellPositionCalculator = cellPositionCalculator;
			
			if (null != cellRender) setCellRender(cellRender);
			
			_selectedData = nullCellData = new CellData();
			nullCellData.cellIndex = -1;
			nullCellData.dataIndex = -1;
			nullCellData.data = null;
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			movieClip.addChild(container);
			
		}
		
		public function set listData(value:Array):void
		{
			
			if (null == value)
			{
				_dataList = [];
			}
			else
			{
				_dataList = value.concat();
			}
			
			onListDataChanged();
			
			update();
			
		}
		
		public function get listData():Array
		{
			
			return _dataList.concat();
			
		}
		
		public function addData(data:*):void
		{
			
			_dataList.push(data);
			
			onListDataChanged();
			
			update();
			
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			
			_dataList.splice(0);
			
			onListDataChanged();
			
			update();
			
		}
		
		protected function onListDataChanged():void
		{
			
			//列表数据改变，由子类覆写使用
			
		}
		
		public function get selectedData():CellData
		{
			return _selectedData;
		}
		
		protected function update(...args):void
		{
			
			renderCell();
			
		}
		
		protected function renderCell(startIndex:int = 0, endIndex:int = -1):void
		{
			
			if (null == _cellRender) return;
			
			DisplayObjectTool.removeAllChild(container);
			
			
			if (endIndex < 0) endIndex = _dataList.length;
			var curCellIndex:int = 0;
			
			while (startIndex < endIndex)
			{
				
				var cell:ICellRender = list_cell[curCellIndex];
				
				if (null == cell)
				{
					cell = list_cell[curCellIndex] = new _cellRender;
					cell.addEventListener(MouseEvent.CLICK, cellSelectHandler);
				}
				
				var pos:Point = getCellPosition(curCellIndex);
				
				cell.x = pos.x;
				cell.y = pos.y;
				
				var cellData:CellData = new CellData();
				
				cellData.data = _dataList[startIndex];
				
				cellData.cellIndex = curCellIndex;
				cellData.dataIndex = startIndex;
				
				cell.cellData = cellData;
				
				cell.selected = false;
				
				container.addChild(cell as DisplayObject);
				
				curCellIndex++;
				startIndex++;
				
			}
			
			var i:int = curCellIndex;
			var c:int = list_cell.length;
			while (i < c) 
			{
				
				var noUseCell:ICellRender = list_cell[i];
				noUseCell.noData();
				
				i++;
			}
			
			_selectedData = nullCellData;
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.UPDATE));
			
			dispatchEvent(new Event(Event.RESIZE));
			container.dispatchEvent(new Event(Event.RESIZE));
			
		}
		
		protected function cellSelectHandler(evt:MouseEvent):void
		{
			
			var cell:ICellRender = evt.currentTarget as ICellRender;
			
			doSelect(cell);
			
		}
		
		public function set selectedIndex(index:int):void
		{
			
			var cell:ICellRender;
			
			try
			{
				cell = container.getChildAt(index) as ICellRender;
			}
			catch (err:Error)
			{
				
			}
			
			doSelect(cell);
			
		}
		
		public function get selectedIndex():int
		{
			
			return _selectedData.cellIndex;
			
		}
		
		public function get cellPositionCalculator():ICellPositionCalculator 
		{
			return _cellPositionCalculator;
		}
		
		public function set cellPositionCalculator(value:ICellPositionCalculator):void 
		{
			_cellPositionCalculator = value;
			_cellPositionCalculator.addEventListener(Event.CHANGE, update);
			update();
		}
		
		private function doSelect(cell:ICellRender):void
		{
			
			unSelect();
			
			if (null != cell)
			{
				
				cell.selected = true;
				
				_selectedData = cell.cellData;
				
			}
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, _selectedData));
			
		}
		
		public function unSelect():void
		{
			
			for each(var cell:ICellRender in list_cell)
			{
				cell.selected = false;
			}
			
			_selectedData = nullCellData;
			
		}
		
		public function setCellRender(value:*):void
		{
			
			_cellRender = null;
			list_cell = [];
			
			if (value is Class)
			{
				var cls:Class = value;
				//创建的无用对象在具体程序中会导致一些麻烦
				//if ((new cls) is ICellRender)
				{
					_cellRender = cls;
					return;
				}
				
			}
			
			if (value is ICellRender)
			{
				_cellRender = getDefinitionByName(getQualifiedClassName(value)) as Class;
				return;
			}
			
			throw new Error("无效的渲染器" + value);
			
			update();
			
		}
		
		public function getCellRender():ICellRender
		{
			
			return _cellRender ? new _cellRender : null;
			
		}
		
		/**
		 * 获取指定索引单元格的坐标
		 * @param	cellIndex
		 * @return
		 */
		protected function getCellPosition(cellIndex:int):Point
		{
			
			return _cellPositionCalculator.calculator(cellIndex);
			//throw new Error("子类必须覆写此方法以实现单元格的布局");
			//return null;
			
		}
		
	}

}