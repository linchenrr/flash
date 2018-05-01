package org.superkaka.KLib.core 
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import org.superkaka.KLib.common.keyboard.KeyControl;
	import org.superkaka.KLib.manager.*;
	import org.superkaka.KLib.utils.ObjectUtil;
	import org.superkaka.KLib.display.ui.BaseUI;
	/**
	 * 程序信息类
	 * 为模块和各个管理类提供需要访问的程序公共信息
	 * @author ｋａｋａ
	 */
	public class Application
	{
		
		static private var _config:Configuration;
		
		static private var _pageParameters:Object = { };
		
		static private var _stage:Stage;
		
		/**
		 * 程序运行的起始路径
		 */
		static private var _startUpPath:String;
		
		/**
		 * 是否为本地程序
		 */
		static private var _isLocal:Boolean;
		
		/**
		 * 程序运行时使用的根路径
		 */
		static private var _rootPath:String;
		
		static private var _version:String;
		
		static private var _debugMode:Boolean;
		
		static private var customSettings:Object;
		
		static public function startUp(stage:Stage, config:XML, version:String = ""):void
		{
			
			_stage = stage;
			_version = version;
			
			///根据swf本身的地址获取基础目录
			_startUpPath = unescape(_stage.loaderInfo.url).replace(/\\/g, "/").replace(/[^\/]+$/g, "");
			
			_isLocal = (new LocalConnection()).domain == "localhost";
			
			_config = new Configuration(config);
			_stage.frameRate = _config.frameRate;
			
			initFlashVars();
			
			_rootPath = _pageParameters["root"];
			
			_debugMode = String(_pageParameters["debugMode"]).toLowerCase() == "true";
			
			if (null == _rootPath) _rootPath = _startUpPath;
			
			_config.setResourceRootPath(_rootPath);
			
			initManagers();
			
		}
		
		static private function initFlashVars():void
		{
			
			_pageParameters = _config.appParameters;
			
			if (ExternalInterface.available)
			{
				
				var params:Object = ExternalInterface.call("getFlashVars");
				
				if (null == params)
				{
					params = stage.loaderInfo.parameters;
				}
				
				for (var key:String in params)
				{
					_pageParameters[key] = params[key];
				}
				
			}
			
		}
		
		static private function initManagers():void
		{
			
			BaseUI.registerStage(_stage);
			
			DragManager.init(_stage);
			EnterFrameManager.init(_stage);
			GameLockManager.init(_stage);
			GameQualityManager.init(_stage);
			PopUpManager.init(_stage);
			SystemManager.init(_stage);
			KeyControl.init(_stage);
			
			SceneManager.registerResourceInfo(_config.dic_sceneInfo);
			PopUpManager.registerResourceInfo(_config.dic_popPanelInfo);
			
		}
		
		/**
		 * 程序运行时使用的根路径
		 */
		static public function get rootPath():String 
		{
			return _rootPath;
		}
		
		static public function get stage():Stage 
		{
			return _stage;
		}
		
		static public function get stageWidth():int 
		{
			return _stage.stageWidth;
		}
		
		static public function get stageHeight():int 
		{
			return _stage.stageHeight;
		}
		
		static public function get configuration():Configuration 
		{
			return _config;
		}
		
		static public function get parameters():Object 
		{
			return _pageParameters;
		}
		
		/**
		 * 获取程序运行的起始路径
		 */
		static public function get startUpPath():String 
		{
			return _startUpPath;
		}
		
		/**
		 * 获取当前程序是否为本地运行
		 */
		static public function get isLocal():Boolean 
		{
			return _isLocal;
		}
		
		/**
		 * 获取程序的版本号
		 */
		static public function get version():String 
		{
			return _version;
		}
		
		static public function set debugMode(value:Boolean):void 
		{
			
			_debugMode = value;
			
		}
		
		static public function get debugMode():Boolean 
		{
			return _debugMode;
		}
		
	}

}