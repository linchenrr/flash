package org.superkaka.KLib.utils 
{
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * 克隆工具
	 * @author ｋａｋａ
	 */
	public class Cloner
	{
		
		/**
		 * 深度复制		懂得自然懂
		 * @param	obj
		 * @return
		 */
		static public function deepClone(obj:*):*
		{
			
			var clsName:String = getQualifiedClassName(obj);
			registerClassAlias(clsName, getDefinitionByName(clsName) as Class);
			
			var ba:ByteArray = new ByteArray();
			
			ba.writeObject(obj);
			ba.position = 0;
			
			return ba.readObject();
			
		}
		
		//static public function cloneDisplayObject(displayObj:DisplayObject):DisplayObject
		//{
			//getDefinitionByName
			//var constructor:Object = DisplayObject.prototype.constructor;
			//
			//var obj:Object = clone(displayObj);
			//
			//var newDisplayObj:DisplayObject = new constructor();
			//
			//for (var key:String in obj)
			//{
				//
				//newDisplayObj[key] = obj[key];
				//
			//}
			//
			//return newDisplayObj;
			//
		//}
		
		static public function cloneObject(obj:Object):Object
		{
			
			var newObj:Object = { };
			
			for (var key:String in obj)
			{
				
				newObj[key] = obj[key];
				
			}
			
			return newObj;
			
		}
		
		static public function cloneArray(arr:Array):Array
		{
			
			return arr.concat();
			
		}
		
		static public function cloneByteArray(ba:ByteArray):ByteArray
		{
			
			var newBa:ByteArray = new ByteArray();
			newBa.endian = ba.endian;
			newBa.writeBytes(ba);
			newBa.position = 0;
			
			return newBa;
			
		}
		
	}

}