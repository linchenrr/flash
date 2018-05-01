package L_FlipPage
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import L_FlipPage.L_FlipPage_ContentPages;
	import L_FlipPage.L_FlipPage_SinglePage;
	import L_FlipPage.L_Event;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_PageManager extends Sprite 
	{		
		var _pages:L_FlipPage_ContentPages;
		//指示当前第几页
		var _page_index:uint;
		
		//尝试翻到的页数
		var tmp_index:int;
		
		//卷起页、新页
		private var _page_fliping:Sprite, _page_new:Sprite;
		
		public function L_FlipPage_PageManager():void
		{
			init();
		}
		function init():void
		{
			_pages = new L_FlipPage_ContentPages();
			_page_index = 0;			
		}
		
		//获得卷起页
		public function get page_fliping():Sprite
		{
			return _page_fliping;
		}
		
		//获得新页
		public function get page_new():Sprite
		{
			return _page_new;
		}
		
		
		//尝试翻页
		public function flip_page_try(left:Boolean):void
		{
			var l_event:L_Event;
			if (left)
			{
				if (_page_index > 0)
				{					 
					tmp_index = _page_index - 2;
					
					l_event = new L_Event(L_Event.PAGES_READY);
					l_event.args.page_fliping = _pages.get_SinglePageAt(tmp_index);
					l_event.args.page_new = _pages.get_SinglePageAt(tmp_index - 1);
					l_event.args.is_left = left;
					dispatchEvent(l_event);										
				}					
			}
			else
			{				
				if (_page_index < _pages.page_count - 1)
				{
					tmp_index = _page_index + 2;
					
					l_event = new L_Event(L_Event.PAGES_READY);
					l_event.args.page_fliping = _pages.get_SinglePageAt(tmp_index - 1);
					l_event.args.page_new = _pages.get_SinglePageAt(tmp_index);
					l_event.args.is_left = left;
					dispatchEvent(l_event);						
				}				
			}	
		}	
				
		
		//尝试拖页
		public function drag_page_try(left:Boolean):void
		{
			var l_event:L_Event;
			if (left)
			{
				if (_page_index > 0)
				{					 
					tmp_index = _page_index - 2;
					
					l_event = new L_Event(L_Event.PAGES_READY);
					l_event.args.page_right = _pages.get_SinglePageAt(tmp_index);
					l_event.args.page_left = _pages.get_SinglePageAt(tmp_index - 1);
					l_event.args.is_left = left;
					dispatchEvent(l_event);										
				}					
			}
			else
			{				
				if (_page_index < _pages.page_count - 1)
				{
					tmp_index = _page_index + 2;
					
					l_event = new L_Event(L_Event.PAGES_READY);
					l_event.args.page_right = _pages.get_SinglePageAt(tmp_index);
					l_event.args.page_left = _pages.get_SinglePageAt(tmp_index - 1);
					l_event.args.is_left = left;
					dispatchEvent(l_event);						
				}				
			}	
		}	
		
		//真正翻页
		public function flip_page():void
		{
			_page_index = tmp_index;
			
			var l_event_side:L_Event;
			
			if (_page_index <= 0)
			{
				l_event_side = new L_Event(L_Event.REACH_SIDE);
				l_event_side.args.side = "left";
				dispatchEvent(l_event_side);
			}
			
			else if (_page_index >= _pages.page_count - 1)
			{
				l_event_side = new L_Event(L_Event.REACH_SIDE);
				l_event_side.args.side = "right";
				dispatchEvent(l_event_side);
			}
			
			else
			{
				l_event_side = new L_Event(L_Event.BUTTONS_RESRT);
				dispatchEvent(l_event_side);
			}
		}
		
		//翻到指定页
		public function flip_to_page(index:uint):void
		{	
			var left:Boolean = false;
			if (index % 2 != 0)
			{
				index++;
				left = true;
			}
			if (index >= 0 && index <= _pages.page_count)
			{
				tmp_index = index;
				var l_event:L_Event;
				if (left)
				{						
						l_event = new L_Event(L_Event.PAGES_READY);
						l_event.args.page_fliping = _pages.get_SinglePageAt(tmp_index);
						l_event.args.page_new = _pages.get_SinglePageAt(tmp_index - 1);
						l_event.args.is_left = left;
						dispatchEvent(l_event);											
				}
				else
				{
						l_event = new L_Event(L_Event.PAGES_READY);
						l_event.args.page_fliping = _pages.get_SinglePageAt(tmp_index - 1);
						l_event.args.page_new = _pages.get_SinglePageAt(tmp_index);
						l_event.args.is_left = left;
						dispatchEvent(l_event);							
				}
			}
		}		
		
		public function reset_pages():void
		{
			tmp_index = _page_index = 0;
			_page_fliping = _pages.get_SinglePageAt(_page_index);
			_page_new = _pages.get_SinglePageAt(_page_index - 1);
		}
		
		//根据显示对象添加页
		public function add_page(mc:DisplayObject, cacheAsPhoto:Boolean = true, smoothing:Boolean = false, page_name:String = "Baby"):void
		{
			var page:L_FlipPage_SinglePage = new L_FlipPage_SinglePage(cacheAsPhoto, smoothing, page_name);
			page.add_Component_By_XY(mc);

			page.refresh_page();
						
			_pages.add_SinglePage(page);			
		}
		
		//添加SinglePage
		public function add_SinglePage(page:L_FlipPage_SinglePage):void
		{
			_pages.add_SinglePage(page);
		}
	}
	
}