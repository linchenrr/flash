package ui 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import org.superkaka.kakalib.core.Application;
	import org.superkaka.kakalib.struct.CellData;
	import org.superkaka.kakalib.view.ui.BasePanel;
	import org.superkaka.kakalib.view.ui.components.Grid;
	import org.superkaka.kakalib.view.ui.components.LabelButton;
	import org.superkaka.kakalib.view.ui.components.List;
	import org.superkaka.kakalib.view.ui.components.MovieClipComponent;
	import org.superkaka.kakalib.view.ui.components.TextBox;
	import org.superkaka.kakalib.view.ui.events.UIComponentEvent;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestUI2 extends BasePanel
	{
		
		public var txt_name:TextBox
		
		public var mc_t:MovieClipComponent;
		
		public var textButton:LabelButton;
		
		public var grid:FilpGrid;
		
		public var list:List;
		
		public var sp:Sprite
		
		public function TestUI2() 
		{
			
		}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			var so:SharedObject = SharedObject.getLocal("test");
			
			txt_name.text = String(so.data["a"]);
			
			txt_name.buttonMode = true;
			txt_name.mouseChildren = false;
			
			so.data["a"] += 1;
			
			//MonsterDebugger.initialize(this);
            //MonsterDebugger.trace(this, "Hello TestUI2!");
			
			textButton.label = "2233eeerrr";
			
			textButton.addEventListener(MouseEvent.CLICK, textButtonClickHandler);
			
			stage.addEventListener(MouseEvent.CLICK, stageCl);
			
		}
		
		override protected function active():void
		{
			
			list.setCellRender(new TestCellRender);
			list.count = 5;
			list.spacing = 20;
			
			grid.setCellRender(TestCellRender);
			grid.row = 3;
			grid.column = 5;
			grid.rowSpacing = 20;
			grid.columnSpacing = 40;
			
			var list_data:Array = [];
			for (var i:int = 0; i < 61; i++)
			{
				list_data[i] = i;
			}
			grid.listData = list_data;
			list.listData = list_data;
			//grid.gotoPage(4);
			
			updatePage();
			
			grid.addEventListener(UIComponentEvent.CHANGE, gridSelectChangeHandler);
			list.addEventListener(UIComponentEvent.CHANGE, gridSelectChangeHandler);
			
		}
		
		private function textButtonClickHandler(evt:MouseEvent):void
		{
			textButton.enabled = true;
			//grid.row += 1;
			grid.column += 1;
			//grid.nextPage();
			grid.gotoPage(grid.curPage);
			list.nextPage();
			
			updatePage();
			
		}
		
		private function updatePage():void
		{
			
			txt_name.text = list.curPage + "/" + list.maxPage;
			
		}
		
		private function gridSelectChangeHandler(evt:UIComponentEvent):void
		{
			
			trace((evt.data as CellData).data);
			
		}
		
		private function stageCl(evt:MouseEvent):void
		{
			
			if (textButton.isDisplay)
			{
				textButton.parent.removeChild(textButton);
			}
			else
			{
				addChild(textButton);
			}
			
		}
		
	}

}