package org.superkaka.KLib.core 
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	/**
	 * 游戏引擎接口
	 * @author ｋａｋａ
	 */
	public interface IEngine extends IEventDispatcher
	{
		
		/**
		 * 设置loading资源
		 * @param	loading
		 */
		function setLoadingAsset(loading:MovieClip):void;
		
		/**
		 * 设置build主版本号
		 * @param	ver
		 */
		//function setBuildVersion(ver:String):void;
		
	}
	
}