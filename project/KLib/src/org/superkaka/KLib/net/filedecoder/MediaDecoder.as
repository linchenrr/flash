package org.superkaka.KLib.net.filedecoder 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	/**
	 * 解码SWF、JPG、PNG、GIF文件
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 16:45
	 */
	public class MediaDecoder extends FileDecoder 
	{
		
		private var _domain:ApplicationDomain;
		protected var loader:Loader;
		
		public function MediaDecoder():void
		{
			
		}
		
		override protected function onDecode(source:ByteArray):void
		{
			
			loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,  loadBytesComplete);
			
			if (null == _domain)
			{
				loader.loadBytes(source);
			}
			else
			{
				loader.loadBytes(source, new LoaderContext(false, _domain));
			}
			
		}
		
		private function loadBytesComplete(evt:Event):void
		{
			
			complete(loader.content);
			
		}
		
		/**
		 * 获取或设置解码SWF文件时将其中的类定义加载到的目标程序域
		 * 此属性只在加载SWF文件并需要访问其中的类定义时有用
		 */
		public function get domain():ApplicationDomain 
		{
			return _domain;
		}
		
		public function set domain(value:ApplicationDomain):void 
		{
			_domain = value;
		}
		
	}

}