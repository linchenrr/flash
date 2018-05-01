package org.superkaka.KLib.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.superkaka.KLib.struct.BitmapFrameInfo;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 显示对象工具类
	 */
	public class DisplayObjectTool
	{
		/**
		 * 复制源显示对象的各种显示属性到目标显示对象
		 * @param	source		源显示对象
		 * @param	target		目标显示对象
		 */
		static public function copyDisplayProperties(source:DisplayObject, target:DisplayObject):void
		{
			target.transform = source.transform;
			target.filters = source.filters;
			if (source is Sprite && target is Sprite)
			{
				(target as Sprite).buttonMode = (source as Sprite).buttonMode;
			}
		}
		
		/**
		 * 替换显示对象并且复制属性
		 * @param	oldDis		旧显示对象
		 * @param	newDis		新显示对象
		 */
		static public function replaceDisplayObjectAndCopyProperties(oldDis:DisplayObject, newDis:DisplayObject):void
		{
			copyDisplayProperties(oldDis, newDis);
			
			var parentContainer:DisplayObjectContainer = oldDis.parent;
			if (parentContainer != null)
			{
				var childIndex:int = parentContainer.getChildIndex(oldDis);
				parentContainer.removeChildAt(childIndex);
				parentContainer.addChildAt(newDis, childIndex);
			}
		}
		
		/**
		 * 移除显示容器的所有子对象
		 * @param	container	显示容器
		 */
		static public function removeAllChild(...containers):void
		{
			
			for each(var container:DisplayObjectContainer in containers)
			{
				
				while (container.numChildren > 0)
				{
					
					container.removeChildAt(0);
					
				}
				
			}
			
		}
		
		/**
		 * 从一个或多个显示对象的父容器中移除该显示对象
		 * @param	...childs		显示对象
		 */
		static public function removeChilds(...childs):void
		{
			for each(var child:DisplayObject in childs)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (null != parent)
				parent.removeChild(child);
				
			}
		}
		
		/**
		 * 以容器的注册点为显示对象的中心点添加显示对象
		 * @param	container
		 * @param	child
		 * @param	removeChilds
		 */
		static public function addChildToMiddle(container:DisplayObjectContainer, child:DisplayObject, removeChilds:Boolean = false):void
		{
			if (removeChilds)
			{
				removeAllChild(container);
			}
			
			//var rect:Rectangle = container.getBounds(container);
			//
			//child.x = rect.x + rect.width / 2;
			//child.y = rect.y + rect.height / 2;
			
			container.addChild(child);
			
			var rect:Rectangle = container.getBounds(child);
			
			child.x = -rect.width / 2;
			child.y = -rect.height / 2;
			
			
		}
		
		/**
		 * 限制显示对象尺寸并返回处理后的缩放值
		 * @param	pic
		 * @param	mw
		 * @param	mh
		 */
		static public function scalePic(pic:DisplayObject, mw:Number, mh:Number):Number
		{
			
			var scale:Number = 1;
			
			if (pic.width > mw)
			{
				scale = mw / pic.width;
				pic.width *= scale;
				pic.height *= scale;
			}
			
			if (pic.height > mh)
			{
				scale = mh / pic.height;
				pic.width *= scale;
				pic.height *= scale;
			}
			
			return scale;
			
		}
		
		/**
		 * 设置容器鼠标事件是否启用
		 * @param	mouseEnabled
		 * @param	mouseChildren
		 * @param	...containers
		 */
		static public function setContainerMouseEnabled(mouseEnabled:Boolean, mouseChildren:Boolean, ...containers):void
		{
			
			var i:int = 0;
			var c:int = containers.length;
			
			while (i < c)
			{
				
				var container:Sprite = containers[i];
				
				container.mouseEnabled = mouseEnabled;
				container.mouseChildren = mouseChildren;
				
				i++;
				
			}
		}
		
		/**
		 * 绘制矩形
		 */
		static public function drawRect(gr:Graphics, color:uint, alpha:Number, width:Number, height:Number, clear:Boolean = true):void
		{
			
			if (clear) gr.clear();
			
			gr.lineStyle();
			
			gr.beginFill(color, alpha);
			
			gr.drawRect(0, 0, width, height);
			
			gr.endFill();
			
		}
		
		/**
		 * 获取target坐标系的可见显示区域
		 * 此方法与DisplayObject.getBounds不同的是，此方法会剪裁显示对象周围的透明像素区域再进行计算。因此使用了遮罩或四周有透明像素的显示对象实际结果会与DisplayObject.getBounds方法不同
		 * @param	target
		 * @return
		 */
		static public function getVisibleBounds(target:DisplayObject):Rectangle
		{
			
			var bitInfo:BitmapFrameInfo = BitmapCacher.cacheBitmap(target);
			
			var rect:Rectangle = bitInfo.bitmapData.rect;
			
			rect.x = bitInfo.x;
			rect.y = bitInfo.y;
			
			return rect;
			
		}
		
	}

}