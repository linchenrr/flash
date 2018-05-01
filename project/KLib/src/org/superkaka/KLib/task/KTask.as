package org.superkaka.KLib.task 
{
	import flash.events.EventDispatcher;
	import org.superkaka.KLib.events.KTaskEvent;
	/**
	 * 任务进程
	 * @author ｋａｋａ
	 */
	public class KTask extends EventDispatcher
	{
		
		/**
		 * 任务进度
		 */
		private var _progress:Number = 0;
		
		/**
		 * 任务当前状态
		 */
		private var _state:String = KTaskState.UNSTARTED;
		
		public function KTask():void
		{
			
		}
		
		public function start():void
		{
			
			_state = KTaskState.RUNNING;
			
			dispatchEvent(new KTaskEvent(KTaskEvent.START, _progress));
			
			onStart();
			
		}
		
		protected function onStart():void
		{
			
		}
		
		public function pause():void
		{
			
			onPause();
			
			_state = KTaskState.PAUSE;
			
			dispatchEvent(new KTaskEvent(KTaskEvent.PAUSE, _progress));
			
		}
		
		protected function onPause():void
		{
			
		}
		
		public function cancel():void
		{
			
			onCancel();
			
			_state = KTaskState.CANCELED;
			
			dispatchEvent(new KTaskEvent(KTaskEvent.CANCEL, _progress));
			
		}
		
		protected function onCancel():void
		{
			
		}
		
		protected function complete():void
		{
			
			onComplete();
			
			_state = KTaskState.COMPLETE;
			
			dispatchEvent(new KTaskEvent(KTaskEvent.COMPLETE, 1));
			
		}
		
		protected function onComplete():void
		{
			
		}
		
		/**
		 * 更新进度
		 */
		protected function changeProgress(pec:Number):void
		{
			
			_progress = pec;
			
			dispatchEvent(new KTaskEvent(KTaskEvent.PROGRESS, _progress));
			
		}
		
		/**
		 * 任务进度
		 */
		public function get progress():Number 
		{
			return _progress;
		}
		
		/**
		 * 任务当前状态
		 */
		public function get state():String 
		{
			return _state;
		}
		
	}

}