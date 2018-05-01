package org.superkaka.KLib.struct 
{
	import org.superkaka.KLib.net.FileType;
	/**
	 * 资源信息
	 * @author ｋａｋａ
	 */
	public class ResourceInfo
	{
		
		/**
		 * 指示该资源的id
		 */
		public var id:String;
		
		/**
		 * 指示该资源的加载地址
		 */
		public var url:String;
		
		/**
		 * 指示该资源的类型，类型详情参见KFileType类
		 */
		public var type:String;
		
		/**
		 * 指示该资源的特定属性(如swf文件用于存储domainId)
		 */
		public var customData:Object;
		
		/**
		 * 指示该资源是否为延迟加载
		 */
		public var lazyLoading:Boolean;
		
		/**
		 * 指示该资源加载的优先级
		 */
		public var priority:int;
		
		public function ResourceInfo(id:String = null, url:String = null, customData:Object = null, type:String = null, lazyLoading:Boolean = false, priority:int = 0):void
		{
			
			this.id = id;
			this.url = url;
			this.customData = customData;
			this.lazyLoading = lazyLoading;
			this.priority = priority;
			
			if (this.id == null || this.id == "") 
			{
				var arr:Array = url.split(/[\\|\/]/);
				var fName:String = arr.pop();
				
				///去除后缀名
				var idx:int = fName.lastIndexOf(".");
				if (idx != -1)
				{
					fName = fName.substring(0, fName.lastIndexOf("."));
				}
				
				this.id = fName;
				
			}
			
			if (type == null)
			{
				//根据扩展名判断文件类型
				this.type = FileType.getType(this.url);
			}
			else
			{
				type = FileType.getType(type);
			}
			
			this.type = type;
			
		}
		
	}

}