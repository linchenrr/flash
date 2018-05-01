package L_FlipPage
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_PageShower extends Sprite 
	{
		var _page_left_container:Sprite;
		var _page_right_container:Sprite;	
		
		var _page_fliping_container:Sprite;
		var _page_new_container:Sprite;
		
		var _page_left:Sprite;
		var _page_right:Sprite;
		
		var _page_fliping:Sprite;
		var _page_new:Sprite;
		
		var _container:Sprite;
		
		private var _left:Boolean;
		
		var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		public function L_FlipPage_PageShower():void
		{
			init();
		}
		function init():void
		{
			_left = true;
			_container = new Sprite();
			_page_left_container = new Sprite();
			_page_right_container = new Sprite();
			_page_fliping_container = new Sprite();
			_page_new_container = new Sprite();
			_container.addChild(_page_left_container);
			_container.addChild(_page_right_container);
			addChild(_container);
			addChild(_page_new_container);
			addChild(_page_fliping_container);		
			
			values.addEventListener(L_Event.WIDTH_CHANGED, page_width_changed);
			//values.addEventListener(L_Event.HEIGHT_CHANGED, page_height_changed);
		}
		
		public function set left_page(page_left:Sprite):void
		{
			_page_left = page_left;
			while (_page_left_container.numChildren > 0)
			{
				_page_left_container.removeChildAt(0);
			}
			
			if (_page_left != null)
			{				
				
				_page_left_container.addChild(_page_left);		
			}		
		}
		
		public function set right_page(page_right:Sprite):void
		{
			_page_right = page_right;
			while (_page_right_container.numChildren > 0)
			{
				_page_right_container.removeChildAt(0);
			}

			if (_page_right != null)
			{				
				_page_right_container.addChild(_page_right);								
			}			
		}
		
		public function set flip_page(page:Sprite):void
		{
			_page_fliping = page;
			
			while (_page_fliping_container.numChildren > 0)
			{
				_page_fliping_container.removeChildAt(0);
			}
			if (_page_fliping != null)
			{				
				_page_fliping_container.addChild(_page_fliping);
			}
		}
		
		public function set new_page(page:Sprite):void
		{
			_page_new = page;
			
			while (_page_new_container.numChildren > 0)
			{
				_page_new_container.removeChildAt(0);
			}
			if (_page_new != null)
			{				
				_page_new_container.addChild(_page_new);
			}
		}
		
		public function set flip_page_mask(_mask:Sprite):void
		{
			_page_fliping_container.mask = _mask;
		}
		
		public function set new_page_mask(_mask:Sprite):void
		{
			_page_new_container.mask = _mask;
		}
		
		public function set page_mask(_mask:Sprite):void
		{
			_container.mask = _mask;
		}
		
		public function flip_page_show(o:Object):void
		{
			_page_fliping_container.x = o.x;
			_page_fliping_container.y = o.y;
			_page_fliping_container.rotation = o.rotation;
		}
		
		
		public function flip_to_side():void
		{
			if (_left)
			{
				new_page = flip_page = left_page = null;
				right_page = _page_fliping;
			}
			else
			{
				new_page = flip_page = right_page = null;
				left_page = _page_fliping;
			}			
		}
		
		public function start_drag(page_left:Sprite, page_right:Sprite, left:Boolean):void
		{
			_left = left;
			if (left)
			{
				flip_page = _page_left;
				new_page = _page_right;				
				_page_new_container.x = values.page_width / 2;
			}
			else
			{
				flip_page = _page_right;
				new_page = _page_left;
				_page_new_container.x = 0;
			}
			left_page = page_left;
			right_page = page_right;
		}
		
		public function start_filp(page_fliping:Sprite, page_new:Sprite, left:Boolean):void
		{
			_left = left;
			
			flip_page = page_fliping;
			new_page = page_new;
			if (left)
			{
				_page_new_container.x = 0;
			}
			else
			{
				_page_new_container.x = values.page_width / 2;
			}
		}
		
		public function end_filp(_is_flipover:Boolean = true):void
		{
			while (_page_fliping_container.numChildren > 0)
			{
				_page_fliping_container.removeChildAt(0);
			}
			while (_page_new_container.numChildren > 0)
			{
				_page_new_container.removeChildAt(0);
			}
				
			if (_is_flipover)
			{
				while (_page_left_container.numChildren > 0)
				{
					_page_left_container.removeChildAt(0);
				}
				while (_page_right_container.numChildren > 0)
				{
					_page_right_container.removeChildAt(0);
				}
				
				if (_left)
				{
					left_page = _page_new;
					right_page = _page_fliping;					
				}
				else
				{
					left_page = _page_fliping;
					right_page = _page_new;
				}		
			}
		}
		
		public function end_drag(_is_flipover:Boolean = true):void
		{
			while (_page_fliping_container.numChildren > 0)
			{
				_page_fliping_container.removeChildAt(0);
			}
			while (_page_new_container.numChildren > 0)
			{
				_page_new_container.removeChildAt(0);
			}
				
			if (!_is_flipover)
			{
				while (_page_left_container.numChildren > 0)
				{
					_page_left_container.removeChildAt(0);
				}
				while (_page_right_container.numChildren > 0)
				{
					_page_right_container.removeChildAt(0);
				}
				
				if (_left)
				{
					left_page = _page_fliping;
					right_page = _page_new;
								
				}
				else
				{
					left_page = _page_new;
					right_page = _page_fliping;
				}		
			}
		}
		
		function page_width_changed(evt:L_Event):void
		{
			_page_right_container.x = values.page_width / 2;
		}
		
		function page_height_changed(evt:L_Event):void
		{
			
		}
	}
	
}