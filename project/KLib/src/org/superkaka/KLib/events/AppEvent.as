package org.superkaka.KLib.events 
{
	import flash.events.Event;
	
	/**
	 * 程序事件
	 * @author ｋａｋａ
	 */
	public class AppEvent extends Event 
	{
		
		/**
		 * 场景即将切换
		 */
		static public const ON_SCENE_CHANGE:String = "appEvent_on_sceneChange";
		
		/**
		 * 场景切换完成
		 */
		static public const SCENE_CHANGED:String = "appEvent_sceneChanged";
		
		/**
		 * loading设置
		 */
		static public const LOADING_SET:String = "appEvent_loading_set";
		
		/**
		 * 设置loading是否显示
		 */
		static public const LOADING_VISIBLE_SET:String = "appEvent_loadingVisible_set";
		
		/**
		 * 请求资源
		 */
		static public const RESOURCE_REQUEST:String = "appEvent_resource_request";
		
		/**
		 * 请求的资源准备完成
		 */
		static public const RESOURCE_READY:String = "appEvent_resource_ready";
		
		private var _data:Object;
		
		public function AppEvent(type:String, data:Object = null):void
		{ 
			super(type);
			this._data = data || { };
		} 
		
		public override function clone():Event 
		{ 
			return new AppEvent(type, _data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AppEvent", "type"); 
		}
		
		public function get data():Object { return _data; }
		
	}
	
}