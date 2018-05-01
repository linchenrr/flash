package org.superkaka.KLib.display.ui.components 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.superkaka.KLib.struct.CellData;
	import org.superkaka.KLib.utils.DisplayObjectTool;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 表示允许用户从下拉列表中选择一项的控件
	 * @author ｋａｋａ
	 */
	public class DropdownList extends MovieClipComponent
	{
		
		public var list:List;
		
		public var btn_show:Button;
		
		public var selectedContainer:Sprite;
		
		public var listBG:MovieClip;
		
		protected var selectedRender:ICellRender;
		
		public function DropdownList():void
		{
			
			
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			selectedContainer.mouseEnabled = false;
			selectedContainer.mouseChildren = false;
			
			btn_show.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			UIStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			list.addEventListener(UIComponentEvent.CHANGE, selectHandler);
			
			if (null == listBG)
			{
				listBG = new MovieClip();
				movieClip.addChild(listBG);
			}
			
			list.addEventListener(Event.RESIZE, listResizeHandler);
			
			hideList();
			
		}
		
		private function showList():void
		{
			
			movieClip.addChild(listBG);
			movieClip.addChild(list);
			
		}
		
		private function hideList():void
		{
			
			if (isOpen)
			{
				movieClip.removeChild(list);
				movieClip.removeChild(listBG);
			}
			
		}
		
		public function get isOpen():Boolean
		{
			
			return movieClip.contains(list);
			
		}
		
		private function selectHandler(evt:UIComponentEvent):void
		{
			
			selectedRender.cellData = evt.data as CellData;
			
			hideList();
			
			dispatchEvent(evt);
			
		}
		
		private function listResizeHandler(evt:Event):void
		{
			listBG.width = list.width;
			listBG.height = list.height;
		}
		
		private var isSelfMouseDown:Boolean;
		private function mouseDownHandler(evt:MouseEvent):void
		{
			
			switch(evt.currentTarget)
			{
				
				case this:
					isSelfMouseDown = true;
					break;
					
				case btn_show:
					if (isOpen)
					{
						hideList();
					}
					else
					{
						showList();
					}
					break;
					
				case UIStage:
					if (isSelfMouseDown)
					{
						isSelfMouseDown = false;
					}
					else
					{
						hideList();
					}
					break;
			}
			
		}
		
		public function setCellRender(value:*):void
		{
			
			list.setCellRender(value);
			selectedRender = list.getCellRender();
			selectedRender.selected = true;
			
			DisplayObjectTool.removeAllChild(selectedContainer);
			selectedContainer.addChild(selectedRender as DisplayObject);
			
		}
		
		public function get selectedData():CellData
		{
			return selectedRender.cellData;
		}
		
		public function set listData(value:Array):void
		{
			
			list.listData = value;
			list.selectedIndex = 0;
			
		}
		
		public function get listData():Array
		{
			
			return list.listData;
			
		}
		
		public function addData(data:*):void
		{
			
			list.addData(data);
			
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			
			list.clear();
			
		}
		
		public function set selectedIndex(index:int):void
		{
			
			list.selectedIndex = index;
			
		}
		
		public function get selectedIndex():int
		{
			
			return list.selectedIndex;
			
		}
		
		public function get spacing():Number 
		{
			return list.spacing;
		}
		
		public function set spacing(value:Number):void 
		{
			
			list.spacing = value;
			
		}
		
	}

}