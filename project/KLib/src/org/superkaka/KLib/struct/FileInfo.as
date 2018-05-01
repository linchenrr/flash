package org.superkaka.KLib.struct 
{
	/**
	 * 文件版本、大小等信息
	 * @author ｋａｋａ
	 */
	public class FileInfo
	{
		
		private var _path:String;
		private var _realPath:String;
		private var _name:String;
		private var _version:String;
		private var _bytesTotal:uint;
		
		public function FileInfo(path:String, realPath:String, version:String, bytesTotal:uint):void
		{
			
			this._path = path;
			this._realPath = realPath;
			this._version = version;
			this._bytesTotal = bytesTotal;
			
			var index:int=_path.lastIndexOf("\/");
			if (index != -1)
			{
				_name = path.substring(index + 1);
			}
			else
			{
				_name = path;
			}
			
		}
		
		public function get path():String 
		{
			return _path;
		}
		
		public function get loadPath():String
		{
			//return _path + "?v=" + _version;
			return _realPath;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get version():String 
		{
			return _version;
		}
		
		public function get bytesTotal():uint 
		{
			return _bytesTotal;
		}
		
		
		//============静态=============
		static private const dic_info:Object = { };
		
		static public function fillData(str:String):void
		{
			
			if (null == str || "" == str) return;
			
			var list_fileInfo:Array = str.split("\r\n");
			
			for each(var fileInfo:String in list_fileInfo)
			{
				
				var info:Array = fileInfo.split(",");
				addFileInfo(info[0], info[1], info[2], info[3]);
				
			}
			
		}
		
		static public function addFileInfo(path:String, realPath:String, version:String, bytesTotal:uint):void
		{
			
			dic_info[path] = new FileInfo(path, realPath, version, bytesTotal);
			
		}
		
		static public function getFileInfo(path:String):FileInfo
		{
			
			var fileInfo:FileInfo = dic_info[path];
			
			if (null == fileInfo)
			{
				fileInfo = new FileInfo(path, path, "unknow", 0);
			}
			
			return fileInfo;
			
		}
		
		
	}

}