package ui 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.superkaka.kakalib.view.ui.components.BaseCellRender;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestCellRender extends BaseCellRender
	{
		private var txt:TextField;
		public function TestCellRender() 
		{
			txt = new TextField();
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(txt);
		}
		
		override protected function render():void
		{
			
			txt.text = _cellData.cellIndex + "." + String(_data);
			
		}
		
		override protected function onSelectChange():void
		{
			
			///子类覆写，渲染选中状态
			txt.alpha = _selected? 1:0.3;
			
		}
		
	}

}