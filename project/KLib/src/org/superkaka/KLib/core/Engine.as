package  org.superkaka.KLib.core
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import org.superkaka.KLib.data.KTable;
	import org.superkaka.KLib.events.AppEvent;
	import org.superkaka.KLib.events.GlobalEventDispatcher;
	import org.superkaka.KLib.events.AssetLoaderEvent;
	import org.superkaka.KLib.i18n.I18NTextManager;
	import org.superkaka.KLib.manager.AssetManager;
	import org.superkaka.KLib.manager.ClassManager;
	import org.superkaka.KLib.manager.SoundManager;
	import org.superkaka.KLib.net.filedecoder.FileDecoder;
	import org.superkaka.KLib.net.filedecoder.getFileDecoder;
	import org.superkaka.KLib.net.filedecoder.MediaDecoder;
	import org.superkaka.KLib.net.FileType;
	import org.superkaka.KLib.net.AssetLoader;
	import org.superkaka.KLib.net.MultiLoader;
	import org.superkaka.KLib.struct.FileInfo;
	import org.superkaka.KLib.struct.ResourceInfo;
	import org.superkaka.KLib.struct.ResourceRequest;
	import org.superkaka.KLib.utils.StringTool;
	import org.superkaka.KLib.display.loading.DefaultLoading;
	import org.superkaka.KLib.display.loading.ILoading;
	
	/**
	 * 程序启动流程引擎，载入游戏资源并执行一系列初始化操作，启动游戏
	 * @author ｋａｋａ
	 */
	[SWF(width=800, height=600, frameRate=30)]
	public class Engine extends Sprite implements IEngine
	{
		
		private var url_config:String;
		
		protected var multiLoader:MultiLoader;
		
		/**
		 * 注册的回调函数集合
		 */
		private var map_callBack:Object;
		
		/**
		 * 开始前的步骤
		 */
		private var list_steps:Array =
		[
			loadConfig,
			registerLoadCallBack,
			loadFirstResources,
		];
		
		/**
		 * 配置
		 */
		private var config:XML;
		
		/**
		 * build主版本号
		 */
		protected var buildVersion:String = "null";
		
		protected var loading:ILoading = new DefaultLoading();
		
		protected var loadingContainer:DisplayObjectContainer;
		
		public function Engine(loading:ILoading = null):void
		{
			
			Security.allowDomain("*");
			
			if (null != loading) this.loading = loading;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		}
		
		/**
		 * 设置loading资源
		 * @param	loading
		 */
		public function setLoadingAsset(loadingAsset:MovieClip):void
		{
			
			loading.content = loadingAsset;
			
		}
		
		/**
		 * 添加至舞台,开始初始化进程
		 */
		private function addToStageHandler(evt:Event):void
		{
			
			trace("init Engine");
			
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			start();
			
		}
		
		/**
		 * 开始加载之前
		 */
		protected function beforeStart():void
		{
			///由子类覆写
		}
		
		/**
		 * 程序配置载入，初始化完成
		 */
		protected function onApplicationInit():void
		{
			///由子类覆写
		}
		
		/**
		 * 开始请求资源
		 */
		protected function onResourceRequest():void
		{
			///由子类覆写
		}
		
		/**
		 * 资源准备完成
		 */
		protected function onResourceReady():void
		{
			///由子类覆写
		}
		
		/**
		 * 开始加载
		 */
		private function start():void
		{
			
			trace("GameEngine start!");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if (null == loadingContainer)
			loadingContainer = stage;
			
			multiLoader = new MultiLoader();
			
			map_callBack = new Object();
			
			GlobalEventDispatcher.addEventListener(AppEvent.LOADING_SET, loadingSetHandler);
			GlobalEventDispatcher.addEventListener(AppEvent.LOADING_VISIBLE_SET, loadingVisibleSetHandler);
			GlobalEventDispatcher.addEventListener(AppEvent.RESOURCE_REQUEST, requestResHandler);
			
			beforeStart();
			
			nextStep();
			
		}
		
		/**
		 * 执行下一步
		 */
		private function nextStep(param:*= null):void
		{
			if (list_steps.length == 0)
			{
				
				loading.dispose();
				
				trace("步骤执行完成！  开始主程序");
				
				addEventListener(Event.ENTER_FRAME, doInit);
				
				function doInit(evt:Event):void
				{
					removeEventListener(Event.ENTER_FRAME, doInit);
					init();
				}
				
			}
			else
			{
				var step:Function = list_steps.shift();
				step();
			}
		}
		
		
		//================步骤=================
		/**
		 * 执行主程序的初始化
		 */
		protected function init():void
		{
			///被子类覆写
		}
		
		/**
		 * 加载configXML
		 */
		private function loadConfig():void
		{
			
			url_config = FileInfo.getFileInfo("config.xml").loadPath;
			
			multiLoader.addEventListener(Event.COMPLETE, configLoadCompleteHandler);
			multiLoader.append(url_config, url_config, 0, getFileDecoder(FileType.XML));
			multiLoader.start();
			
		}
		
		/**
		 * config加载完成
		 */
		private function configLoadCompleteHandler(evt:Event):void
		{
			
			config = multiLoader.getLoadedData(url_config);
			
			if (ExternalInterface.available)
			{
				try
				{
					buildVersion = ExternalInterface.call("getBuildVersion");
				}
				catch(err:Error)
				{
					
				}
			}
			
			Application.startUp(stage, config, buildVersion);
			
			multiLoader.removeEventListener(Event.COMPLETE, configLoadCompleteHandler);
			multiLoader.clear();
			
			onApplicationInit();
			
			nextStep();
			
		}
		
		/**
		 * 注册加载回调函数
		 */
		private function registerLoadCallBack():void
		{
			registerResLoadCallBack();
			multiLoader.addEventListener(AssetLoaderEvent.COMPLETE, resLoadCompleteHandler);
			multiLoader.addEventListener(AssetLoaderEvent.FAIL, resLoadFailHandler);
			nextStep();
		}
		
		/**
		 * 注册加载回调函数
		 */
		protected function registerResLoadCallBack():void
		{
			///被子类覆写
		}
		
		/**
		 * 注册资源加载完成回调
		 * @param	id				资源id
		 * @param	callBack		回调函数
		 */
		protected function addResourceLoadCallBack(id:String, callBack:Function):void
		{
			if (map_callBack[id] == null)
			{
				map_callBack[id] = [];
			}
			
			var arr_fun:Array = map_callBack[id];
			arr_fun.push(callBack);
		}
		
		/**
		 * 单个资源加载完毕时执行相应的回调函数
		 * @param	evt
		 */
		private function resLoadCompleteHandler(evt:AssetLoaderEvent):void
		{
			
			var loader:AssetLoader = evt.loader;
			
			var data:* = loader.data;
			
			addAsset(data, loader.id);
			
			switch(loader.fileType)
			{
				
				case FileType.SOUND:
					SoundManager.registerSound(loader.data, loader.id);
					break;
					
				case FileType.TABLE:
					KTable.addTable(loader.id, loader.data);
					break;
					
				case FileType.LANG:
					I18NTextManager.addLang(loader.data, loader.id);
					break;
				
			}
			
			var i:int = 0;
			var c:int;
			
			var arr_callBack:Array = map_callBack[loader.id];
			if (arr_callBack != null)
			{
				
				
				c = arr_callBack.length;
				
				while (i < c)
				{
					
					arr_callBack[i](data);
					
					i++;
					
				}
			}
			
			checkRequestComplete();
			
		}
		
		private function resLoadFailHandler(evt:AssetLoaderEvent):void
		{
			
			throw new Error("资源加载失败\r\n" + evt.loader.id + "\r\n" + evt.loader.url);
			
		}
		
		private var requestList:Vector.<ResourceRequest> = new Vector.<ResourceRequest>();
		
		private function requestResHandler(evt:AppEvent):void
		{
			
			loadResource(evt.data as ResourceRequest);
			
		}
		
		private function loadingSetHandler(evt:AppEvent):void
		{
			
			var v:Boolean = loadingVisible;
			loadingVisible = false;
			
			loading = evt.data as ILoading;
			loadingVisible = v;
			
		}
		
		private function loadingVisibleSetHandler(evt:AppEvent):void
		{
			
			loadingVisible = evt.data;
			
		}
		
		/**
		 * 加载初次资源和数据
		 */
		private function loadFirstResources():void
		{
			
			var resourceList:Vector.<ResourceInfo> = Application.configuration.resourceConfig.resourceList;
			var i:int = 0;
			var c:int = resourceList.length;
			
			var resourceIdList:Array = [];
			
			while (i < c) 
			{
				
				var resourceInfo:ResourceInfo = resourceList[i];
				
				if (false == resourceInfo.lazyLoading)
				{
					resourceIdList.push(resourceInfo.id);
				}
				
				i++;
				
			}
			
			var request:ResourceRequest = new ResourceRequest();
			request.configIdList = resourceIdList;
			request.completeHandler = firstResourcesReady;
			//request.removeLoadingOnComplete = false;
			
			loadResource(request);
			
		}
		
		private function firstResourcesReady(request:ResourceRequest):void
		{
			nextStep();
		}
		
		private var curRequest:ResourceRequest;
		
		private function loadResource(resRequest:ResourceRequest):void
		{
			
			var i:int = 0;
			var c:int = resRequest.configIdList.length;
			
			var list_load:Array = [];
			
			while (i < c) 
			{
				
				if (!AssetManager.hasAsset(resRequest.configIdList[i]))
				{
					
					list_load.push(Application.configuration.resourceConfig.getResourceInfoById(resRequest.configIdList[i]));
					
				}
				
				i++;
				
			}
			
			i = 0;
			c = resRequest.dynamicList.length;
			
			while (i < c) 
			{
				
				var resInfo:ResourceInfo = resRequest.dynamicList[i] as ResourceInfo;
				if (null == resInfo)
				{
					resInfo = new ResourceInfo(null, resRequest.dynamicList[i]);
				}
				
				resRequest.dynamicList[i] = resInfo.id;
				
				if (!AssetManager.hasAsset(resInfo.id))
				{
					list_load.push(resInfo);
				}
				
				i++;
				
			}
			
			//如果请求的资源全都已经加载过了，则直接派发完成事件
			if (list_load.length == 0)
			{
				completeRequest(resRequest);
				return;
			}
			
			curRequest = resRequest;
			
			//如果当前是后台加载模式，则清除后台加载的等待队列，保留已经开始加载的进程
			//(因为取消加载再重新加载的话会从头开始重新下载，造成浪费)
			if (isInBackStageLoad)
			{
				//如果指定取消当前后台加载进程
				if (resRequest.cancelCurrentBackProcess)
				{
					multiLoader.clear();
					this.requestList.splice(0, uint.MAX_VALUE);
				}
				else
				{
					multiLoader.clearWaitingQueue();
				}
			}
			
			this.requestList.push(resRequest);
			
			if (isInBackStageLoad)
			{
				//后台加载模式设置进程数为1
				multiLoader.maxProcess = 1;
				multiLoader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			}
			else
			{
				
				multiLoader.maxProcess = MultiLoader.defaultMaxProcess;
				multiLoader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				
			}
			
			checkLoadingShow();
			
			if (!multiLoader.isLoading) multiLoader.clear();
			
			list_load.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
			
			i = 0;
			c = list_load.length;
			
			while (i < c) 
			{
				
				var resourceInfo:ResourceInfo = list_load[i];
				
				var decoder:FileDecoder = getFileDecoder(resourceInfo.type);
				if (decoder is MediaDecoder)
				{
					
					var swfDecoder:MediaDecoder = decoder as MediaDecoder;
					var domainId:String = resourceInfo.customData as String;
					
					if (null == domainId || "" == domainId)
					{
						swfDecoder.domain = ApplicationDomain.currentDomain;
					}
					else
					{
						swfDecoder.domain = ClassManager.getClassDomain(domainId);
					}
				}
				
				var fileInfo:FileInfo = FileInfo.getFileInfo(resourceInfo.url);
				
				multiLoader.append(StringTool.joinURL(Application.rootPath, fileInfo.loadPath), resourceInfo.id, fileInfo.bytesTotal, decoder, resourceInfo.type);
				
				i++;
				
			}
			
			multiLoader.addEventListener(Event.COMPLETE, multiLoaderCompleteHandler);
			
			if (!isInBackStageLoad)
			{
				onResourceRequest();
				updateLoadingProgress(multiLoader.bytesLoaded, multiLoader.bytesTotal);
			}
			
			multiLoader.start();
			
		}
		
		private function multiLoaderCompleteHandler(evt:Event):void
		{
			
			multiLoader.removeEventListener(Event.COMPLETE, multiLoaderCompleteHandler);
			doResLoadComplete();
			
			onResourceReady();
			
		}
		
		protected function get isInBackStageLoad():Boolean
		{
			
			for each(var request:ResourceRequest in requestList)
			{
				if (request.mode != ResourceRequest.MODE_BACKSTAGE)
				return false;
			}
			
			return true;
			
		}
		
		protected function doBackStageLoad():void
		{
			
			if (multiLoader.isLoading) return;
			
			//如果资源加载失败，后台加载机制会不断的重复尝试加载
			var resourceList:Vector.<ResourceInfo> = Application.configuration.resourceConfig.resourceList;
			var i:int = 0;
			var c:int = resourceList.length;
			
			var resourceIdList:Array = [];
			
			while (i < c) 
			{
				
				var resourceInfo:ResourceInfo = resourceList[i];
				
				if (true == resourceInfo.lazyLoading && !AssetManager.hasAsset(resourceInfo.id))
				{
					resourceIdList.push(resourceInfo.id);
				}
				
				i++;
				
			}
			
			if (resourceIdList.length == 0) return;
			
			var request:ResourceRequest = new ResourceRequest();
			request.configIdList = resourceIdList;
			request.mode = ResourceRequest.MODE_BACKSTAGE;
			
			loadResource(request);
			
		}
		
		protected function cancelBackStageLoad():void
		{
			
			if (isInBackStageLoad)
			{
				multiLoader.clear();
			}
			
		}
		
		private function checkLoadingShow():void
		{
			
			loadingVisible = !isInBackStageLoad;
			
		}
		
		protected function set loadingVisible(value:Boolean):void
		{
			
			if (value)
			{
				if (null != loading.content) loadingContainer.addChild(loading.content);
			}
			else
			{
				if (loading.content != null && loading.content.parent != null) loading.content.parent.removeChild(loading.content);
			}
			
		}
		
		protected function get loadingVisible():Boolean
		{
			
			return (null != loading.content && null != loading.content.stage);
			
		}
		
		private function doResLoadComplete():void
		{
			
			if (curRequest.removeLoadingOnComplete)
			loadingVisible = false;
			
			checkRequestComplete();
			
			doBackStageLoad();
			
		}
		
		private function completeRequest(request:ResourceRequest):void
		{
			
			requestList.splice(requestList.indexOf(request), 1);
			
			checkLoadingShow();
			
			if (request.completeHandler != null) request.completeHandler.call(null, request);
			
			if (request.mode != ResourceRequest.MODE_BACKSTAGE)
			GlobalEventDispatcher.dispatchEvent(new AppEvent(AppEvent.RESOURCE_READY, request));
			
		}
		
		private function checkRequestComplete():void
		{
			
			var requestList:Vector.<ResourceRequest> = this.requestList.concat();
			//this.requestList.splice(0, uint.MAX_VALUE);
			
			for each(var request:ResourceRequest in requestList)
			{
				
				var resReady:Boolean = true;
				var resId:String;
				
				for each(resId in request.configIdList)
				{
					if (!AssetManager.hasAsset(resId)) 
					{
						resReady = false;
						break;
					}
				}
				
				if (resReady)
				{
					for each(resId in request.dynamicList)
					{
						
						if (!AssetManager.hasAsset(resId)) 
						{
							resReady = false;
							break;
						}
					}
				}
				
				if (resReady)
				{
					
					completeRequest(request);
					
				}
				
			}
			
		}
		
		private function loadProgressHandler(evt:ProgressEvent):void
		{
			
			updateLoadingProgress(evt.bytesLoaded, evt.bytesTotal);
			
		}
		
		protected function updateLoadingProgress(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void
		{
			
			loading.setProgress(bytesLoaded, bytesTotal, customData);
			
		}
		
		/**
		 * 设置加载进程数
		 * @param	process		进程数
		 */
		protected function setLoadProcess(process:int):void
		{
			multiLoader.maxProcess = process;
		}
		
		protected function addAsset(asset:*, id:String):void
		{
			
			AssetManager.addAsset(asset, id);
			
		}
		
		protected function getAsset(id:String):*
		{
			return AssetManager.getAsset(id);
		}
		
	}

}