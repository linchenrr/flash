package L_FlipPage
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_SinglePage extends Sprite 
	{
		//页面
		private var _page:Sprite;
		//存放页面映像的容器
		private var _container:Sprite;
		//页面映像、以及映像数据
		private var _page_bitmap:Bitmap;
		private var _page_bitmapdata:BitmapData;
		
		//指示是否以映像模式显示
		public var _cacheAsPhoto:Boolean;
		//页标签，方便快速查找
		public var page_name:String;
		
		var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		public function L_FlipPage_SinglePage(p_name:String = null, c_a_p:Boolean = true):void
		{
			init(p_name, c_a_p);
		}
		function init(p_name:String, c_a_p:Boolean):void
		{
			_page = new Sprite();
			_container = new Sprite();
			_cacheAsPhoto = c_a_p;
			page_name = p_name;
			
			addChild(_container);			
		}
		
		public function set cacheAsPhoto(c_a_p:Boolean):void
		{
			_cacheAsPhoto = c_a_p;
			if (c_a_p)
			{				
				refresh_page();
			}
			else
			{
				remove_page_display();
				_page_bitmapdata = null;
				_page_bitmap = null;
				_container.addChild(_page);
			}
		}
		
		//添加元件，传入显示对象以及它在页面里的x、y坐标，并给它起名方便控制。
		public function add_Component_By_XY(mc:DisplayObject, mx:int = 0, my:int = 0, mc_name:String = "Baby"):void
		{			
			var _mc:Sprite = reset_Components(mc);
			
			_mc.name = mc_name;
			_mc.x = mx;
			_mc.y = my;
			_page.addChild(_mc);
		}		
		
		//重设过大的元件
		function reset_Components(s:DisplayObject):Sprite
		{
			var w:uint = values.page_width;
			var h:uint = values.page_height;	
			
			var bitmapdata:BitmapData = new BitmapData(s.width, s.height)
			bitmapdata.draw(s);			
			
			var bitmap:Bitmap = new Bitmap(bitmapdata);
			bitmap.smoothing = true;			
			
			if (bitmap.width > w)
			{
				bitmap.height *= w / bitmap.width;
				bitmap.width = w;
			}
			if (bitmap.height > h)
			{
				bitmap.width *= h / bitmap.height;
				bitmap.height = h;
			}	
			
			s = null;
			
			var mc:Sprite = new Sprite();
			mc.addChild(bitmap);
			
			return mc;
		}
		
		
		//根据标识名删除子显示对象，有并且删除了返回真，否则返回假
		public function remove_Component_By_Name(mc_name:String):Boolean
		{
			var mc:DisplayObject = _page.getChildByName(mc_name);
			if (mc == null)
			{
				return false;
			}
			else
			{
				_page.removeChild(mc);
				return true;
			}
		}
		
		//判断是否有这个名字的子显示对象
		public function has_child(mc_name:String):Boolean
		{
			var mc:DisplayObject = _page.getChildByName(mc_name);
			if (mc == null)
			{
				return false;
			}
			else
			{				
				return true;
			}
		}
		
		//给页面照张相，这样翻页时可以减少很多计算
		public function take_a_Photo():void
		{
			cacheAsPhoto = true;
		}
		
		//清空页面内容的显示（未删除实际内容）
		public function remove_page_display():void
		{
			while (_container.numChildren > 0)
			{
				_container.removeChildAt(0);
			}
		}
		
		//实际清除页面内的显示对象(可以删除但不刷新页面显示，这样可以节省不必要的资源占用)
		public function remove_allpage_childs():void
		{
			while (_page.numChildren > 0)
			{
				_page.removeChildAt(0);
			}
		}
		
		//刷新页面的显示(在页面为映像模式时使用，刷新映像)
		public function refresh_page():void
		{
			if (_cacheAsPhoto)
			{
				remove_page_display();
				_page_bitmapdata = new BitmapData(_page.width, _page.height);
				_page_bitmapdata.draw(_page);			
				_page_bitmap = new Bitmap(_page_bitmapdata);
				_page_bitmap.smoothing = true;
				_container.addChild(_page_bitmap);
			}
		}
	}
	
}