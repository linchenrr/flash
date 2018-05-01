package  org.superkaka.KLib.common.astar
{	
	/**
	 * A*寻路
	 * @author ｋａｋａ
	 */
	public class PathFinder 
	{
		///二维地图节点数组
		private var map_node:Array;
		
		///路径数组
		private var arr_path:Array;
		
		///待检验列表(开放列表)
		private var list_open:Array;
		///开放列表的长度
		private var count_list_open:int;
		///封闭列表
		private var list_closed:Array;
		///封闭列表的长度
		private var count_list_closed:int;
		
		
		///起始节点
		private var node_start:PathNode;
		
		///目标节点
		private var node_end:PathNode;
		
		///当前父方格
		private var node_current:PathNode;
		
		///边界最大x值
		private var mx:int;
		///边界最大y值
		private var my:int;
		
		///终点x坐标
		private var targetX:int;
		///终点y坐标
		private var targetY:int;
		
		
		public function PathFinder():void 
		{
			
		}
		
		public function set nodeMap(value:Array):void 
		{
			map_node = value;
			mx = map_node.length;
			my = map_node[0].length;
		}
		
		///获取或设置二维节点数组
		public function get nodeMap():Array
		{
			return map_node;
		}
		
		/**
		 * 设置节点阻断
		 * @param	x
		 * @param	y
		 * @param	block
		 */
		public function setNodeBlock(x:int, y:int, block:Boolean):void
		{
			if (x < 0 || y < 0 || x >= mx || y >= my)
			throw new Error("索引超出数据边界");
			
			(map_node[x][y] as PathNode).b = block;
		}
		
		/**
		 * 获取节点阻断
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getNodeBlock(x:int, y:int):Boolean
		{
			if (x < 0 || y < 0 || x >= mx || y >= my)
			throw new Error("索引超出数据边界");
			
			return (map_node[x][y] as PathNode).b;
		}
		
		/**
		 * 寻找路径
		 * @param	startX
		 * @param	startY
		 * @param	targetX
		 * @param	targetY
		 * @return
		 */
		public function findPath(startX:int, startY:int, targetX:int, targetY:int):Array
		{
			if (map_node == null)
			throw new Error("地图数据为空");
			
			if (
			startX < 0 || startY < 0 || targetX < 0 || targetY < 0 ||
			startX >= mx || startY >= my || targetX >= mx || targetY >= my)
			throw new Error("索引超出数据边界");
			
			
			list_open = [];
			list_closed = [];
			arr_path = null;
			
			count_list_open = 1;
			count_list_closed = 0;
			
			//trace("开始寻路！");
			
			
			this.targetX = targetX;
			this.targetY = targetY;
			
			node_end = map_node[targetX][targetY];
			
			node_start = map_node[startX][startY];
			node_start.G = 0;
			
			//获取H值  这里不需要
			//node_start.F = getH(node_start.x, node_start.y);
			
			list_open[0] = node_start;
			
			node_start.isInOpenList = true;
			node_start.isInClosedList = false;
			
			searchOpenList();
			
			//复原被改变节点的状态
			for each(var ndo:PathNode in list_open)
			{
				ndo.isInOpenList = false;
			}
			for each(var ndc:PathNode in list_closed)
			{
				ndc.isInClosedList = false;
			}
			
			return arr_path;
			//if (arr_path == null)
			//{
				//return null;
			//}
			//else
			//{
				//return arr_path.reverse();
			//}
		}
		
		///二叉堆优化
		///比较父节点(添加或修改元素时)
		private function cpFather(Pid:int):void
		{
			var id:int = Pid;
			
			while (id > 1)
			{
				var faId:int = int(id / 2);
				var Fnode:PathNode = list_open[faId - 1];
				var node:PathNode = list_open[id - 1];
				
				if (node.F < Fnode.F)
				{
					list_open[faId - 1] = node;
					list_open[id - 1] = Fnode;
					
					id = faId;
				}
				else
				{
					break;
				}
			}
		}
		
		///比较子节点(删除元素时)
		private function cpSon():void
		{			
			var c:int = count_list_open;
			
			if (c < 2)
			{
				return;
			}
			
			var node:PathNode;
			var Snode:PathNode;
			var Snode2:PathNode;
			
			var id:int = 1;
			var tmpId:int;
			var s:int;
			
			while (true)
			{
				tmpId = id;
				s = id + id;
				
				if (s <= c)
				{
					node = list_open[id-1];
					Snode = list_open[s-1];
					
					if (node.F > Snode.F)
					{
						id = s;
					}
					
					s++;
					
					if (s <= c)
					{
						Snode2 = list_open[s-1];
						if (Snode.F > Snode2.F)
						{
							id = s;
						}
					}
				}
				//如果节点位置没有更新结束排序
				if (tmpId == id)
				{
					break;
				}
				else
				{
					//否则交换位置，继续比较新位置的节点
					list_open[tmpId - 1] = list_open[id - 1];
					list_open[id-1] = node;
				}
				
			}
		}
		
		///检验开放列表（待检验列表）
		private function searchOpenList():void
		{
			while (true)
			{
				if (count_list_open <= 0)
				{
					//trace("没有路径！ Path");
					//trace(list_open.length,count_list_open,list_open)
					return;
				}
				
				node_current = list_open[0];
				node_current.isInOpenList = false;
				node_current.isInClosedList = true;
				
				list_closed[count_list_closed] = node_current;
				count_list_closed++;
				
				///如果当前节点是终点
				if (node_current == node_end)
				{
					gohome(node_current);
					return;
				}
				
				if (count_list_open != 1)
				{
					list_open[0] = list_open.pop();
				}
				else
				{
					list_open.pop();
				}
				
				count_list_open--;
				
				
				cpSon();
				
				//因为是根据平面坐标判断所以将x和y互换
				var x:int = node_current.x;
				var y:int = node_current.y;
				
				
				///===========不可穿越墙角的设定==============///				
				//左
				x--;
				var left:Boolean = false;
				if (x >= 0)
				{
					left = searchNode(x, y, 10);
				}
				
				//右
				x += 2;
				var right:Boolean = false;
				if (x < mx)
				{
					right = searchNode(x, y, 10);
				}
				
				x--;
				
				//上
				y--;
				var up:Boolean = false;
				if (y >= 0)
				{
					up = searchNode(x, y, 10);
				}
				
				//下
				y += 2;
				var down:Boolean = false;
				if (y < my)
				{
					down = searchNode(x, y, 10);
				}
				
				y--;
				
				//左上
				if (left && up) searchNode(x - 1, y - 1, 14);
				//右上
				if (up && right) searchNode(x + 1, y - 1, 14);
				//右下
				if (right && down) searchNode(x + 1, y + 1, 14);
				//左下
				if (down && left) searchNode(x - 1, y + 1, 14);
			}
		}
		
		///添加当前测试节点
		private function searchNode(x:int, y:int, C:int):Boolean
		{			
			var node_test:PathNode = map_node[x][y];
			
			//如果不可通行则跳过
			if (node_test.b)
			{
				return false;
			}
			
			
			//如果在封闭列表中则跳过
			if (node_test.isInClosedList)
			{
				return true;
			}
			
			
			var newG:int = node_current.G + C;
			
			//如果在开放列表中则看G值是否会更小
			if (node_test.isInOpenList)
			{
				//如果G值更小则改变其父节点为当前节点并且更新G值
				if (newG < node_test.G)
				{
					node_test.father = node_current;
					node_test.G = newG;
					node_test.F = newG + node_test.H;
					
					cpFather(list_open.indexOf(node_test) + 1);
					//var m:int = 0;
					//for each(var n:Node in list_open)
					//{
						//if (n == node_test)
						//{
							//cpFather(m + 1);
							//break;
						//}
						//m++;
					//}
					/*
					while (m < count_list_open)
					{
						if (list_open[m] == node_test)
						{
							cpFather(m + 1);
							break;
						}
						m++;
					}*/
				}
			}
			else
			{
				//如果不在开放列表中则加入到开放列表
				node_test.G = newG;
				//获取H值  优化
				//node_test.H = getH(node_test.x, node_test.y);
				var hx:int = (x - targetX) * 10;
				var hy:int = (y - targetY) * 10;
				
				hx < 0 && (hx = -hx);
				hy < 0 && (hy = -hy);
				
				node_test.H = hx + hy;
				
				node_test.F = newG + node_test.H;
				node_test.father = node_current;
				
				list_open[count_list_open] = node_test;
				node_test.isInOpenList = true;
				
				count_list_open++;
				
				cpFather(count_list_open);
			}
			
			return true;
		}
		
		///回溯
		private function gohome(node:PathNode):void
		{
			var c:int = 0;
			var G:int = node.G;
			arr_path = [];
			
			while (true)
			{
				
				arr_path[c] = [node.x, node.y];
				
				if (node == node_start)
				{
					arr_path["G"] = G;
					return;
				}
				else
				{
					node = node.father;
				}
				c++;
			}
		}
		
		
	}
	
}