package org.superkaka.KLib.manager 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 拖拽管理器
	 * @author ｋａｋａ
	 */
	public class DragManager
	{
		
		static private const dic:Dictionary = new Dictionary();
		
		static private var stage:Stage;
		
		/**
		 * 初始化
		 */
		static public function init(stg:Stage):void
		{
			
			stage = stg;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			
		}
		
		/**
		 * 允许用户拖动指定的 DisplayObject， DisplayObject 将一直保持可拖动，直到通过调用 stopDrag() 方法来明确停止
		 * @param	target				指定的DisplayObject
		 * @param	lockCenter			指定是将可拖动的 DisplayObject 锁定到鼠标位置中央 (true)，还是锁定到用户首次单击该 Sprite 时所在的点上
		 * @param	dropOnRelease	是否在鼠标松开时停止拖动
		 */
		static public function startDrag(target:DisplayObject, lockCenter:Boolean = false, dropOnRelease:Boolean = false):void
		{
			if (lockCenter)
			{
				
				var rect:Rectangle = target.getBounds(stage);
				var pt:Point = new Point(stage.mouseX - rect.width / 2, stage.mouseY - rect.height / 2);
				
				var localPoint:Point = target.globalToLocal(pt);
				
				target.x += localPoint.x;
				target.y += localPoint.y;
				
			}
			
			limitPosition(target);
			
			var info:TargetInfo = new TargetInfo();
			info.lockCenter = lockCenter;
			info.dropOnRelease = dropOnRelease;
			info.offsetX = stage.mouseX - target.x;
			info.offsetY = stage.mouseY - target.y;
			
			dic[target] = info;
			
		}
		
		/**
		 * 结束拖动
		 * @param	target				指定的DisplayObject
		 */
		static public function stopDrag(target:DisplayObject):void
		{
			delete dic[target];
		}
		
		static private function stageMouseMoveHandler(evt:MouseEvent):void
		{
			
			var sx:Number = stage.mouseX;
			var sy:Number = stage.mouseY;
			
			for(var key:* in dic)
			{
				var target:DisplayObject = key as DisplayObject;
				
				if (target.stage == null)
				{
					stopDrag(target);
					continue;
				}
				
				var info:TargetInfo = dic[target];
				
				target.x = sx - info.offsetX;
				target.y = sy - info.offsetY;
				
				limitPosition(target);
				
			}
			
		}
		
		static private function limitPosition(target:DisplayObject):void
		{
			
			var bounds:Rectangle = target.getBounds(stage);
			
			if (bounds.x < 0)
			target.x -= bounds.x;
			else if (bounds.right > stage.stageWidth)
			target.x -= bounds.right - stage.stageWidth;
			
			if (bounds.y < 0)
			target.y -= bounds.y;
			else if (bounds.bottom > stage.stageHeight)
			target.y -= bounds.bottom - stage.stageHeight;
			
		}
		
		static private function stageMouseUpHandler(evt:MouseEvent):void
		{
			
			for(var key:* in dic)
			{
				var info:TargetInfo = dic[key];
				if (info.dropOnRelease) stopDrag(key as DisplayObject);
			}
			
		}
		
	}

}
class TargetInfo
{
	public var lockCenter:Boolean;
	public var dropOnRelease:Boolean;
	
	public var offsetX:Number;
	public var offsetY:Number;
	
}