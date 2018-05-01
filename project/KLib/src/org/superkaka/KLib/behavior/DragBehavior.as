package org.superkaka.KLib.behavior 
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import org.superkaka.KLib.manager.DragManager;
	/**
	 * 按下拖动和松开停止的行为
	 * @author ｋａｋａ
	 */
	public class DragBehavior extends DisplayObjectBehavior
	{
		
		protected var dragTarget:InteractiveObject;
		protected var lockCenter:Boolean;
		
		public function DragBehavior(dragTarget:InteractiveObject, lockCenter:Boolean = false, autoStart:Boolean = true):void
		{
			
			super(dragTarget, autoStart);
			
			this.lockCenter = lockCenter;
			
		}
		
		override protected function init():void
		{
			
			dragTarget = target as InteractiveObject;
			
		}
		
		override public function start():void
		{
			
			dragTarget.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			
		}
		
		override public function stop():void
		{
			
			dragTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			
			DragManager.stopDrag(dragTarget);
			
		}
		
		private function startDrag(evt:MouseEvent):void
		{
			
			DragManager.startDrag(dragTarget, lockCenter, true);
			
		}
		
	}

}