package org.superkaka.KLib.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.superkaka.KLib.struct.GridBitmapDataInfo;
	
	/**
	 * 卷轴滚动控制容器
	 * @author ｋａｋａ
	 */
	public class Reel extends Sprite
	{
		
		/**
		 * 格子宽
		 */
		private var gridW:int;
		
		/**
		 * 格子高
		 */
		private var gridH:int;
		
		/**
		 * 显示区域宽
		 */
		private var viewW:int;
		
		/**
		 * 显示区域高
		 */
		private var viewH:int;
		
		/**
		 * 移动最大x
		 */
		private var maxX:Number;
		
		/**
		 * 移动最大y
		 */
		private var maxY:Number;
		
		/**
		 * 显示区域行数
		 */
		private var viewRow:int;
		
		/**
		 * 显示区域列数
		 */
		private var viewColumn:int;
		
		/**
		 * 上一次循环的开始行数
		 */
		private var lastRow:int = -1;
		
		/**
		 * 上一次循环的开始列数
		 */
		private var lastColumn:int = -1;
		
		/**
		 * 是否需要使用遮罩，如果显示区域与舞台尺寸相同，可以设置为false以提高性能。 默认为true
		 */
		private var _useMask:Boolean;
		
		/**
		 * 是否修正移动坐标到有效可视范围内
		 */
		private var _fixMovePoition:Boolean;
		
		/**
		 * 显示源
		 */
		private var _source:DisplayObject;
		
		/**
		 * 内部位图移动容器
		 */
		private var container:Sprite;
		
		/**
		 * 遮罩
		 */
		private var sp_mask:Shape;
		
		/**
		 * 位图数据信息
		 */
		private var _gridData:GridBitmapDataInfo;
		
		/**
		 * 位图二维数组
		 */
		private var bitmapArr:Array;
		
		public function Reel():void
		{
			
			container = new Sprite();
			
			sp_mask = new Shape();
			
			addChild(container);
			
			useMask = true;
			
		}
		
		
		/**
		 * 设置显示区域尺寸
		 * @param	viewWidth				显示区域宽
		 * @param	viewHeight				显示区域高
		 */
		public function setViewSize(viewWidth:int, viewHeight:int):void
		{
			
			this.viewW = viewWidth;
			this.viewH = viewHeight;
			
			
			updateViewRowColumn();
			
			
		}
		
		private function updateViewRowColumn():void
		{
			
			viewRow = Math.ceil(viewH / gridH) + 1;
			viewColumn = Math.ceil(viewW / gridW) + 1;
			
			///重绘遮罩
			var gr:Graphics = sp_mask.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0);
			gr.drawRect(0, 0, viewW, viewH);
			gr.endFill();
			
		}
		
		/**
		 * 是否需要使用遮罩，如果显示区域与舞台尺寸相同，可以设置为false以提高性能。 默认为true
		 */
		public function get useMask():Boolean 
		{
			return _useMask;
		}
		
		/**
		 * 是否需要使用遮罩，如果显示区域与舞台尺寸相同，可以设置为false以提高性能。 默认为true
		 */
		public function set useMask(value:Boolean):void 
		{
			
			_useMask = value;
			
			if (_useMask)
			{
				addChild(sp_mask);
				this.mask = sp_mask;
			}
			else
			{
				if (contains(sp_mask))
				{
					removeChild(sp_mask);
					this.mask = null;
				}
			}
		}
		
		
		/**
		 * 是否修正移动坐标到有效可视范围内
		 */
		public function get fixMovePoition():Boolean 
		{
			return _fixMovePoition;
		}
		
		/**
		 * 是否修正移动坐标到有效可视范围内
		 */
		public function set fixMovePoition(value:Boolean):void 
		{
			_fixMovePoition = value;
		}
		
		public function get gridData():GridBitmapDataInfo 
		{
			return _gridData;
		}
		
		public function set gridData(value:GridBitmapDataInfo):void 
		{
			
			_gridData = value;
			
			updateGridData();
		}
		
		private function updateGridData():void
		{
			
			removeAllGrid();
			
			if (_gridData == null) return;
			
			gridW = _gridData.gridWidth;
			gridH = _gridData.gridHeight;
			
			
			updateViewRowColumn();
			
			
			maxX = gridData.validWidth;
			maxY = gridData.validHeight;
			
			bitmapArr = new Array(gridData.row);
			
			var row:int = 0;
			while (row < gridData.row)
			{
				
				var column:int = 0;
				
				var columnArr:Array = new Array(gridData.column);
				bitmapArr[row] = columnArr;
				
				while (column < gridData.column)
				{
					
					var bitmap:Bitmap = new Bitmap(gridData.gridBitDataArray[row][column]);
					bitmap.x = column * gridW;
					bitmap.y = row * gridH;
					columnArr[column] = bitmap;
					
					column++;
					
				}
				
				row++;
				
			}
			
			moveTo(0, 0, true);
			
		}
		
		/**
		 * 移动
		 * @param	x
		 * @param	y
		 * @param	forecUpdate			是否强制刷新
		 */
		public function moveTo(x:int, y:int, forecUpdate:Boolean = false):void
		{
			
			if (_fixMovePoition)
			{
				
				if (x < 0)
				{
					x = 0;
				}
				else
				if (x > maxX)
				{
					x = maxX;
				}
				
				if (y < 0)
				{
					y = 0;
				}
				else
				if (y > maxY)
				{
					y = maxY;
				}
				
			}
			
			
			container.x = -x;
			container.y = -y;
			
			var startRow:int = y / gridH;
			var startColumn:int = x / gridW;
			
			
			var endRow:int = startRow + viewRow;
			var endColumn:int = startColumn + viewColumn;
			
			if (startRow < 0)
			{
				startRow = 0;
			}
			
			if (startColumn < 0)
			{
				startColumn = 0;
			}
			
			if (!forecUpdate && startRow == lastRow && startColumn == lastColumn) return;
			
			lastRow = startRow;
			lastColumn = startColumn;
			
			if (endRow > gridData.row)
			{
				endRow = gridData.row;
			}
			
			if (endColumn > gridData.column)
			{
				endColumn = gridData.column;
			}
			
			removeAllGrid();
			
			var row:int = startRow;
			
			while (row < endRow)
			{
				
				var column:int = startColumn;
				
				var columnArr:Array = bitmapArr[row];
				
				while (column < endColumn)
				{
					
					container.addChild(columnArr[column]);
					
					column++;
					
				}
				
				row++;
				
			}
			
		}
		
		private function removeAllGrid():void
		{
			
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
			
		}
		
		public function clear():void
		{
			
			removeAllGrid();
			
			_gridData = null;
			
			bitmapArr = null;
			
		}
		
	}

}