package org.superkaka.KLib.manager 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 容器管理
	 */
	public class ContainerManager
	{
		
		/**
		 * 索引表
		 */
		static private const hashTable:Object = { };
		
		/**
		 * 获取容器
		 * @param	id
		 * @return
		 */
		static public function getContainer(id:String):Sprite
		{
			
			return hashTable[id];
			
		}
		
		/**
		 * 创建新容器
		 * @param	id
		 * @param	parentId	指定的父级容器id，新容器将被添加到参数指定的父级容器中
		 * @param	index			添加该子项的索引位置。如果不指定，则添加到最上层。如果指定当前占用的索引位置，则该位置以及所有更高位置上的子对象会在子级列表中上移一个位置。	
		 */
		static public function createContainer(id:String, parentId:String = null, index:int = -1):Sprite
		{
			
			var sp:Sprite = new Sprite();
			
			addContainer(sp, id, parentId, index);
			
			return sp;
			
		}
		
		/**
		 * 添加容器
		 * @param	container
		 * @param	id
		 * @param	parentId	指定的父级容器id，新容器将被添加到参数指定的父级容器中
		 * @param	index			添加该子项的索引位置。如果不指定，则添加到最上层。如果指定当前占用的索引位置，则该位置以及所有更高位置上的子对象会在子级列表中上移一个位置。	
		 */
		static public function addContainer(container:Sprite, id:String, parentId:String = null, index:int = -1):void
		{
			
			hashTable[id] = container;
			
			setContainerParent(id, parentId, index);
			
		}
		
		/**
		 * 设置容器父级
		 * @param	id
		 * @param	parentId	指定的父级容器id，新容器将被添加到参数指定的父级容器中
		 * @param	index			添加该子项的索引位置。如果不指定，则添加到最上层。如果指定当前占用的索引位置，则该位置以及所有更高位置上的子对象会在子级列表中上移一个位置。	
		 */
		static public function setContainerParent(id:String, parentId:String = null, index:int = -1):void
		{
			
			var sp:Sprite = hashTable[id];
			
			var container:Sprite = hashTable[parentId];
			
			if (sp.parent)
			{
				
				sp.parent.removeChild(sp);
				
			}
			
			if (container)
			{
				
				if (index >= 0)
				{
					
					container.addChildAt(sp, index);
					
				}
				else
				{
					
					container.addChild(sp);
					
				}
				
			}
			
		}
		
	}

}

class HiddenCls { }