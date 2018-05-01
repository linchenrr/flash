package org.superkaka.KLib.manager
{
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */

	public class EnterFrameManager
	{
		
		///注册列表
		static private const list:Array = [];
		
		static private var stage:Stage;
		
		static public function init(stg:Stage):void
		{
			stage = stg;
		}
		
		/**
		 * 注册帧频调用函数
		 * @param fun
		 * 
		 */		
		static public function registerEnterFrameFunction(fun:Function):void
		{
			var index:int=list.indexOf(fun);
			if(index != -1)
			{
				return;
			}
			
			list.push(fun);
		}
		
		/**
		 * 移除帧频调用函数
		 * @param fun
		 * 
		 */		
		static public function removeEnterFrameFunction(fun:Function):void
		{
			var index:int=list.indexOf(fun);
			if(index==-1)
			{
				return;
			}
			
			list.splice(index,1);
		}
		
		/**
		 * 开始调度帧频事件 
		 */
		static public function startEnterFrame():void
		{
			
			stage.addEventListener(Event.ENTER_FRAME, enterFramehandler);
			
		}
		
		/**
		 * 停止调度帧频事件 
		 * 
		 */		
		static public function stopEnterFrame():void
		{
			
			stage.removeEventListener(Event.ENTER_FRAME, enterFramehandler);
			
		}
		
		static private function enterFramehandler(evt:Event):void
		{
			doEnterFrame();
		}
		
		static private function doEnterFrame():void
		{
			///备份函数列表  防止在列表函数中执行registerEnterFrameFunction和removeEnterFrameFunction导致遍历列表出错
			var list_copy:Array = list.concat();
			
			var c:int = list_copy.length;
			var i:int = 0;
			while (i < c)
			{
				list_copy[i]();
				i++;
			}
			
		}
		
	}
}