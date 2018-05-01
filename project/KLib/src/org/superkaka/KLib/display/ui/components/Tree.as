package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import org.superkaka.KLib.display.ui.components.*;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	
	/**
	 * 树组件
	 * @author		ｋａｋａ
	 * @Email			superkaka.org@gmail.com
	 * @date			2013/10/10/星期四 13:53
	 */
	public class Tree extends List 
	{
		
		static public const OPEN:String = "open";
		
		/**               组件定义                  */
		public var btn_title:ToggleButton;
		public var txt_label:TextField;
		public var itemContainer:MovieClip;
		
		/**               变量定义                  */
		
		public function Tree():void 
		{
			
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			///绑定完成，执行相关初始化操作
			if (itemContainer == null)
			itemContainer = new MovieClip();
			itemContainer.addChild(container);
			
			btn_title.addEventListener(UIComponentEvent.CHANGE, updateView);
			
			updateView();
			
		}
		
		public function set label(value:String):void
		{
			txt_label.text = value;
		}
		
		public function get label():String
		{
			return txt_label.text;
		}
		
		private function updateView(evt:*= null):void
		{
			
			if (btn_title.selected)
			{
				movieClip.addChild(itemContainer);
				dispatchEvent(new Event(OPEN));
			}
			else
			{
				if(movieClip.contains(itemContainer))
				movieClip.removeChild(itemContainer);
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function open():void
		{
			btn_title.selected = true;
		}
		
		public function close():void
		{
			btn_title.selected = false;
		}
		
	}

}