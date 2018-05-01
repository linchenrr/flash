package org.superkaka.KLib.display.ui.components 
{
	import flash.events.Event;
	
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	import org.superkaka.KLib.struct.CellData;
	
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email			superkaka.org@gmail.com
	 * @date			2013/10/10/星期四 14:15
	 */
	public class TreeGroup extends MovieClipComponent 
	{
		/**               组件定义                  */
		
		
		/**               变量定义                  */
		protected var list_tree:Array = [];
		public var spacing:int = 0;
		protected var _selectedTree:Tree;
		public var onlyOpenOne:Boolean = false;
		
		public function TreeGroup():void 
		{
			
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			///绑定完成，执行相关初始化操作
			
		}
		
		public function addTree(tree:Tree):void
		{
			
			list_tree.push(tree);
			tree.addEventListener(Event.RESIZE, arrangeTree);
			tree.addEventListener(UIComponentEvent.CHANGE, treeSelectHandler);
			tree.addEventListener(Tree.OPEN, onOpen);
			
			movieClip.addChild(tree);
			arrangeTree();
			
		}
		
		public function removeTree(tree:Tree):void
		{
			
			var index:int = list_tree.indexOf(tree);
			
			if (index == -1)
			return;
			
			list_tree.splice(index, 1);
			
			tree.removeEventListener(Event.RESIZE, arrangeTree);
			tree.removeEventListener(UIComponentEvent.CHANGE, treeSelectHandler);
			
			movieClip.removeChild(tree);
			arrangeTree();
			
		}
		
		private function treeSelectHandler(evt:UIComponentEvent):void
		{
			
			_selectedTree = evt.target as Tree;
			
			var i:int = 0;
			var c:int = list_tree.length;
			while (i < c) 
			{
				
				var tree:Tree = list_tree[i];
				if (tree != _selectedTree)
				tree.unSelect();
				
				i++;
			}
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, selectedData));
			
		}
		
		private function onOpen(evt:Event):void
		{
			
			if (onlyOpenOne == false)
			return;
			
			var openTree:Tree = evt.target as Tree;
			var i:int = 0;
			var c:int = list_tree.length;
			while (i < c) 
			{
				
				var tree:Tree = list_tree[i];
				if (tree != openTree)
				tree.close();
				
				i++;
			}
			
		}
		
		private function arrangeTree(evt:Event = null):void
		{
			
			var h:int = 0;
			var i:int = 0;
			var c:int = list_tree.length;
			while (i < c) 
			{
				
				var tree:Tree = list_tree[i];
				tree.x = 0;
				tree.y = h;
				h += tree.height + spacing;
				
				i++;
			}
			
			dispatchEvent(new Event(Event.RESIZE));
			
		}
		
		public function get selectedTree():Tree 
		{
			return _selectedTree;
		}
		
		public function get selectedData():CellData
		{
			
			if (_selectedTree != null)
			return _selectedTree.selectedData;
			
			return null;
			
		}
		
	}

}