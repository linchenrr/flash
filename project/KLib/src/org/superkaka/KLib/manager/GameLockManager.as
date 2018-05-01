package org.superkaka.KLib.manager 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import org.superkaka.KLib.utils.DisplayObjectTool;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 游戏锁定操作管理
	 */
	public class GameLockManager
	{
		
		static private var stage:Stage;
		
		static public function init(stg:Stage):void
		{
			stage = stg;
			
			drawMouseMask();
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			stage.addChild(mouseMaskContainer);
			
		}
		
		
		/**
		 * 鼠标遮罩
		 */
		static private const mouseMask:Sprite = new Sprite();
		
		/**
		 * 鼠标遮罩容器
		 */
		static private const mouseMaskContainer:Sprite = new Sprite();
		
		/**
		 * 锁定鼠标点击
		 */
		static public function lockMouse():void
		{
			
			mouseMaskContainer.addChild(mouseMask);
			
		}
		
		/**
		 * 解锁鼠标点击
		 */
		static public function unlockMouse():void
		{
			
			DisplayObjectTool.removeChilds(mouseMaskContainer, mouseMask);
			
		}
		
		/**
		 * swf尺寸改变
		 * @param	evt
		 */
		static private function stageResizeHandler(evt:Event):void
		{
			
			drawMouseMask();
			
		}
		
		/**
		 * 绘制鼠标遮罩
		 */
		static private function drawMouseMask():void
		{
			
			DisplayObjectTool.drawRect(mouseMask.graphics, 0, 0, stage.stageWidth, stage.stageHeight);
			
		}
		
	}

}