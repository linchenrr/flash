package com.renren.farm.map.findpath 
{
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class NodeDataHelper 
	{
		
		///根据创建二维节点数组
		static public function createNodeArr(w:int, h:int):Array
		{
			var arr_node:Array = [];
			
			var i:int = 0;
			var j:int = 0;
			
			while (i < w)
			{
				var arr_row_node:Array = [];
				
				while (j < h)
				{
					var node:Node = new Node(i, j);
					
					arr_row_node[j] = node;
					
					j++;
				}
				
				arr_node[i] = arr_row_node;
				
				i++;
				j = 0;
			}
			
			return arr_node;
		}
		
		///根据数据更新二维节点数组
		static public function updateNodeArr(arr_map:Array, arr_node:Array):void 
		{			
			var w:int = arr_map.length;
			var h:int = arr_map[0].length;
			
			var i:int = 0;
			var j:int = 0;
			
			while (i < w)
			{
				var arr_row_map:Array = arr_map[i];
				var arr_row_node:Array = arr_node[i];
				
				while (j < h)
				{
					var node:Node = arr_row_node[j];
					node.p = arr_row_map[j];				
					j++;
				}
				
				i++;
				j = 0;
			}
		}
		
	}
	
}