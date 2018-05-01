package ui 
{
	import org.superkaka.kakalib.view.ui.components.NumberUpDown;
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
			
			txt_number.text = "页数: " + String(_number) + "/" + String(_max);
			
		}
		
	}

}