package org.superkaka.KLib.events 
{
	import flash.events.Event;
	
	/**
	 * 通用事件类
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-30-星期五 18:36
	 */
	public class CommonEvent extends Event 
	{
		
		private var _data:Object;
		
		public function CommonEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):void
		{ 
			super(type, bubbles, cancelable);
			this._data = data || { };
		} 
		
		public override function clone():Event 
		{ 
			return new CommonEvent(type, _data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CommonEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object { return _data; }
		
	}
	
}