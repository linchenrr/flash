package org.superkaka.KLib.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 数据模型基类
	 * @author ｋａｋａ
	 */
	public class KModel extends EventDispatcher
	{
		
		private var list_eventToDispatch:Vector.<Event> = new Vector.<Event>();
		
		private var _invalidNotify:Boolean;
		
		public function KModel():void
		{
			
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			
			if (_invalidNotify)
			{
				
				list_eventToDispatch.push(event);
				
				return false;
			}
			else
			{
				return super.dispatchEvent(event);
			}
			
		}
		
		/**
		 * 设置是否使更新通知失效
		 * @param	invalid
		 * @param	distributeEvent		如果invalid值为false，则此参数指示是否分发自从失效以来累积的事件
		 */
		public function invalidNotify(invalid:Boolean, distributeEvent:Boolean = true):void
		{
			
			_invalidNotify = invalid;
			
			if (false == invalid && true == distributeEvent)
			{
				
				var list_eventToDispatch:Vector.<Event> = this.list_eventToDispatch.concat();
				this.list_eventToDispatch.splice(0, uint.MAX_VALUE);
				
				var i:int = 0;
				var c:int = list_eventToDispatch.length;
				while (i < c) 
				{
					
					super.dispatchEvent(list_eventToDispatch[i]);
					
					i++;
				}
				
			}
			
		}
		
		/**
		 * 发送通用更新通知
		 */
		public function notifyChange():void
		{
			
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
	}

}