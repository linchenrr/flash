package org.superkaka.KLib.net 
{
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import org.superkaka.KLib.events.AssetLoaderEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import org.superkaka.KLib.net.filedecoder.FileDecoder;
	import org.superkaka.KLib.struct.FileInfo;
	
	/**
	 * 多进程队列加载器
	 * @author ｋａｋａ
	 */
	
	[Event(name = "progress", type = "flash.events.ProgressEvent")] 
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class MultiLoader extends EventDispatcher
	{
		
		/**
		 * 默认最大加载进程数
		 */
		static public const defaultMaxProcess:int = 3;
		
		/**
		 * loader队列
		 */
		private var queue_loader:Array;
		
		/**
		 * 等待加载的队列
		 */
		private var queue_wait:Array;
		
		/**
		 * 正在执行加载进程的队列
		 */
		private var queue_process:Array;
		
		/**
		 * 已经加载完成的loader队列
		 */
		private var queue_loaded:Array;
		
		/**
		 * 加载失败的loader队列
		 */
		private var queue_failed:Array;
		
		/**
		 * 自动开始下载
		 */
		private var _autoStart:Boolean = false;
		
		/**
		 * 是否正在加载
		 */
		private var isInProcess:Boolean = false;
		
		/**
		 * 最大加载进程数
		 */
		private var _maxProcess:int = defaultMaxProcess;
		
		public function MultiLoader():void
		{
			queue_loader = [];
			queue_wait = [];
			queue_process = [];
			queue_loaded = [];
			queue_failed = [];
		}
		
		/**
		 * 根据名称获取已加载的数据
		 * @param	id			名称
		 * @return
		 */
		public function getLoadedData(id:String):*
		{
			for each(var loader:AssetLoader in queue_loaded)
			{
				if (loader.id == id)
				{
					return loader.data;
				}
			}
		}
		
		/**
		 * 开始加载进程
		 */
		public function start():void
		{
			isInProcess = true;
			checkQueue();
		}
		
		/**
		 * 停止加载进程
		 */
		public function stop():void
		{
			isInProcess = false;
			
			while (queue_process.length > 0)
			{
				
				var loader:AssetLoader = queue_process.pop() as AssetLoader;
				loader.cancelLoad();
				queue_wait.unshift(loader);
				
			}
		}
		
		/**
		 * 获取当前是否正在进行加载操作
		 */
		public function get isLoading():Boolean
		{
			return isInProcess;
		}
		
		/**
		 * 添加一个loader至队列
		 * @param	loader	
		 */
		public function appendLoader(loader:AssetLoader):void
		{
			
			var id:String = loader.id;
			//trace("addInQueue",id)
			//if (queue_id.indexOf(id) != -1) throw new Error("已经添加的文件id:" + id);
			if (getQueueId(queue_loader).indexOf(id) != -1)
			return;
			
			queue_loader.push(loader);
			queue_wait.push(loader);
			
			if (autoStart)
			{
				start();
			}
			
		}
		
		/**
		 * 
		 * @param	url										加载文件的url
		 * @param	id										加载文件的关联id
		 * @param	expectedBytesTotal				文件的预期字节数，在计算下载的总字节数时如果实际字节数未填充将使用此值
		 * @param	fileDecoder							文件加载完成后的解析器
		 * @param	fileType								加载文件的类型
		 */
		public function append(url:String, id:String, expectedBytesTotal:uint = 0, fileDecoder:FileDecoder = null, fileType:String = FileType.BIN):void
		{
			
			var loader:AssetLoader = new AssetLoader();
			loader.url = url;
			loader.id = id;
			loader.fileDecoder = fileDecoder;
			loader.expectedBytesTotal = expectedBytesTotal;
			loader.fileType = fileType;
			
			appendLoader(loader);
			
		}
		
		/**
		 * 清除所有信息
		 */
		public function clear():void
		{
			stop();
			queue_loader.splice(0);
			queue_wait.splice(0);
			queue_process.splice(0);
			queue_loaded.splice(0);
			queue_failed.splice(0);
		}
		
		/**
		 * 清除等待队列的信息
		 */
		public function clearWaitingQueue():void
		{
			
			for each(var loader:AssetLoader in queue_wait)
			{
				queue_loader.splice(queue_loader.indexOf(loader), 1);
			}
			
			queue_wait.splice(0);
			
		}
		
		
		/**
		 * 检测队列  是否需要进行下一个加载
		 */
		private function checkQueue():void
		{
			if (!isInProcess) return;
			
			if (queue_wait.length == 0)
			{
				if (queue_process.length == 0)
				{
					isInProcess = false;
					
					trace("总数：" + queue_loader.length);
					trace("完成：" + queue_loaded.length);
					trace("失败：" + queue_failed.length);
					dispatchEvent(new Event(Event.COMPLETE));
				}
				return;
			}
			
			if (_maxProcess > 0 && queue_process.length >= maxProcess) return;
			
			var loader:AssetLoader = queue_wait.shift();
			queue_process.push(loader);
			loader.addEventListener(AssetLoaderEvent.COMPLETE, loadProcessCompleteHandler, false, 0, true);
			loader.addEventListener(AssetLoaderEvent.PROGRESS, loadProcessDataHandler, false, 0, true);
			loader.addEventListener(AssetLoaderEvent.FAIL, loadProcessFailHandler, false, 0, true);
			loader.load();
			//trace("checkQueue", queue_process.length, _maxProcess, queue_wait.length, loader.id);
			checkQueue();
		}
		
		/**
		 * 自动开始下载
		 */
		public function set autoStart(value:Boolean):void 
		{
			_autoStart = value;
			if (autoStart)
			{
				start();
			}
		}
		
		/**
		 * 自动开始下载
		 */
		public function get autoStart():Boolean { return _autoStart; }
		
		/**
		 * 最大加载进程数  小于等于0为无限制。默认值为3
		 */
		public function set maxProcess(value:int):void 
		{
			_maxProcess = value;
			checkQueue();
		}
		
		/**
		 * 最大加载进程数  小于等于0为无限制。默认值为3
		 */
		public function get maxProcess():int { return _maxProcess; }
		
		
		/**
		 * 指示加载操作期间到目前为止加载的字节数
		 */
		public function get bytesLoaded():uint 
		{
			var bytes:uint = 0;
			for each(var loader:AssetLoader in queue_loaded)
			{
				bytes += loader.bytesTotal;
			}
			
			for each(loader in queue_process)
			{
				bytes += loader.bytesLoaded;
			}
			
			return bytes;
			
		}
		
		/**
		 * 获取下载队列的总字节数
		 */
		public function get bytesTotal():uint 
		{
			var bytes:uint = 0;
			for each(var loader:AssetLoader in queue_loader)
			{
				bytes += loader.bytesTotal;
			}
			return bytes
		}
		
		/**
		 * 一个加载进程完成
		 * @param	evt
		 */
		private function loadProcessCompleteHandler(evt:AssetLoaderEvent):void
		{
			var loader:AssetLoader = evt.loader;
			queue_loaded.push(loader);
			removeLoaderInProcessQueue(loader);
			dispatchEvent(evt);
			checkQueue();
		}
		
		/**
		 * 一个加载进程接收到数据
		 * @param	evt
		 */
		private function loadProcessDataHandler(evt:AssetLoaderEvent):void
		{
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
			
		}
		
		/**
		 * 一个加载进程失败
		 * @param	evt
		 */
		private function loadProcessFailHandler(evt:AssetLoaderEvent):void
		{
			var loader:AssetLoader = evt.loader;
			queue_failed.push(loader);
			removeLoaderInProcessQueue(loader);
			dispatchEvent(evt);
			checkQueue();
		}
		
		/**
		 * 从加载进程队列移除一个进程对象
		 * @param	loader
		 */
		private function removeLoaderInProcessQueue(loader:AssetLoader):void
		{
			
			loader.removeEventListener(AssetLoaderEvent.COMPLETE, loadProcessCompleteHandler);
			loader.removeEventListener(AssetLoaderEvent.FAIL, loadProcessFailHandler);
			loader.removeEventListener(AssetLoaderEvent.PROGRESS, loadProcessDataHandler);
			
			var index:int = queue_process.indexOf(loader);
			if (index == -1)
			{
				throw new Error("内部错误！ 需要移除的loader不在进程列表中");
			}
			
			queue_process.splice(index, 1);
			
		}
		
		public function getLoader(id:String):AssetLoader
		{
			
			var i:int = 0;
			var c:int = queue_loader.length;
			
			var list_id:Array = new Array(c);
			
			while (i < c)
			{
				var loader:AssetLoader = queue_loader[i] as AssetLoader;
				if (loader.id == id)
				{
					return loader;
				}
				
				i++;
			}
			
			return null;
			
		}
		
		private function getQueueId(queue:Array):Array
		{
			
			var i:int = 0;
			var c:int = queue.length;
			
			var list_id:Array = new Array(c);
			
			while (i < c)
			{
				list_id[i] = (queue[i] as AssetLoader).id;
				
				i++;
			}
			
			return list_id; 
			
		}
		
		/**
		 * 加载完成的id列表
		 */
		public function get completeId():Array
		{
			return getQueueId(queue_loaded);
		}
		
		/**
		 * 加载失败的id列表
		 */
		public function get failedId():Array
		{
			return getQueueId(queue_failed);
		}
		
		/**
		 * 正在加载的id列表
		 */
		public function get processId():Array
		{
			return getQueueId(queue_process);
		}
		
	}

}