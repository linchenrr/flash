package L_FlipPage
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import L_FlipPage.L_FlipPage_btn;
	import L_FlipPage.L_Event;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_BtnManager extends Sprite 
	{
		private var _is_btns_hide:Boolean;
		
		private var btn_1:L_FlipPage_btn, btn_2:L_FlipPage_btn, btn_3:L_FlipPage_btn, btn_4:L_FlipPage_btn;
		private var btn_5:L_FlipPage_btn, btn_6:L_FlipPage_btn, btn_7:L_FlipPage_btn, btn_8:L_FlipPage_btn;
		
		var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		public function L_FlipPage_BtnManager():void
		{
			init();
		}
		function init():void
		{
			btn_1 = new L_FlipPage_btn(1);
			btn_2 = new L_FlipPage_btn(2);
			btn_3 = new L_FlipPage_btn(3);
			btn_4 = new L_FlipPage_btn(4);
			
			btn_1.is_left = true;
			btn_2.is_left = false;
			btn_3.is_left = true;
			btn_4.is_left = false;
			
			btn_1.is_up = true;
			btn_2.is_up = true;
			btn_3.is_up = false;
			btn_4.is_up = false;			
			
			btn_1.addEventListener(MouseEvent.MOUSE_DOWN, mouse_press);
			btn_2.addEventListener(MouseEvent.MOUSE_DOWN, mouse_press);
			btn_3.addEventListener(MouseEvent.MOUSE_DOWN, mouse_press);
			btn_4.addEventListener(MouseEvent.MOUSE_DOWN, mouse_press);
			
			addChild(btn_1);
			addChild(btn_2);
			addChild(btn_3);
			addChild(btn_4);			
			
			btn_5 = new L_FlipPage_btn(5);
			btn_6 = new L_FlipPage_btn(6);
			btn_7 = new L_FlipPage_btn(7);
			btn_8 = new L_FlipPage_btn(8);
			
			btn_5.is_left = true;
			btn_6.is_left = false;
			btn_7.is_left = true;
			btn_8.is_left = false;
			
			btn_5.is_up = true;
			btn_6.is_up = true;
			btn_7.is_up = false;
			btn_8.is_up = false;			
			
			btn_5.addEventListener(MouseEvent.MOUSE_DOWN, mouse_inside_press);
			btn_6.addEventListener(MouseEvent.MOUSE_DOWN, mouse_inside_press);
			btn_7.addEventListener(MouseEvent.MOUSE_DOWN, mouse_inside_press);
			btn_8.addEventListener(MouseEvent.MOUSE_DOWN, mouse_inside_press);
			
			addChild(btn_5);
			addChild(btn_6);
			addChild(btn_7);
			addChild(btn_8);
			//////////////////////////////////////////////////////////
			
			_is_btns_hide = false;
			
			values.addEventListener(L_Event.WIDTH_CHANGED, set_buttons_x);
			values.addEventListener(L_Event.HEIGHT_CHANGED, set_buttons_y);
		}
		
		function mouse_press(evt:MouseEvent):void
		{
			var tar:Object = evt.target;
			var l_event:L_Event = new L_Event(L_Event.MOUSE_PRESS);
			l_event.args.is_left = tar.is_left;
			l_event.args.is_up = tar.is_up;	
			l_event.args.position = tar.position;
			dispatchEvent(l_event);
		}
		
		function mouse_inside_press(evt:MouseEvent):void
		{
			var tar:Object = evt.target;
			var l_event:L_Event = new L_Event(L_Event.MOUSE_INSIDE_PRESS);
			l_event.args.is_left = tar.is_left;
			l_event.args.is_up = tar.is_up;	
			l_event.args.position = tar.position;
			dispatchEvent(l_event);
		}
		
		function set_buttons_x(evt:L_Event):void
		{			
			
			btn_1.width = btn_2.width = btn_3.width = btn_4.width = values.page_width / 10;
			
			btn_5.width = btn_6.width = btn_7.width = btn_8.width = values.page_width / 4;
			
			
			btn_1.x = 0;
			btn_2.x = values.page_width - btn_2.width;
			btn_3.x = 0;
			btn_4.x = values.page_width - btn_4.width;	
			
			var dis_w:Number = values.page_width / 5;			
			
			btn_5.x = dis_w;
			btn_6.x = values.page_width - btn_6.width - dis_w;
			btn_7.x = dis_w;
			btn_8.x = values.page_width - btn_8.width - dis_w;
		}
		
		function set_buttons_y(evt:L_Event):void
		{		
			btn_1.height = btn_2.height = btn_3.height = btn_4.height = values.page_height / 5;
			btn_5.height = btn_6.height = btn_7.height = btn_8.height = values.page_height / 4;
			
			btn_1.y = 0;
			btn_2.y = 0;
			btn_3.y = values.page_height - btn_3.height;
			btn_4.y = values.page_height - btn_4.height;
			
			var dis_h:Number = values.page_height / 8;
			
			btn_5.y = dis_h;
			btn_6.y = dis_h;
			btn_7.y = values.page_height - btn_7.height - dis_h;
			btn_8.y = values.page_height - btn_8.height - dis_h;
		}
		
		public function hide_btns(side:String):void
		{			
			if (side == "left")			
			{
				btn_1.visible = btn_3.visible = btn_5.visible = btn_7.visible = false;
			}
			else if (side == "right")			
			{
				btn_2.visible = btn_4.visible = btn_6.visible = btn_8.visible = false;
			}
			
			_is_btns_hide = true;
		}
		
		public function show_all_btns():void
		{
			if (_is_btns_hide)
			{
				btn_1.visible = btn_3.visible = btn_2.visible = btn_4.visible = btn_5.visible = btn_6.visible = btn_7.visible = btn_8.visible = true;
				_is_btns_hide = false;
			}
		}
		
		public function start_listen_mouse_over():void		
		{
			btn_1.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_2.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_3.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_4.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
		}
		
		function mouse_over(evt:MouseEvent):void
		{
			var tar:Object = evt.target;
			var l_event:L_Event = new L_Event(L_Event.MOUSE_ROLL_OVER);
			l_event.args.is_left = tar.is_left;
			l_event.args.is_up = tar.is_up;	
			l_event.args.position = tar.position;
			dispatchEvent(l_event);
		}
		
		public function stop_listen_mouse_over():void
		{
			btn_1.removeEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_2.removeEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_3.removeEventListener(MouseEvent.ROLL_OVER, mouse_over);
			btn_4.removeEventListener(MouseEvent.ROLL_OVER, mouse_over);
		}
		
		public function start_listen_mouse_out():void		
		{
			btn_1.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_2.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_3.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_4.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
		}
		
		function mouse_out(evt:MouseEvent):void
		{
			var l_event:L_Event = new L_Event(L_Event.MOUSE_ROLL_OUT);
			dispatchEvent(l_event);
		}
		
		public function stop_listen_mouse_out():void		
		{
			btn_1.removeEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_2.removeEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_3.removeEventListener(MouseEvent.ROLL_OUT, mouse_out);
			btn_4.removeEventListener(MouseEvent.ROLL_OUT, mouse_out);
		}
	}
	
}