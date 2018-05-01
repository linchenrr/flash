package org.superkaka.KLib.core 
{
	import org.superkaka.KLib.struct.ResourceInfo;
	import org.superkaka.KLib.struct.UIResourceInfo;
	import org.superkaka.KLib.utils.ObjectUtil;
	
	/**
	 * 表示适用于此应用程序或资源的配置文件
	 * @author ｋａｋａ
	 */
	public class Configuration
	{
		
		public var resourceConfig:ResourceConfig;
		
		private var config:XML;
		
		private var _frameRate:int;
		private var _version:String;
		
		private const _appParameters:Object = { };
		private const _customSettings:Object = { };
		public const dic_sceneInfo:Object = { };
		public const dic_popPanelInfo:Object = { };
		
		public function Configuration(config:XML, rootPath:String = ""):void
		{
			
			this.config = config;
			
			_frameRate = int(config.appSettings[0].add.(@key == "frameRate").@value);
			_version = String(config.appSettings[0].add.(@key == "version").@value);
			
			var xmlList:XMLList = config.customSettings[0].add;
			
			var xml_add:XML;
			
			for each(xml_add in xmlList)
			{
				
				_customSettings[String(xml_add.@key)] = String(xml_add.@value);
				
			}
			
			xmlList = config.appParameters[0].add;
			
			for each(xml_add in xmlList)
			{
				
				_appParameters[String(xml_add.@key)] = String(xml_add.@value);
				
			}
			
			var dic_UIResInfo:Object;
			
			if (config.hasOwnProperty("scene"))
			{
				dic_UIResInfo = parseUIResourceInfo(config.scene[0]);
				ObjectUtil.copyTo(dic_UIResInfo, dic_sceneInfo);
			}
			
			
			if (config.hasOwnProperty("popPanel"))
			{
				dic_UIResInfo = parseUIResourceInfo(config.popPanel[0]);
				ObjectUtil.copyTo(dic_UIResInfo, dic_popPanelInfo);
			}
			
			
			setResourceRootPath(rootPath);
			
		}
		
		private function parseUIResourceInfo(xml:XML):Object
		{
			
			var xmlList:XMLList = xml.add;
			
			var dic_info:Object = { };
			
			for each(var xml_add:XML in xmlList)
			{
				
				var sceneInfo:UIResourceInfo = new UIResourceInfo();
				sceneInfo.id = String(xml_add.@id);
				sceneInfo.className= String(xml_add.@className);
				sceneInfo.link = String(xml_add.@link);
				
				var resourceList:Array;
				if (null == xml_add.@resourceId)
				{
					resourceList = [];
				}
				else
				{
					var str_resourceList:String = String(xml_add.@resourceId);
					if ("" == str_resourceList) 
					{
						resourceList = [];
					}
					else
					{
						resourceList = str_resourceList.split(",");
					}
				}
				
				sceneInfo.resourceList = resourceList;
				sceneInfo.isDefault = String(xml_add.attribute("default")) == "true";
				dic_info[sceneInfo.id] = sceneInfo;
				
			}
			
			return dic_info;
			
		}
		
		public function setResourceRootPath(rootPath:String):void
		{
			
			if (null == rootPath) return;
			
			resourceConfig = new ResourceConfig(config.resourceConfig[0], rootPath);
			
		}
		
		public function get frameRate():int 
		{
			return _frameRate;
		}
		
		
		public function get version():String 
		{
			return _version;
		}
		
		public function get customSettings():Object 
		{
			return _customSettings;
		}
		
		public function get appParameters():Object 
		{
			return _appParameters;
		}
		
	}

}
import org.superkaka.KLib.struct.FileInfo;
import org.superkaka.KLib.utils.StringTool;
import org.superkaka.KLib.struct.ResourceInfo;
class ResourceConfig
{
	
	/**
	 * 加载的起始根路径
	 */
	private var _rootPath:String;
	
	/**
	 * 资源定义的根路径
	 */
	private var _assetPath:String;
	
	/**
	 * 资源列表
	 */
	public var resourceList:Vector.<ResourceInfo>;
	
	public function ResourceConfig(xml_resource:XML, appRootPath:String = ""):void
	{
		
		this._rootPath = appRootPath;
		
		var assetDir:String = "";
		if (xml_resource.hasOwnProperty("@dir")) assetDir = xml_resource.@dir;
		
		_assetPath = StringTool.joinURL(_rootPath, assetDir);
		
		var xmlList_resources:XMLList = xml_resource.resources;
		
		var i:int = 0;
		var c:int = xmlList_resources.length();
		
		resourceList = new Vector.<ResourceInfo>;
		
		while (i < c) 
		{
			
			var xmlList_add:XMLList = xmlList_resources[i].add;
			var subRootPath:String = StringTool.joinURL(assetDir, String(xmlList_resources[i].@dir));
			
			var j:int = 0;
			var c_j:int = xmlList_add.length();
			
			while (j < c_j) 
			{
				
				var xml_resourceItem:XML = xmlList_add[j];
				
				var str_subPath:String = StringTool.joinURL(subRootPath, String(xml_resourceItem.@src));
				
				resourceList.push(
				new ResourceInfo(
				String(xml_resourceItem.@id),
				str_subPath,
				String(xml_resourceItem.@customData),
				String(xml_resourceItem.@type),
				xml_resourceItem.@lazyLoading == "true",
				int(xml_resourceItem.@priority)
				));
				
				j++;
				
			}
			
			i++;
			
		}
		
	}
	
	/**
	 * 资源加载的根路径
	 */
	public function get rootPath():String 
	{
		return _rootPath;
	}
	
	public function get assetPath():String 
	{
		return _assetPath;
	}
	
	public function getResourceInfoById(id:String):ResourceInfo
	{
		
		for each(var resInfo:ResourceInfo in resourceList)
		{
			if (resInfo.id == id)
			{
				return resInfo;
			}
		}
		
		throw new Error("不存在的资源配置id:" + id);
		
		return null;
		
	}
	
}