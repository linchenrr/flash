package org.superkaka.KLib.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 实现激活和休眠机制的接口
	 * @author ｋａｋａ
	 */
	public interface IActiveSleep extends IEventDispatcher
	{
		
		function active():void;
		
		function sleep():void;
		
	}
	
}