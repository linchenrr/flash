package org.superkaka.KLib.common.astar 
{
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class PathDataTool 
	{
		
		///创建二维节点数组
		static public function createBlankMap(w:int, h:int):Array
		{
			var map_node:Array = [];
			
			var i:int = 0;
			
			while (i < w)
			{
				var arr_column_node:Array = [];
				
				var j:int = 0;
				while (j < h)
				{
					var node:PathNode = new PathNode(i, j);
					
					arr_column_node[j] = node;
					
					j++;
				}
				
				map_node[i] = arr_column_node;
				
				i++;
			}
			
			return map_node;
		}
		
		///根据数据创建二维节点数组
		static public function createMap(map_data:Array):Array 
		{
			
			var w:int = map_data.length;
			var h:int = map_data[0].length;
			
			var map_node:Array = createBlankMap(w, h);
			
			var i:int = 0;
			while (i < w)
			{
				var arr_column_map:Array = map_data[i];
				var arr_column_node:Array = map_node[i];
				
				var j:int = 0;
				while (j < h)
				{
					var node:PathNode = arr_column_node[j];
					node.b = (arr_column_map[j] == 1);				
					j++;
				}
				i++;
			}
			return map_node;
		}
		
		/**
		 * 随机创建节点地图
		 * @param	w
		 * @param	h
		 * @param	density			阻挡格密度，范围 0~1,数值越高密度越大
		 * @return
		 */
		static public function createRandomMapData(w:int, h:int, density:Number = 0.3):Array
		{
			
			var map_data:Array = [];
			
			var i:int = 0;
			
			while (i < w)
			{
				var data_column:Array = [];
				
				var j:int = 0;
				while (j < h)
				{
					data_column[j] = Math.random() < density ? 1 : 0;
					j++;
				}
				
				map_data[i] = data_column;
				
				i++;
			}
			
			return createMap(map_data);
			
		}
		
		static public function mapDataToString(map_data:Array):String
		{
			
			var w:int = map_data.length;
			var h:int = map_data[0].length;
			
			var str:String = "";
			
			var y:int = 0;
			while (y < h)
			{
				var x:int = 0;
				while (x < w)
				{
					//str += x + getNodeStr(map_data[x][y]) + y;
					str += getNodeStr(map_data[x][y]);
					if (x != w - 1)
					str += "  ";
					x++;
				}
				if (y != h - 1)
				str += "\r";
				y++;
			}
			
			function getNodeStr(node:*):String
			{
				//╳〇 ◆◇▇▆
				if (node is PathNode)
				return node.b ? "1" : "0";
				else
				return node == 1 ? "1" : "0";
			}
			
			return str;
		}
		
		static public function pathToString(pathList:Array):String
		{
			
			if (null == pathList)
			return "没有路径";
			
			var str:String = "";
			var i:int = pathList.length - 1;
			while (i >= 0) 
			{
				
				str += "[" + pathList[i] + "]";
				if (i != 0)
				str += ",";
				
				i--;
			}
			
			return str;
		}
		
	}
	
}