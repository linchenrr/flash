package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.display.ui.controls.ICellPositionCalculator;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class ScrollList extends BaseList
	{
		
		public var scrollBar:ScrollBar;
		
		public function ScrollList(cellRender:* = null, cellPositionCalculator:ICellPositionCalculator = null):void
		{
			
			super(cellRender, cellPositionCalculator);
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			if (scrollBar != null)
			{
				scrollBar.target = container;
				movieClip.addChild(scrollBar);
			}
			
		}
		
		///**
		 //* 获取或设置显示区域的宽度
		 //*/
		//public function get viewWidth():Number 
		//{
			//return scrollBar.viewWidth;
		//}
		//
		//public function set viewWidth(value:Number):void 
		//{
			//scrollBar.viewWidth = value;
		//}
		//
		///**
		 //* 获取或设置显示区域的高度
		 //*/
		//public function get viewHeight():Number 
		//{
			//return scrollBar.viewHeight;
		//}
		//
		//public function set viewHeight(value:Number):void 
		//{
			//scrollBar.viewHeight = value;
		//}
		
	}

}