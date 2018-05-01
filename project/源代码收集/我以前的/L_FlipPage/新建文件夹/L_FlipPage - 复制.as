package L_FlipPage
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage extends Sprite
	{		
		var _mask_flipingPage:L_FlipPage_mask;
		var _mask_newPage:L_FlipPage_mask;
		var _mask_page:L_FlipPage_mask;
		
		//全局变量
		var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		//内容页集合管理者
		private var _page_manager:L_FlipPage_PageManager;	
		
		//所有的点都靠它来管理和计算
		private var _point_manager:L_FlipPage_PointManager;
		
		//显示控制类
		private var _page_shower:L_FlipPage_PageShower;
		
		//按钮集合
		private var _btn_manager:L_FlipPage_BtnManager;
		
		public function L_FlipPage(w:uint=700,h:uint=500):void
		{
			init(w,h);
		}
		private function init(w:uint=700,h:uint=500):void
		{			
			_page_manager = new L_FlipPage_PageManager();
			
			_point_manager = new L_FlipPage_PointManager();
			
			_page_shower = new L_FlipPage_PageShower();
			
			_btn_manager = new L_FlipPage_BtnManager();			
			
			_mask_flipingPage = new L_FlipPage_mask();
			_mask_newPage = new L_FlipPage_mask();
			_mask_page=new L_FlipPage_mask();

			addChild(_mask_flipingPage);
			addChild(_mask_newPage);
			addChild(_mask_page);
			addChild(_page_shower);			
			
			_page_shower.flip_page_mask = _mask_flipingPage;
			_page_shower.new_page_mask = _mask_newPage;
			_page_shower.page_mask = _mask_page;

			add_btns();						
			
			_page_manager.addEventListener(L_Event.REACH_SIDE, flip_reach_side);
			
			_page_manager.addEventListener(L_Event.REACH_SIDE, hide_buttons);
			_page_manager.addEventListener(L_Event.BUTTONS_RESRT, reset_buttons);			
			
			page_width = w;
			page_height = h;	
			
			draw_self(this);			
			draw_self(_mask_page);		
			
			start_listen_mouse_over();
			
			addEventListener(Event.ADDED_TO_STAGE, first_init);
		}
		
		function first_init(evt:Event):void
		{
			reset_pages();
			removeEventListener(Event.ADDED_TO_STAGE, first_init);
		}

		function reset_pages():void
		{
			_page_manager.reset_pages();
			_page_shower.left_page = _page_manager.page_new;
			_page_shower.right_page = _page_manager.page_fliping;
			_page_shower.flip_page = null;
			_page_shower.new_page = null;
			_btn_manager.hide_btns("left");
		}
		
		private function draw_self(sp:Sprite):void
		{
			var w:uint = values.page_width;
			var h:uint = values.page_height;
			var gr:Graphics = sp.graphics;
			gr.lineStyle(1, 0x000000);
			gr.beginFill(0x000000, 0);
			gr.moveTo(0, 0);
			gr.lineTo(w, 0);
			gr.lineTo(w, h);
			gr.lineTo(0, h);
			gr.lineTo(0, 0);
			gr.endFill();
		}
		function add_btns():void
		{			
			addChild(_btn_manager);
			
			start_listen_mouse_press();
		}
		
		function hide_buttons(evt:L_Event):void
		{
			_btn_manager.hide_btns(evt.args.side);
		}
		
		function reset_buttons(evt:L_Event):void
		{
			_btn_manager.show_all_btns();
		}
		
		function show_moving(evt:L_Event):void
		{
			mask_draw();
			_page_shower.flip_page_show(_point_manager.fliping_page_position);
		}
		function start_flip_page(evt:L_Event):void
		{
			values.is_flip = true;
			
			var e_args:Object = evt.args;
			
			stop_listen_mouse_press();	
			
			stop_listen_mouse_over();
			stop_listen_mouse_out();
			
			start_listen_points_ready(e_args.position);			
			
			start_listen_mouse_up();
			start_listen_mouse_move();
			
			start_listen_pages_ready();
			
			_page_manager.flip_page_try(e_args.is_left);			
		}
		
		function start_drag_page(evt:L_Event):void
		{
			values.is_flip = false;
			
			var e_args:Object = evt.args;
			
			stop_listen_mouse_press();	
			
			stop_listen_mouse_over();
			stop_listen_mouse_out();
			
			start_listen_points_ready(e_args.position - 4);			
			
			start_listen_mouse_up();
			
			start_listen_pages_ready();
			
			_page_manager.drag_page_try(e_args.is_left);			
			
			_point_manager.start_drag_page(mouseX, mouseY, e_args.position);			
			
			start_listen_drag_back();
		}
		
		function pages_ready(evt:L_Event):void
		{
			var evt_a:Object = evt.args;
			if (values.is_flip)
			{
				_page_shower.start_filp(evt_a.page_fliping, evt_a.page_new, evt_a.is_left);
			}
			else
			{
				_page_shower.start_drag(evt_a.page_left, evt_a.page_right, evt_a.is_left);				
			}						
			stop_listen_pages_ready();
		}
		
		function points_move(evt:MouseEvent):void
		{
			_point_manager.ask_points(mouseX, mouseY);
		}
		
		function ask_points(evt:Event):void
		{
			//moving();
		}		
		
		function flip_back(evt:L_Event):void
		{
			mask_clear();
			draw_self(_mask_page);
			
			stop_listen_points_back();
			stop_listen_points_ready();			
			
			if (values.is_flip)
			{
				_page_shower.end_filp(evt.args.flip_over);
			}
			else
			{
				_page_shower.end_drag(evt.args.flip_over);
			}

			if (evt.args.flip_over)
			{
				_page_manager.flip_page();
			}
			
			start_listen_mouse_press();
			start_listen_mouse_over();
		}
		
		function drag_back(evt:L_Event):void
		{
			_point_manager.removeEventListener(L_Event.DRAG_BACK, drag_back);			
			
			stop_listen_drag_back();			
			
			start_listen_mouse_move();			
		}
		
		function change_drag_end(evt:MouseEvent):void
		{
			_point_manager.change_drag_end(mouseX, mouseY);
		}
		
		function mouse_roll_over(evt:L_Event):void
		{
			_point_manager.point_type = evt.args.position;
			if (!hasEventListener(Event.ENTER_FRAME))
			{
				addEventListener(Event.ENTER_FRAME, ask_points);
			}
			stop_listen_mouse_over();
			start_listen_mouse_out();
		}
		
		function mouse_roll_out(evt:L_Event):void
		{
			if (hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, ask_points);
			}
			stop_listen_mouse_out();
			start_listen_mouse_over();
			
			start_listen_points_back();	
			_point_manager.drop_page(mouseX, mouseY);	
		}
		
		function flip_reach_side(evt:L_Event):void
		{
			_btn_manager.hide_btns(evt.args.side);
		}

		function release(evt:MouseEvent):void
		{
			stop_listen_mouse_move();
			stop_listen_mouse_up();
			stop_listen_drag_back();
			
			start_listen_points_back();	
			_point_manager.drop_page(mouseX, mouseY);		
		}
		
		function mask_clear():void
		{
			_mask_flipingPage.mask_clear();
			_mask_newPage.mask_clear();
			_mask_page.mask_clear();
		}
		
		function mask_draw():void
		{
			_mask_flipingPage.mask_draw(_point_manager.mask_flipingPage_points);
			_mask_newPage.mask_draw(_point_manager.mask_newPage_points);
			_mask_page.mask_draw(_point_manager.mask_page_points);
		}		
		
		function start_listen_pages_ready():void
		{
			if (!_page_manager.hasEventListener(L_Event.PAGES_READY))
			{
				_page_manager.addEventListener(L_Event.PAGES_READY, pages_ready);
			}			
		}
		
		function stop_listen_pages_ready():void
		{
			if (_page_manager.hasEventListener(L_Event.PAGES_READY))
			{
				_page_manager.removeEventListener(L_Event.PAGES_READY, pages_ready);
			}			
		}
		
		function start_listen_points_ready(position:uint):void
		{
			if (!_point_manager.hasEventListener(L_Event.POINTS_READY))
			{
				_point_manager.point_type = position;
				_point_manager.addEventListener(L_Event.POINTS_READY, show_moving);		
			}
		}
		
		function stop_listen_points_ready():void
		{
			if (_point_manager.hasEventListener(L_Event.POINTS_READY))
			{
				_point_manager.removeEventListener(L_Event.POINTS_READY, show_moving);		
			}
		}
		
		function start_listen_drag_back():void
		{
			if (!_point_manager.hasEventListener(L_Event.DRAG_BACK))
			{
				_point_manager.addEventListener(L_Event.DRAG_BACK, drag_back);				
			}
			if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))			
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, change_drag_end)
			}
		}
		
		function stop_listen_drag_back():void
		{
			if (_point_manager.hasEventListener(L_Event.DRAG_BACK))
			{
				_point_manager.removeEventListener(L_Event.DRAG_BACK, drag_back);				
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))			
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, change_drag_end)
			}
		}		
		
		function start_listen_points_back():void
		{
			if (!_point_manager.hasEventListener(L_Event.POINTS_BACK))
			{				
				_point_manager.addEventListener(L_Event.POINTS_BACK, flip_back);
			}
		}
		
		function stop_listen_points_back():void
		{
			if (_point_manager.hasEventListener(L_Event.POINTS_BACK))
			{				
				_point_manager.removeEventListener(L_Event.POINTS_BACK, flip_back);
			}
		}
		
		function start_listen_mouse_press():void
		{
			if (!_btn_manager.hasEventListener(L_Event.MOUSE_PRESS))
			{
				_btn_manager.addEventListener(L_Event.MOUSE_PRESS, start_flip_page);
			}		
			if (!_btn_manager.hasEventListener(L_Event.MOUSE_INSIDE_PRESS))
			{
				_btn_manager.addEventListener(L_Event.MOUSE_INSIDE_PRESS, start_drag_page);
			}
		}
		
		function stop_listen_mouse_press():void
		{
			if (_btn_manager.hasEventListener(L_Event.MOUSE_PRESS))
			{
				_btn_manager.removeEventListener(L_Event.MOUSE_PRESS, start_flip_page);
			}	
			if (_btn_manager.hasEventListener(L_Event.MOUSE_INSIDE_PRESS))
			{
				_btn_manager.removeEventListener(L_Event.MOUSE_INSIDE_PRESS, start_drag_page);
			}
		}
		
		function start_listen_mouse_up():void
		{
			if (!stage.hasEventListener(MouseEvent.MOUSE_UP))
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, release);
			}
		}
		
		function stop_listen_mouse_up():void
		{
			if (stage.hasEventListener(MouseEvent.MOUSE_UP))
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, release);
			}
		}
		
		function start_listen_mouse_over():void
		{
			if (!_btn_manager.hasEventListener(L_Event.MOUSE_ROLL_OVER))
			{
				_btn_manager.addEventListener(L_Event.MOUSE_ROLL_OVER, mouse_roll_over);
				_btn_manager.start_listen_mouse_over();
			}
		}
		
		function stop_listen_mouse_over():void
		{
			if (_btn_manager.hasEventListener(L_Event.MOUSE_ROLL_OVER))
			{
				_btn_manager.removeEventListener(L_Event.MOUSE_ROLL_OVER, mouse_roll_over);
				_btn_manager.stop_listen_mouse_over();
			}
		}
		
		function start_listen_mouse_out():void
		{
			if (!_btn_manager.hasEventListener(L_Event.MOUSE_ROLL_OUT))
			{
				_btn_manager.addEventListener(L_Event.MOUSE_ROLL_OUT, mouse_roll_out);
				_btn_manager.start_listen_mouse_out();
			}
		}
		
		function stop_listen_mouse_out():void
		{
			if (_btn_manager.hasEventListener(L_Event.MOUSE_ROLL_OUT))
			{
				_btn_manager.removeEventListener(L_Event.MOUSE_ROLL_OUT, mouse_roll_out);
				_btn_manager.stop_listen_mouse_out();
			}
		}
		
		function start_listen_mouse_move():void
		{
			if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, points_move);
			}			
		}
		
		function stop_listen_mouse_move():void
		{
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, points_move);				
			}			
		}
		
		public function add_page(mc:Sprite):void
		{
			_page_manager.add_page(mc);
		}
		
		
		public function set page_width(w:uint):void
		{
			values.page_width = w;
		}
		public function set page_height(h:uint):void
		{
			values.page_height = h;
		}
		public function get page_width():uint
		{
			return values.page_width;
		}
		public function get page_height():uint
		{
			return values.page_height;
		}
		public function set page_back_seconds(value:Number):void
		{
			_point_manager.page_back_seconds = value;
		}
		
		public function set page_drag_back_seconds(value:Number):void
		{
			_point_manager.page_drag_back_seconds = value;
		}
	}
}