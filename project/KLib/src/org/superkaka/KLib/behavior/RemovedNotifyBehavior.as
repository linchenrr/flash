package org.superkaka.KLib.behavior 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.superkaka.KLib.interfaces.IRemovedNotify;
	/**
	 * 真正被移除(removeChild)的时候进行通知的行为
	 * @author ｋａｋａ
	 */
	public class RemovedNotifyBehavior extends DisplayObjectBehavior
	{
		
		protected var rnTarget:IRemovedNotify;
		
		public function RemovedNotifyBehavior(target:IRemovedNotify, autoStart:Boolean = true):void
		{
			
			super(target as DisplayObject, autoStart);
			
		}
		
		override protected function init():void
		{
			
			rnTarget = target as IRemovedNotify;
			
		}
		
		override public function start():void
		{
			
			displayObject.addEventListener(Event.REMOVED, removedHandler);
			
			displayObject.addEventListener(Event.ADDED, addHandler);
			
		}
		
		override public function stop():void
		{
			
			displayObject.removeEventListener(Event.REMOVED, removedHandler);
			
			displayObject.removeEventListener(Event.ADDED, addHandler);
			
		}
		
		/**
		 * 添加到容器
		 * @param	evt
		 */
		private function addHandler(evt:Event):void
		{
			
			if (evt.target != displayObject) return;
			
			displayObject.removeEventListener(Event.EXIT_FRAME, doRemove);
			
		}
		
		/**
		 * 从容器中移除
		 * @param	evt
		 */
		private function removedHandler(evt:Event):void
		{
			
			if (evt.target != displayObject) return;
			
			displayObject.addEventListener(Event.EXIT_FRAME, doRemove);
			
		}
		
		private function doRemove(evt:Event):void
		{
			
			displayObject.removeEventListener(Event.EXIT_FRAME, doRemove);
			
			rnTarget.onRemoved();
			
		}
		
	}

}