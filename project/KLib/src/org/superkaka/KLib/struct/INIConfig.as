package org.superkaka.KLib.struct 
{
	import org.superkaka.KLib.utils.ObjectUtil;
	/**
	 * ini 配置文件对象，提供访问和修改数据的接口
	 * @author		ｋａｋａ
	 * @Email			superkaka.org@gmail.com
	 * @date			2013/11/29/星期五 10:20
	 */
	public class INIConfig 
	{
		
		private var data:Object = { };
		
		public function INIConfig():void 
		{
			
			
		}
		
		public function createSection(sectionName:String):void
		{
			data[sectionName] = { };
		}
		
		public function getSection(sectionName:String):Object
		{
			if (null == data[sectionName])
			return null;
			return ObjectUtil.copyObject(data[sectionName]);
		}
		
		public function getSectionNameList():Array
		{
			var list:Array = [];
			for (var sectionName:String in data)
			{
				list.push(sectionName);
			}
			return list;
		}
		
		public function setValue(sectionName:String, key:String, value:String):void
		{
			var section:Object = tryGetSection(sectionName);
			section[key] = value;
		}
		
		public function getValue(sectionName:String, key:String):String
		{
			var section:Object = tryGetSection(sectionName);
			return section[key];
		}
		
		private function tryGetSection(sectionName:String):Object
		{
			if (null == data[sectionName])
			throw new Error("section does not exist:" + sectionName);
			
			return data[sectionName];
		}
		
	}

}