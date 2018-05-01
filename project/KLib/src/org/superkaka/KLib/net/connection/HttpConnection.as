package org.superkaka.KLib.net.connection 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	/**
	 * 基于http协议的网络通信连接组件
	 * @author ｋａｋａ
	 */
	public class HttpConnection extends Connection
	{
		
		public var URI:String;
		
		public function HttpConnection():void
		{
			
		}
		
		override public function connect():void
		{
			
			trace("HttpConnection connect !");
			
		}
		
		override protected function onSend(data:ByteArray):void
		{
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, requestCompleteHandler);
			
			var request:URLRequest = new URLRequest(URI);
			request.contentType = "application/octet-stream";
			request.method = URLRequestMethod.POST;
			request.data = data;
			
			loader.load(request);
			
		}
		
		private function requestCompleteHandler(evt:Event):void
		{
			
			var loader:URLLoader = evt.target  as URLLoader;
			loader.removeEventListener(Event.COMPLETE, requestCompleteHandler);
			
			distributeData(loader.data);
			
		}
		
	}

}