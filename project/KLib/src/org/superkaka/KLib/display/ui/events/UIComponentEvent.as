package org.superkaka.KLib.display.ui.events 
{
	import flash.events.Event;
	
	/**
	 * UI组件事件
	 * @author ｋａｋａ
	 */
	public class UIComponentEvent extends Event
	{
		
		/**
		 * 组件更新
		 */
		static public const UPDATE:String = "UIComponentEvent_UPDATE";
		
		/**
		 * 状态改变
		 */
		static public const CHANGE:String = "UIComponentEvent_CHANGE";
		
		/**
		 * 子选择项选中
		 */
		//static public const SELECT:String = "UIComponentEvent_SELECT";
		
		/**
		 * 页数改变
		 */
		static public const PAGE_CHANGE:String = "UIComponentEvent_PAGE_CHANGE";
		
		private var _data:Object;
		
		public function UIComponentEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			
			super(type, bubbles, cancelable);
			
			if (null == data) data = { };
			
			this._data = data;
			
		}
		
		public override function clone():Event 
		{ 
			
			return new UIComponentEvent(type, data, bubbles, cancelable);
			
		} 
		
		public override function toString():String 
		{ 
			
			return formatToString(
			"UIComponentEvent", 
			"type", 
			"data",
			"bubbles",
			"cancelable"
			); 
			
		}
		
		public function get data():Object 
		{
			
			return _data;
			
		}
		
	}

}