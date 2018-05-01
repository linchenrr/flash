package org.superkaka.KLib.manager 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 事件侦听管理器
	 */
	public class EventRecordManager
	{
		
		static private const Dic_Targets:Dictionary = new Dictionary(false);
		
		/**
		 * 添加事件侦听
		 * @param	target						目标对象
		 * @param	type							事件类型
		 * @param	listener						侦听器
		 * @param	useCapture				对捕获阶段侦听
		 * @param	priority						优先级
		 * @param	useWeakReference		使用弱引用
		 */
		static public function addEventListener(target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			target.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if (Dic_Targets[target] == null)
			{
				Dic_Targets[target] = new EventRecordCollection();
			}
			
			var evtRecCollection:EventRecordCollection = Dic_Targets[target];
			evtRecCollection.saveEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		static public function hasEventListener(target:IEventDispatcher, type:String, useCapture:Boolean = false):Boolean
		{
			
			var evtRecCollection:EventRecordCollection = Dic_Targets[target];
			if (evtRecCollection == null) 
			{
				return false;
			}
			
			var record_event:Object = evtRecCollection.getRecord(useCapture);
			return record_event[type] != null;
			
		}
		
		/**
		 * 移除事件侦听
		 * @param	target						目标对象
		 * @param	type							事件类型
		 * @param	listener						侦听器
		 * @param	useCapture				对捕获阶段侦听
		 */
		static public function removeEventListener(target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			target.removeEventListener(type, listener, useCapture);
			
			var evtRecCollection:EventRecordCollection = Dic_Targets[target];
			if (evtRecCollection == null) 
			{
				trace("不存在的事件记录！ EventManager  removeEventListener ", target, type, listener, useCapture);
				return;
			}
			
			evtRecCollection.deleteEventListener(type, listener, useCapture);
		}
		
		/**
		 * 移除对象的所有事件侦听
		 * @param	target						目标对象
		 */
		static public function removeAllEventListener(target:IEventDispatcher):void
		{
			var evtRecCollection:EventRecordCollection = Dic_Targets[target];
			if (evtRecCollection == null) 
			{
				trace("不存在的事件记录！ EventManager  removeAllEventListener ");
				return;
			}
			
			deleteEventListener(true);
			deleteEventListener(false);
			
			function deleteEventListener(useCapture:Boolean):void
			{
				var record_event:Object = evtRecCollection.getRecord(useCapture);
				for (var type:String in record_event)
				{
					var dic_event:Dictionary = record_event[type];
					for (var key:Object in dic_event)
					{
						var listener:Function = key as Function;
						target.removeEventListener(type, listener, useCapture);
						dic_event[listener] = null;
						delete dic_event[listener];
					}
					
					record_event[type] = null;
					delete record_event[type];
				}
			}
			
			Dic_Targets[target] = null;
			delete Dic_Targets[target];
		}
		
		/**
		 * 复制源对象的所有事件侦听到目标对象
		 * @param	source						源对象
		 * @param	target						目标对象
		 */
		static public function copyAllEventListener(source:IEventDispatcher, target:IEventDispatcher):void
		{
			var evtRecCollection:EventRecordCollection = Dic_Targets[source];
			if (evtRecCollection == null) 
			{
				trace("不存在的事件记录！ EventManager  copyAllEventListener ");
				return;
			}
			
			copyEventListener(true);
			copyEventListener(false);
			
			function copyEventListener(useCapture:Boolean):void
			{
				var record_event:Object = evtRecCollection.getRecord(useCapture);
				for (var type:String in record_event)
				{
					var dic_event:Dictionary = record_event[type];
					for (var key:Object in dic_event)
					{
						var listener:Function = key as Function;
						var item_event:EventRecordItem = dic_event[listener];
						addEventListener(target, type, listener, useCapture, item_event.priority, item_event.useWeakReference);
					}
				}
			}
		}
		
		/**
		 * 将源对象的所有事件的侦听目标替换为目标对象
		 * @param	source						源对象
		 * @param	target						目标对象
		 */
		static public function replaceAllEventListener(source:IEventDispatcher, target:IEventDispatcher):void
		{
			copyAllEventListener(source, target);
			removeAllEventListener(source);
		}
		
	}

}
import flash.utils.Dictionary;
/**
 * 事件记录集合
 */
class EventRecordCollection
{
	private var record_capture:Object;
	private var record_bubbling:Object;
	public function EventRecordCollection():void
	{
		record_capture = new Object();
		record_bubbling = new Object();
	}
	
	/**
	 * 获取事件记录集
	 * @param	useCapture	侦听捕获
	 * @return						事件记录集
	 */
	public function getRecord(useCapture:Boolean):Object
	{
		if (useCapture)
		{
			return record_capture;
		}
		else
		{
			return record_bubbling;
		}
	}
	
	/**
	 * 保存事件侦听记录
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 * @param	priority
	 * @param	useWeakReference
	 */
	public function saveEventListener(type:String, listener:Function, useCapture:Boolean, priority:int, useWeakReference:Boolean):void
	{
		var record_event:Object = getRecord(useCapture);
		if (record_event[type] == null)
		{
			record_event[type] = new Dictionary();
		}
		
		var item_event:EventRecordItem = new EventRecordItem();
		item_event.priority = priority;
		item_event.useWeakReference = useWeakReference;
		
		var dic_event:Dictionary = record_event[type];
		dic_event[listener] = item_event;
	}
	
	/**
	 * 删除事件侦听记录
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 */
	public function deleteEventListener(type:String, listener:Function, useCapture:Boolean):void
	{
		var record_event:Object = getRecord(useCapture);
		var dic_event:Dictionary = record_event[type];
		dic_event[listener] = null;
		delete dic_event[listener];
		
		for each(var item_event:EventRecordItem in dic_event)
		{
			return;
		}
		
		record_event[type] = null;
		delete record_event[type];
		
	}
	
}

/**
 * 事件记录项
 */
class EventRecordItem
{
	public var priority:int;
	public var useWeakReference:Boolean;
}
