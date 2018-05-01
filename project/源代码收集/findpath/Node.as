package  com.renren.farm.map.findpath
{
	
	/**
	 * ...
	 * @author ｋａｋａ
	 * 节点
	 */
	public class Node 
	{
		///父节点
		public var father:Node;
		///G值(从起点到此节点的消耗)
		public var G:int;
		///H值(从此节点到目标的估计消耗)
		public var H:int;
		///F值
		public var F:int;
		
		///当前增加的消耗值
		public var C:int;
		
		///是否可通过
		public var p:int;
		
		///是否在开放列表中
		public var isInOpenList:Boolean = false;
		
		///是否在关闭列表中
		public var isInClosedList:Boolean = false;
		
		///x
		public var x:int;
		///y
		public var y:int;
		
		public function Node(x:int = 0, y:int = 0, p:int = 0):void 
		{
			this.x = x;
			this.y = y;
			this.p = p;
		}
		
	}
	
}