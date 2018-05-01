package L_FlipPage
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import L_FlipPage.L_FlipPage;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class test_L_FlipPage extends Sprite 
	{
		var fl_book:L_FlipPage;
		public function test_L_FlipPage():void
		{
			init();
		}
		function init():void
		{			
			//stage.scaleMode = StageScaleMode.NO_BORDER;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			
			fl_book = new L_FlipPage(700,500);
			
			fl_book.x = 0;
			fl_book.y = 150;
			
			fl_book.page_back_seconds = 0.25;
			fl_book.page_drag_back_seconds = 0.25;
			//fl_book.page_roll_over_seconds = 0.15;
			//fl_book.page_roll_back_seconds = 0.075;
			
			fl_book.add_page(new page_start());			
			fl_book.add_page(new page_3());
			fl_book.add_page(new page_4());
			fl_book.add_page(new page_5());
			fl_book.add_page(new page_6());
			fl_book.add_page(new page_7());
			fl_book.add_page(new page_8());
			fl_book.add_page(new page_9());
			fl_book.add_page(new page_10());
			fl_book.add_page(new page_11());
			
			
			fl_book.add_page(new page_3());
			fl_book.add_page(new page_4());
			fl_book.add_page(new page_5());
			fl_book.add_page(new page_6());
			fl_book.add_page(new page_7());
			fl_book.add_page(new page_8());
			fl_book.add_page(new page_9());
			fl_book.add_page(new page_10());
			fl_book.add_page(new page_11());
			fl_book.add_page(new page_end());
			
			addChild(fl_book);
		}
	}
	
}