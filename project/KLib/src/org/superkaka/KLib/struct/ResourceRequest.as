package org.superkaka.KLib.struct 
{
	/**
	 * 表示资源请求信息
	 * @author ｋａｋａ
	 */
	public class ResourceRequest 
	{
		
		static public const MODE_BACKSTAGE:String = "backstage";
		static public const MODE_NORMAL:String = "normal";
		
		public var id:String;
		public var configIdList:Array = [];
		public var dynamicList:Array = [];
		
		public var mode:String;
		public var cancelCurrentBackProcess:Boolean;
		public var removeLoadingOnComplete:Boolean = true;
		
		public var customData:Object;
		
		public var completeHandler:Function;
		public var failHandler:Function;
		
		public function ResourceRequest(id:String = null, configIdList:Array = null, dynamicList:Array = null, customData:Object = null, mode:String = MODE_NORMAL):void
		{
			
			this.id = id;
			
			if (configIdList != null)
			this.configIdList = configIdList;
			
			if (dynamicList != null)
			this.dynamicList = dynamicList;
			
			this.customData = customData;
			this.mode = mode;
			
		}
		
	}

}