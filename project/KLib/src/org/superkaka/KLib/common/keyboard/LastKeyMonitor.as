package org.superkaka.KLib.common.keyboard 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	/**
	 * 监视一组按键中最后按下的键并在改变时通知
	 * @author ｋａｋａ
	 */
	public class LastKeyMonitor extends EventDispatcher
	{
		
		private var _target:EventDispatcher;
		private var list_keyWatch:Array = [];
		private var list_key:Array = [];
		private var dic_key:Object = { };
		
		public function LastKeyMonitor(target:EventDispatcher, ...keys):void
		{
			
			list_keyWatch = keys;
			
			_target = target;
			_target.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_target.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
		}
		
		/**
		 * 获取当前最优先按键
		 */
		public function get currentKeyCode():uint
		{
			return list_key[list_key.length - 1];
		}
		
		private function keyIsDown(keyCode:uint):Boolean
		{
			
			if (dic_key[keyCode] == null || dic_key[keyCode] == false) return false;
			
			return true;
			
		}
		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			
			var keyCode:uint = evt.keyCode;
			
			var index:int = list_keyWatch.indexOf(keyCode);
			if (index != -1)
			{
				
				if (!keyIsDown(keyCode))
				{
					list_key.push(keyCode);
					dispatchEvent(new Event(Event.CHANGE));
				}
				
			}
			
			dic_key[keyCode] = true;
			
		}
		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			
			var keyCode:uint = evt.keyCode;
			dic_key[keyCode] = false;
			
			var index:int = list_key.indexOf(keyCode);
			if (index != -1)
			{
				
				var needNotify:Boolean = index == list_key.length - 1;
				list_key.splice(index, 1);
				if(needNotify)
				dispatchEvent(new Event(Event.CHANGE));
				
			}
			
		}
		
		
	}

}