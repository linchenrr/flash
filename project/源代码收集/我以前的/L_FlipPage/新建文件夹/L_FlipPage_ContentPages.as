package L_FlipPage
{
	import flash.display.Sprite;
	import L_FlipPage.L_FlipPage_SinglePage;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_ContentPages extends Sprite 
	{
		private var arr_page:Array;
		public function L_FlipPage_ContentPages():void
		{
			init();
		}
		
		function init():void
		{
			arr_page = new Array();
		}
		
		//返回指定页（按索引）
		public function get_SinglePageAt(index:uint):L_FlipPage_SinglePage
		{
			if (index < arr_page.length)
			{
				return arr_page[index];
			}
			else
			{
				return null;
			}
		}
		
		//返回指定页（按页标签）
		public function get_SinglePageByName(page_name:String):L_FlipPage_SinglePage
		{
			var tmp_page:L_FlipPage_SinglePage = null;
			var c:uint = arr_page.length;
			for (var i:uint = 0; i < c; i++)
			{
				if (arr_page[i].page_name == page_name)
				{
					tmp_page = arr_page[i];
					break;
				}
			}
			return tmp_page;
		}
		
		//返回总页数
		public function get page_count():uint
		{
			return arr_page.length;
		}
		
		//添加一页到最后
		public function add_SinglePage(sp:L_FlipPage_SinglePage):void
		{
			arr_page.push(sp);
		}
		
		//添加一页到最前
		public function add_SinglePageAtFirst(sp:L_FlipPage_SinglePage):void
		{
			arr_page.unshift(sp);
		}
		
		//添加一页到指定页数
		public function add_SinglePageAt(sp:L_FlipPage_SinglePage, index:uint):void
		{
			arr_page.splice(index, 0, sp);			
		}
		
		//删除指定页
		public function remove_SinglePageAt(index:uint):L_FlipPage_SinglePage
		{
			return arr_page.splice(index, 1)[0] as L_FlipPage_SinglePage;
		}
		
		//删除尾页
		public function remove_SinglePageAtLast():L_FlipPage_SinglePage
		{
			return arr_page.pop();
		}
		
		//删除首页
		public function remove_SinglePageAtFirst():L_FlipPage_SinglePage
		{
			return arr_page.shift();
		}
		
		//反转所有页数
		public function reverse_pages():void
		{
			arr_page.reverse();
		}
	}
	
}