package org.superkaka.KLib.events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 全局事件发送、监听
	 * @author ｋａｋａ
	 */
	public class GlobalEventDispatcher
	{
		
		static private const eventDispatcher:IEventDispatcher = new EventDispatcher();
		
		/**
		 * 使用 GlobalEventDispatcher 注册事件侦听器对象，以使侦听器能够接收事件通知。
		 * @param	type								事件的类型
		 * @param	listener							处理事件的侦听器函数
		 * @param	useCapture					确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段
		 * @param	priority							事件侦听器的优先级
		 * @param	useWeakReference			确定对侦听器的引用是强引用，还是弱引用
		 */
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			
			return eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		/**
		 * 发送全局事件
		 * @param	event							调度到事件流中的事件对象
		 * @return
		 */
		static public function dispatchEvent(event:Event):Boolean
		{
			
			return eventDispatcher.dispatchEvent(event);
			
		}
		
		/**
		 * 从 GlobalEventDispatcher 对象中删除侦听器。如果没有向 GlobalEventDispatcher 对象注册任何匹配的侦听器，则对此方法的调用没有任何效果
		 * @param	type								事件的类型
		 * @param	listener							要删除的侦听器对象
		 * @param	useCapture					指出是为捕获阶段还是为目标和冒泡阶段注册了侦听器
		 */
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			
			return eventDispatcher.removeEventListener(type, listener, useCapture);
			
		}
		
		/**
		 * 检查 GlobalEventDispatcher 对象是否为特定事件类型注册了任何侦听器
		 * @param	type								事件的类型
		 * @return
		 */
		static public function hasEventListener(type:String):Boolean
		{
			
			return eventDispatcher.hasEventListener(type);
			
		}
		
		/**
		 * 获取事件侦听、发送的全局实例
		 */
		static public function get dispatcher():IEventDispatcher 
		{
			return eventDispatcher;
		}
		
	}

}
