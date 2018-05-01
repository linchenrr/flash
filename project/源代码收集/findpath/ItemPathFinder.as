package  com.renren.farm.map.findpath
{	
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author ｋａｋａ
	 * A*寻路类
	 */
	public class ItemPathFinder 
	{
		///二维地图节点数组
		private var arr_node:Array;
		
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
		private var node_start:Node;
		
		///目标节点
		private var node_end:Node;
		
		///当前父方格
		private var node_current:Node;
		
		///边界最大x值
		private var mx:int;
		///边界最大y值
		private var my:int;
		
		///终点x坐标
		private var edx:int;
		///终点y坐标
		private var edy:int;
		
		///是否已找到终点
		private var finded:Boolean;
		
		
		public function ItemPathFinder(w:int, h:int):void 
		{
			my = w;
			mx = h;
		}
		
		///设置二维节点数组
		public function set nodeArr(nodeArr:Array):void 
		{
			this.arr_node = nodeArr;
		}
		
		///获取某节点是否可通行
		public function getNodeBlock(posX:int, posY:int, block:int):int
		{
			return arr_node[posX][posY].p;
		}
		
		///寻路  startPos为起始点，endPos为目标点
		public function findPath(stx:int, sty:int, edx:int, edy:int):Array
		{
			if (arr_node == null)
			throw new Error("地图数据为空");
			
			finded = false;
			finded
			list_open = [];
			list_closed = [];
			arr_path = null;
			
			count_list_open = 1;
			count_list_closed = 0;
			
			//trace("开始寻路！");
			
			
			this.edx = edx;
			this.edy = edy;
			
			node_end = arr_node[edx][edy];
			
			node_start = arr_node[stx][sty];
			node_start.G = 0;
			
			//获取H值  这里不需要
			//node_start.F = getH(node_start.x, node_start.y);
			
			list_open[0] = node_start;
			
			node_start.isInOpenList = true;
			node_start.isInClosedList = false;
			
			searchOpenList();
			
			//复原被改变节点的状态
			for each(var ndo:Node in list_open)
			{
				ndo.isInOpenList = false;
			}
			for each(var ndc:Node in list_closed)
			{
				ndc.isInClosedList = false;
			}
			
			if (arr_path == null)
			{
				return null;
			}
			else
			{
				return arr_path.reverse();
			}
		}
		
		///二叉堆优化
		///比较父节点(添加或修改元素时)
		private function cpFather(Pid:int):void
		{
			var id:int = Pid;
			
			while (id > 1)
			{
				var faId:int = int(id / 2);
				var Fnode:Node = list_open[faId - 1];
				var node:Node = list_open[id - 1];
				
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
			
			var node:Node;
			var Snode:Node;
			var Snode2:Node;
			
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
		/*
		///获取H值
		private function getH(x:int, y:int):int
		{
			var hx:int = (x - edx) * 10;
			var hy:int = (y - edy) * 10;
			
			hx < 0 && (hx = -hx);
			hy < 0 && (hy = -hy);
			
			return hx + hy;
		}
		*/
		///检验开放列表（待检验列表）
		private function searchOpenList():void
		{
			while (true)
			{
				if (finded)
				{
					return;
				}
				
				if (count_list_open <= 0)
				{
//					trace("没有路径！ ItemPath");
//					trace(list_open.length,count_list_open,list_open)
					return;
				}
				
				node_current = list_open[0];
				node_current.isInOpenList = false;
				node_current.isInClosedList = true;
				
				list_closed[count_list_closed] = node_current;
				count_list_closed++;
				
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
				var y:int = node_current.x;
				var x:int = node_current.y;
				
				
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
		private function searchNode(y:int, x:int, C:int):Boolean
		{			
			var node_test:Node = arr_node[x][y];
			node_test.C = C;
			
			//如果不可通行则跳过
			if (node_test.p ==1)
			{
				//if (node_test == node_end && C == 10)
				if (node_test == node_end)
				{
					finded = true;
					gohome(node_current);
				}
				return false;
			}
			
			
			//如果在封闭列表中则跳过
			if (node_test.isInClosedList)
			{
				return true;
			}
			
			
			var newG:int = node_current.G + node_test.C;
			
			//如果在开放列表中则看G值是否会更小
			if (node_test.isInOpenList)
			{
				//如果G值更小则改变其父节点为当前节点并且更新G值
				if (newG < node_test.G)
				{
					node_test.father = node_current;
					node_test.G = newG;
					node_test.F = newG + node_test.H;
					
					var m:int = 0;
					for each(var n:Node in list_open)
					{
						if (n == node_test)
						{
							cpFather(m + 1);
							break;
						}
						m++;
					}
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
				var hx:int = (x - edx) * 10;
				var hy:int = (y - edy) * 10;
				
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
		private function gohome(node:Node):void
		{
			var c:int = 0;
			var G:int = node.G;
			arr_path = [];
			
			while (true)
			{
				
				if (node == node_start)
				{
					arr_path["G"] = G;
					//trace("寻路完成！ 路径格子数: ", arr_path.length, "遍历格子数: " + q, "耗时: " + time_st + "ms");
					return;
				}
				else
				{
					arr_path[c] = [node.x, node.y];
					node = node.father;
				}
				c++;
			}
		}
		
		
	}
	
}