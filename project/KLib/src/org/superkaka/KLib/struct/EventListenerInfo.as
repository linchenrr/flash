package org.superkaka.KLib.struct 
{
	import flash.events.IEventDispatcher;
	/**
	 * 事件侦听信息
	 * @author ｋａｋａ
	 */
	public class EventListenerInfo
	{
		
		public var target:IEventDispatcher;
		public var type:String;
		public var listener:Function;
		public var useCapture:Boolean;
		public var priority:int;
		public var useWeakReference:Boolean;
		
		public function EventListenerInfo(target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			
			this.target = target;
			this.type = type;
			this.listener = listener;
			this.useCapture = useCapture;
			this.priority = priority;
			this.useWeakReference = useWeakReference;
			
		}
		
	}

}