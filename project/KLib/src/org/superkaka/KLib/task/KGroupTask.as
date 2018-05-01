package org.superkaka.KLib.task 
{
	import org.superkaka.KLib.events.KTaskEvent;
	/**
	 * 任务群组
	 * @author ｋａｋａ
	 */
	public class KGroupTask extends KTask
	{
		
		private var dic_task:Object;
		
		private var taskIdSeed:int;
		
		public function KGroupTask():void
		{
			
			dic_task = { };
			
		}
		
		public function addTask(task:KTask, taskId:String = null, pec:Number = 1):String
		{
			
			if (taskId == null) taskId = String(++taskIdSeed);
			else if (dic_task[taskId] != null) throw new Error("已经存在的任务id" + taskId);
			
			var taskInfo:TaskInfo = new TaskInfo();
			taskInfo.task = task;
			taskInfo.taskId = taskId;
			taskInfo.pec = pec;
			
			dic_task[taskId] = taskInfo;
			
			return taskId;
			
		}
		
		public function getTask(taskId:String):KTask
		{
			
			return dic_task[taskId].task;
			
		}
		
		override protected function onStart():void
		{
			
			addListeners();
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				taskInfo.task.start();
				
			}
			
		}
		
		override protected function onPause():void
		{
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				taskInfo.task.pause();
				
			}
			
			removeListeners();
			
		}
		
		override protected function onCancel():void
		{
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				taskInfo.task.cancel();
				
			}
			
			removeListeners();
			
		}
		
		override protected function onComplete():void
		{
			
			removeListeners();
			
		}
		
		public function dispose():void
		{
			
			onCancel();
			
			for(var key:String in dic_task)
			{
				
				dic_task[key] = null;
				delete dic_task[key];
				
			}
			
			dic_task = null;
			
		}
		
		private function addListeners():void
		{
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				taskInfo.task.addEventListener(KTaskEvent.PROGRESS, subTaskProgressHandler);
				taskInfo.task.addEventListener(KTaskEvent.COMPLETE, subTaskCompleteHandler);
				
			}
			
		}
		
		private function removeListeners():void
		{
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				taskInfo.task.removeEventListener(KTaskEvent.PROGRESS, subTaskProgressHandler);
				taskInfo.task.removeEventListener(KTaskEvent.COMPLETE, subTaskCompleteHandler);
				
			}
			
		}
		
		private function subTaskProgressHandler(evt:KTaskEvent):void
		{
			
			updateProgress();
			
		}
		
		private function subTaskCompleteHandler(evt:KTaskEvent):void
		{
			
			checkComplete();
			
		}
		
		/**
		 * 更新进度
		 */
		private function updateProgress():void
		{
			
			var totalPec:Number = 0;
			var curPec:Number = 0;
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				curPec += taskInfo.task.progress * taskInfo.pec;
				totalPec += taskInfo.pec;
				
			}
			
			changeProgress(curPec / totalPec);
			
		}
		
		/**
		 * 检查子任务是否已经全部完成
		 */
		private function checkComplete():void
		{
			
			for each(var taskInfo:TaskInfo in dic_task)
			{
				
				if (taskInfo.task.state != KTaskState.COMPLETE) return;
				
			}
			
			complete();
			
		}
		
	}

}
import org.superkaka.KLib.task.KTask
class TaskInfo
{
	public var task:KTask;
	public var taskId:String;
	public var pec:Number;
}