package org.superkaka.KLib.display.ui 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import org.superkaka.KLib.display.ui.components.Button;
	/**
	 * 用于被继承的UI基类，作用是在下一级真正的基类中帮助识别子类是否覆写了相关方法
	 * @author ｋａｋａ
	 */
    internal class BaseUIForExtend extends Sprite
	{
		
		public function BaseUIForExtend():void
		{
			
		}
		
		protected function onButtonClick(button:Button):void
		{
			
			///被子类覆写
			
		}
		
		//protected function onClick(target:InteractiveObject):void
		//{
			//
			///被子类覆写
			//
		//}
		//
		//protected function onRollOver(target:InteractiveObject):void
		//{
			//
			///被子类覆写
			//
		//}
		//
		//protected function onRollOut(target:InteractiveObject):void
		//{
			//
			///被子类覆写
			//
		//}
		//
		//protected function onMouseDown(target:InteractiveObject):void
		//{
			//
			///被子类覆写
			//
		//}
		//
		//protected function onMouseUp(target:InteractiveObject):void
		//{
			//
			///被子类覆写
			//
		//}
		
	}

}