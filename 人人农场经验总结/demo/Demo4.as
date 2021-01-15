package  
{
	import flash.display.MovieClip;
	import org.superkaka.kakalib.manager.BitmapFrameInfoManager;
	import org.superkaka.kakalib.utils.BitmapCacher;
	import org.superkaka.kakalib.view.BitmapMovieClip;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 大场景演示  
	 * 优化:
	 * 1、显示列表淘汰机制加强版
	 * 2、显示对象的位图缓存
	 */
	public class Demo4 extends BaseDemo
	{
		
		private var list_mc:Array;
		
		public function Demo4():void
		{
			list_mc = [];
			
			cacheBitmapMC();
			
			container.mouseEnabled = false;
			container.mouseChildren = false;
		}
		
		/**
		 * 预先缓存好位图动画
		 */
		private function cacheBitmapMC():void
		{
			var i:int = 0;
			while (i < DemoConfig.ItemTypeNumber)
			{
				var mc:MovieClip = getItem(i);
				BitmapFrameInfoManager.storeBitmapFrameInfo(String(i), BitmapCacher.cacheBitmapMovie(mc));
				i++;
			}
		}
		
		/**
		 * 生成一个显示对象
		 * @param	row			当前行
		 * @param	column		当前列
		 */
		override protected function initItem(row:int, column:int):void
		{
			var mc:BitmapMovieClip = new BitmapMovieClip(BitmapFrameInfoManager.getBitmapFrameInfo(String(Math.random() * DemoConfig.ItemTypeNumber ^ 0)));
			
			mc.x = column * DemoConfig.ColumnSpace;
			mc.y = row * DemoConfig.RowSpace;
			container.addChild(mc);
			
			mc.stop();
			
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
			
			for each(var mc:BitmapMovieClip in list_mc)
			{
				mc.stop();
			}
			list_mc.splice(0);
			
			while (strRow < endRow)
			{
				var tmpColumn:int = strColumn;
				while (tmpColumn < endColumn)
				{
					var mc:BitmapMovieClip = arr_item[strRow][tmpColumn];
					list_mc.push(mc);
					container.addChild(mc);
					mc.play();
					tmpColumn++;
				}
				strRow++;
			}
			
		}
		
	}

}