package org.superkaka.KLib.events 
{
	import flash.events.Event;
	import org.superkaka.KLib.net.AssetLoader;
	
	/**
	 * 资源加载事件
	 * @author ｋａｋａ
	 */
	public class AssetLoaderEvent extends Event 
	{
		
		/**
		 * 在下载操作过程中收到数据时调度
		 */
		static public const PROGRESS:String = "load_progress";
		
		/**
		 * 加载完成
		 */
		static public const COMPLETE:String = "load_complete";
		
		/**
		 * 加载错误
		 */
		static public const FAIL:String = "load_fail";
		
		private var _loader:AssetLoader;
		
		public function AssetLoaderEvent(type:String, loader:AssetLoader):void 
		{ 
			super(type);
			this._loader = loader;
		} 
		
		public override function clone():Event 
		{ 
			return new AssetLoaderEvent(type, loader);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AssetLoaderEvent", "type");
		}
		
		/**
		 * 获取关联的loader对象
		 */
		public function get loader():AssetLoader { return _loader; }
		
	}
	
}