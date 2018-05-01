package org.superkaka.KLib.display.ui.components 
{
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class PageUpDown extends NumberUpDown
	{
		
		public function PageUpDown() 
		{
			
			
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			min = 1;
			
		}
		
		override protected function renderNumber():void
		{
			
			//txt_number.text = "页数: " + String(_number) + "/" + String(_max);
			txt_number.text = String(_number) + "/" + String(_max);
			
		}
		
		public function get showPage():Boolean 
		{
			return txt_number.visible;
		}
		
		public function set showPage(value:Boolean):void 
		{
			txt_number.visible = value;
		}
		
		override public function set max(value:Number):void 
		{
			
			if (value < 1) value = 1;
			super.max = value;
			
		}
		
		override public function set min(value:Number):void 
		{
			
			if (value < 1) value = 1;
			super.min = value;
			
		}
		
	}

}