package org.superkaka.KLib.utils 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class ClassUtil
	{
		/**
		 * 将指定的swf文件中包含的类定义读取到指定的程序域中
		 * @param	bytes
		 * @param	appDomain
		 * @param	callBack				读取完成后的回调
		 */
		static public function loadClassFromBytes(bytes:ByteArray, appDomain:ApplicationDomain, callBack:Function = null):void
		{
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadClassFromBytesCompleteHandler);
			
			dic_callBack[loader] = callBack;
			
			loader.loadBytes(bytes, new LoaderContext(false, appDomain));
			
		}
		
		static private var dic_callBack:Dictionary = new Dictionary();
		static private function loadClassFromBytesCompleteHandler(evt:Event):void
		{
			
			var loader:Loader = (evt.currentTarget as LoaderInfo).loader;
			loader.unloadAndStop();
			
			var callBack:Function = dic_callBack[loader];
			dic_callBack[loader] = null;
			delete dic_callBack[loader];
			
			if (callBack != null) callBack.apply();
			
		}
		
	}

}