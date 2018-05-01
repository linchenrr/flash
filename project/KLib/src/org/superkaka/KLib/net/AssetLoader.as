package org.superkaka.KLib.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.superkaka.KLib.events.AssetLoaderEvent;
	import org.superkaka.KLib.net.filedecoder.FileDecoder;
	/**
	 * 资源加载器，此类在URLLoader的基础上有较多的功能增强
	 * @author ｋａｋａ
	 */
	public class AssetLoader extends EventDispatcher
	{
		
		/**
		 * 文件id
		 */
		public var id:String;
		
		/**
		 * 加载的url
		 */
		public var url:String;
		
		/**
		 * 文件的类型
		 */
		public var fileType:String = FileType.BIN;
		
		/**
		 * 文件加载完成后的解析器，解析后的结果将填充data属性
		 * 如果未指定解析器则使用原始二进制填充
		 */
		public var fileDecoder:FileDecoder;
		
		/**
		 * 获取或设置第一次加载失败后尝试重新加载的次数
		 */
		public var retryCount:int = 2;
		
		/**
		 * 已经尝试次数
		 */
		private var attemptedCount:int;
		
		/**
		 * 已加载的字节数
		 */
		private var _bytesLoaded:uint;
		
		/**
		 * 文件的实际总字节数
		 * 此值在开始加载后第一次接收到数据时填充为准确值
		 */
		private var _bytesTotal:uint;
		
		/**
		 * 文件的预期总字节数
		 */
		public var expectedBytesTotal:uint;
		
		private var _rawData:ByteArray;
		private var _data:*;
		
		protected var urlLoader:URLLoader;
		
		
		public function AssetLoader():void
		{
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			urlLoader.addEventListener(Event.COMPLETE, loadComplete);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadError);
			
		}
		
		/**
		 * 开始加载
		 * @param	url		加载的url，如果省略此参数，则使用上一次设置的url
		 */
		public function load(url:String = null):void
		{
			if (url != null)
			{
				this.url = url;
			}
			
			attemptedCount = 1;
			tryLoad();
			
		}
		
		/**
		 * 尝试加载
		 */
		private function tryLoad():void
		{
			//trace("第" + attemptedCount + "次尝试加载资源", url);
			cancelLoad();
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			urlLoader.load(new URLRequest(url));
			
		}
		
		/**
		 * 取消加载
		 */
		public function cancelLoad():void
		{
			
			try
			{
				urlLoader.close();
			}
			catch (err:Error)
			{
				
			}
			
		}
		
		
		/**
		 * 获取加载完的内容
		 */
		public function get data():*
		{
			
			return _data;
			
		}
		
		/**
		 * 获取加载完的原始二进制数据(如果为zlib压缩数据则为解压过的)
		 */
		public function get rawData():ByteArray
		{
			return _rawData;
		}
		
		/**
		 * 获取到目前为止加载的字节数
		 */
		public function get bytesLoaded():uint 
		{
			return _bytesLoaded;
		}
		
		/**
		 * 获取文件总字节数
		 * 如果当前还未接收过一次数据无法确定实际文件大小，则返回预期总字节数
		 */
		public function get bytesTotal():uint 
		{
			return _bytesTotal == 0 ? expectedBytesTotal :_bytesTotal;
		}
		
		protected function loadProgress(evt:ProgressEvent):void
		{
			
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			
			//trace("loadProgress", id, _bytesLoaded);
			
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.PROGRESS, this));
		}
		
		protected function loadError(evt:Event):void
		{
			if (++attemptedCount > retryCount)
			{
				trace("AssetLoader加载失败: [" + id + "]  url: [" + url + "]", evt);
				dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.FAIL, this));
			}
			else
			{
				tryLoad();
			}
		}
		
		protected function doComplete(evt:Event = null):void
		{
			
			trace("AssetLoader加载完成: [" + id + "]  url: [" + url + "]");
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.COMPLETE, this));
			
		}
		
		private function loadComplete(evt:Event):void
		{
			
			var ba:ByteArray = urlLoader.data as ByteArray;
			
			try
			{
				ba.uncompress();
			}
			catch (err:Error)
			{
				
			}
			
			_rawData = ba;
			
			if (null == fileDecoder)
			{
				_data = _rawData;
				doComplete();
			}
			else
			{
				fileDecoder.decode(ba, onDecodeComplete);
			}
			
		}
		
		protected function onDecodeComplete(result:*):void
		{
			
			_data = result;
			doComplete();
			
		}
		
	}

}