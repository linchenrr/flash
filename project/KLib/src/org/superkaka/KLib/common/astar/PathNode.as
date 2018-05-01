package  org.superkaka.KLib.common.astar
{
	
	/**
	 * ...
	 * @author ｋａｋａ
	 * 节点
	 */
	public class PathNode 
	{
		///父节点
		public var father:PathNode;
		///G值(从起点到此节点的消耗)
		public var G:int;
		///H值(从此节点到目标的估计消耗)
		public var H:int;
		///F值
		public var F:int;
		
		///是否阻挡
		public var b:Boolean;
		
		///是否在开放列表中
		public var isInOpenList:Boolean = false;
		
		///是否在关闭列表中
		public var isInClosedList:Boolean = false;
		
		///x
		public var x:int;
		///y
		public var y:int;
		
		public function PathNode(x:int = 0, y:int = 0, b:Boolean = false):void 
		{
			this.x = x;
			this.y = y;
			this.b = b;
		}
		
	}
	
}