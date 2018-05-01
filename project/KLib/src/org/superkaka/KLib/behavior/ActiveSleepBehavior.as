package org.superkaka.KLib.behavior 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.superkaka.KLib.interfaces.IActiveSleep;
	/**
	 * 为目标添加被加入显示列表时激活和移出显示列表时休眠的行为
	 * 解决了使用传统的 REMOVED_FROM_STAGE 事件时如果目标从一个容器添加进另一个容器但实际并没有离开舞台的情况下会意外触发事件的问题
	 * @author ｋａｋａ
	 */
	public class ActiveSleepBehavior extends DisplayObjectBehavior
	{
		
		protected var isSleep:Boolean;
		
		protected var asTarget:IActiveSleep;
		
		public function ActiveSleepBehavior(target:IActiveSleep):void
		{
			
			super(target as DisplayObject);
			
		}
		
		override protected function init():void
		{
			
			asTarget = target as IActiveSleep;
			
		}
		
		override public function start():void
		{
			
			isSleep = displayObject.stage == null;
			
			if (isSleep)
			asTarget.sleep();
			else
			asTarget.active();
			
			displayObject.addEventListener(Event.ADDED_TO_STAGE, showHandler);
			
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
			
		}
		
		override public function stop():void
		{
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, showHandler);
			
			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
		}
		
		/**
		 * 添加到显示列表
		 * @param	evt
		 */
		private function showHandler(evt:Event):void
		{
			
			displayObject.removeEventListener(Event.EXIT_FRAME, doSleep);
			
			if (!isSleep) return;
			
			isSleep = false;
			
			asTarget.active();
			
		}
		
		/**
		 * 从显示列表移除
		 * @param	evt
		 */
		private function hideHandler(evt:Event):void
		{
			
			displayObject.addEventListener(Event.EXIT_FRAME, doSleep);
			
		}
		
		private function doSleep(evt:Event):void
		{
			
			displayObject.removeEventListener(Event.EXIT_FRAME, doSleep);
			
			if (isSleep) return;
			
			isSleep = true;
			
			if (displayObject.stage != null) throw new Error();//本行在测试一段时间没问题之后删除
			
			asTarget.sleep();
			
		}
		
	}

}