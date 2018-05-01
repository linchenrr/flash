package org.superkaka.KLib.display.ui 
{
	import flash.events.MouseEvent;
	import org.superkaka.KLib.manager.PopUpManager;
	import org.superkaka.KLib.display.ui.components.Button;
	/**
	 * UI弹窗基类
	 * @author ｋａｋａ
	 */
	public class BasePopPanel extends BasePanel implements IPopPanel
	{
		
		public var btn_close:Button;
		
		public function BasePopPanel():void
		{
			
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			contentWidth = _panelMC.width;
			contentHeight = _panelMC.height;
			
			if (null != btn_close)
			btn_close.addEventListener(MouseEvent.CLICK, btn_closeClickHandler);
			
		}
		
		public function close():void
		{
			
			PopUpManager.closePanel(this);
			
		}
		
		protected  function btn_closeClickHandler(evt:MouseEvent):void
		{
			
			close();
			
		}
		
	}

}