package org.superkaka.KLib.display.ui 
{
	import flash.display.DisplayObject;
	
	/**
	 * UI接口
	 * @author ｋａｋａ
	 */
	public interface IUI
	{
		
		/**
		 * 获取或设置与此UI关联的数据
		 * 此数据通常用于渲染
		 */
		function get data():Object;
		
		function set data(value:Object):void;
		
		/**
		 * 获取界面用于排布的参考宽度
		 */
		function get contentWidth():Number;
		
		/**
		 * 获取界面用于排布的参考高度
		 */
		function get contentHeight():Number;
		
		/**
		 * 获取此对象是否处于显示列表中并显示
		 */
		function get isDisplay():Boolean;
		
		/**
		 * 执行资源绑定
		 * @param	resource		绑定到的资源，如果传入的是一个字符串，则会以此为链接名获取资源执行绑定
		 */
		function bind(resource:*):void;
	}
	
}