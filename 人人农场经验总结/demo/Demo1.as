package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 大场景演示  未作任何优化
	 */
	public class Demo1 extends BaseDemo
	{
		
		public function Demo1():void
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
		}
		
	}

}