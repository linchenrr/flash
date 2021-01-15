package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 大场景演示  
	 * 优化:
	 * 1、显示列表淘汰机制
	 */
	public class Demo2 extends BaseDemo
	{
		
		public function Demo2():void
		{
			
		}
		
		/**
		 * 生成一个显示对象
		 * @param	row			当前行
		 * @param	column		当前列
		 */
		override protected function initItem(row:int, column:int):void
		{
			var mc:MovieClip = getRandItem();
			
			mc.x = column * DemoConfig.ColumnSpace;
			mc.y = row * DemoConfig.RowSpace;
			container.addChild(mc);
			
			arr_item[row][column] = mc;
		}
		
		/**
		 * 拖动容器时触发
		 * @param	strRow			开始行数
		 * @param	endRow			结束行数
		 * @param	strColumn		开始列数
		 * @param	endColumn		结束列数
		 */
		override protected function containerMove(strRow:int, endRow:int, strColumn:int, endColumn:int):void
		{
			clearContainer();
			while (strRow < endRow)
			{
				var tmpColumn:int = strColumn;
				while (tmpColumn < endColumn)
				{
					container.addChild(arr_item[strRow][tmpColumn]);
					tmpColumn++;
				}
				strRow++;
			}
			
		}
		
	}

}