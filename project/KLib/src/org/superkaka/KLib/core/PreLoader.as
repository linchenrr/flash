package org.superkaka.KLib.core
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import org.superkaka.KLib.struct.FileInfo;
	/**
	 * 预加载
	 * @author ｋａｋａ
	 */
	[SWF(width=800, height=600, frameRate=30)]
	public class PreLoader extends Sprite
	{
		
		protected var url_loading:String;
		
		protected var url_main:String;
		
		protected var url_fileInfo:String;
		
		protected var loader_preloaderAsset:Loader;
		
		protected var loader_main:Loader;
		
		protected var urlLoader:URLLoader;
		
		/**
		 * 主程序
		 */
		protected var mainApp:IEngine;
		
		/**
		 * loading显示资源
		 */
		protected var loading:MovieClip;
		
		/**
		 * 主版本号
		 */
		private var buildVersion:String;
		
		
		public function PreLoader(url_main:String = "main.swf", url_loading:String = "loading.swf", url_fileInfo:String = "fileInfo.txt"):void
		{
			
			Security.allowDomain("*");
			
			this.url_main = url_main;
			this.url_fileInfo = url_fileInfo;
			this.url_loading = url_loading;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		}
		
		private function addToStageHandler(evt:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			start();
			
		}
		
		private function start():void
		{
			
			trace("start PreLoader");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var error:Error;
			
			if (ExternalInterface.available)
			{
				try
				{
					var fileInfoPath:String = ExternalInterface.call("getFileInfoPath");
					if (fileInfoPath != null)
					url_fileInfo = fileInfoPath;
				}
				catch(err:Error)
				{
					error = err;
				}
			}
			
			loadFileInfo();
			
			if (null != error)
			throw error;
			
		}
		
		private function loadFileInfo():void
		{
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, fileInfoCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadPreLoaderAsset);
			
			urlLoader.load(new URLRequest(url_fileInfo));
			
		}
		
		private function fileInfoCompleteHandler(evt:Event):void
		{
			
			var ba:ByteArray = urlLoader.data as ByteArray;
			
			try
			{
				ba.uncompress();
			}
			catch (err:Error)
			{
				
			}
			
			var fileInfo:String = ba.toString();
			
			FileInfo.fillData(fileInfo);
			
			loadPreLoaderAsset();
			
		}
		
		/**
		 * 加载preloader资源
		 */
		private function loadPreLoaderAsset(evt:Event = null):void
		{
			
			urlLoader.removeEventListener(Event.COMPLETE, fileInfoCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadPreLoaderAsset);
			
			loader_preloaderAsset = new Loader();
			loader_preloaderAsset.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_preloaderAssetCompleteHandler);
			loader_preloaderAsset.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var fileInfo:FileInfo = FileInfo.getFileInfo(url_loading);
			
			loader_preloaderAsset.load(new URLRequest(fileInfo.loadPath), new LoaderContext(false, ApplicationDomain.currentDomain));
			
			if (evt is IOErrorEvent)
			{
				//ioErrorHandler(evt as IOErrorEvent);
			}
		}
		
		/**
		 * preloader资源加载完成
		 */
		private function loader_preloaderAssetCompleteHandler(evt:Event):void
		{
			
			loading = loader_preloaderAsset.content as MovieClip;
			
			loader_preloaderAsset.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_preloaderAssetCompleteHandler);
			
			stage.addChild(loading);
			
			urlLoader.addEventListener(Event.COMPLETE, mainCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var fileInfo:FileInfo = FileInfo.getFileInfo(url_main);
			
			urlLoader.load(new URLRequest(fileInfo.loadPath));
			
		}
		
		/**
		 * 在载入主swf文件前对其进行二进制处理
		 * @param	bytes
		 * @return
		 */
		protected function transformMainSwfBytes(bytes:ByteArray):ByteArray
		{
			
			return bytes;
			
		}
		
		private function mainCompleteHandler(evt:Event):void
		{
			
			var mainSwfBytes:ByteArray = transformMainSwfBytes(urlLoader.data as ByteArray);
			
			loader_main = new Loader();
			loader_main.contentLoaderInfo.addEventListener(Event.COMPLETE, mainSwfReadyHandler);
			
			loader_main.loadBytes(mainSwfBytes);
			
		}
		
		/**
		 * 主程序加载完成
		 */
		private function mainSwfReadyHandler(evt:Event):void
		{
			
			mainApp = loader_main.content as IEngine;
			
			loader_main.contentLoaderInfo.removeEventListener(Event.COMPLETE, mainSwfReadyHandler);
			//loader_main.unload();
			
			mainApp.setLoadingAsset(loading);
			
			var stage:Stage = this.stage;
			
			stage.removeChild(this);
			
			//添加主程序至舞台，主程序执行初始化
			stage.addChild(mainApp as DisplayObject);
			
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			throw new Error("资源加载失败\r\n" + evt.text);
		}
		
	}

}