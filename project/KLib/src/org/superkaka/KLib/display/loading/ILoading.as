package org.superkaka.KLib.display.loading 
{
	import flash.display.MovieClip;
	
	/**
	 * loading接口
	 * @author ｋａｋａ
	 */
	public interface ILoading 
	{
		
		function get content():MovieClip;
		
		function set content(mc:MovieClip):void;
		
		function setProgress(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void;
		
		function dispose():void;
		
	}
	
}