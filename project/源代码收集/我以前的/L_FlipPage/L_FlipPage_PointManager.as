package L_FlipPage
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;	
	import fl.transitions.easing.*;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_PointManager extends EventDispatcher
	{
		public var _x:int, _y:int;
		private var ax:int, ay:int, bx:int, by:int, cx:int, cy:int, dx:int, dy:int, vx:int, vy:int, gx:int, gy:int, hx:int, hy:int, ex:int, ey:int, fx:int, fy:int, sd_x:int, sd_y:int;
		//卷起页的角度
		private var _vk:Number, _sk:Number; 
		
		//阴影角度、长度
		private var _sd_dis:Number, _sd_k:Number;
		
		private var _p_type:uint;
		
		//指示页是否翻过
		private var _flip_over:Boolean;
		
		var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		//Tween类
		var Tween_x:Tween, Tween_y:Tween;
		
		//Tween类持续时间
		private var _Tween_flip_duration:Number = 0.25;
		private var _Tween_drag_duration:Number = 0.25;
		private var _Tween_roll_over_duration:Number = 0.3;
		private var _Tween_roll_back_duration:Number = 0.15;
		
		public function L_FlipPage_PointManager():void
		{
			init();
		}
		function init():void
		{
			Tween_x = new Tween(this, "_x", Regular.easeOut, 0, 300, 0.5, true);
			Tween_y = new Tween(this, "_y", Regular.easeOut, 0, 300, 0.5, true);
			Tween_x.stop();
			Tween_y.stop();
		}
		
		public function ask_points(x:int, y:int):void
		{			
			var arr:Array = L_FlipPage_Math.get_points(x, y, _p_type);
			
			ax = arr[0].x;
			bx = arr[1].x;
			cx = arr[2].x;
			dx = arr[3].x;
			vx = arr[4].x;
			gx = arr[5].x;
			hx = arr[6].x;
			sd_x = arr[7].x;
			
			ay = arr[0].y;
			by = arr[1].y;
			cy = arr[2].y;
			dy = arr[3].y;
			vy = arr[4].y;
			gy = arr[5].y;
			hy = arr[6].y;	
			sd_y = arr[7].y;

			_vk = arr[4].vk;		
			
			_sd_k = arr[7].sd_k;			
					
			
			if (gx == 0)
			{
				fx = ex = gx + values.page_width;
			}
			else
			{				
				fx = ex = 0;
			}
			
			if (gy == 0)
			{
				fy = 0;
				ey = fy + values.page_height;
			}
			else
			{
				ey = 0;
				fy = ey + values.page_height;
			}
			
			_sd_dis = Math.sqrt((cx - ex) * (cx - ex) + (cy - ey) * (cy - ey));
			
			dispatchEvent(new L_Event(L_Event.POINTS_READY));
		}
		
		public function get mask_flipingPage_points():Object
		{
			var arr_x:Array = new Array(ax, bx, dx, cx);
			var arr_y:Array = new Array(ay, by, dy, cy);
			var o:Object = new Object();
			o.x = arr_x;
			o.y = arr_y;
			return o;
		}
		
		public function get mask_newPage_points():Object
		{			
			var arr_x:Array = new Array(bx, gx, hx, dx);
			var arr_y:Array = new Array(by, gy, hy, dy);
			var o:Object = new Object();
			o.x = arr_x;
			o.y = arr_y;
			return o;
		}
		
		public function get mask_shadow_points():Object
		{			
			var arr_x:Array = new Array(ax, bx, gx, hx, dx, cx);
			var arr_y:Array = new Array(ay, by, gy, hy, dy, cy);
			var o:Object = new Object();
			o.x = arr_x;
			o.y = arr_y;
			return o;
		}
		
		public function get mask_page_points():Object
		{			
			var arr_x:Array = new Array(fx, gx, bx, dx, hx, ex);
			var arr_y:Array = new Array(fy, gy, by, dy, hy, ey);
			var o:Object = new Object();
			o.x = arr_x;
			o.y = arr_y;
			return o;
		}
		
		public function get fliping_page_position():Object
		{
			var o:Object = new Object();
			o.x = vx;
			o.y = vy;
			o.rotation = _vk;
			return o;
		}
		
		public function get shadow_position():Object
		{
			var o:Object = new Object();
			o.x = sd_x;
			o.y = sd_y;
			o.rotation = _sd_k;
			o.sd_dis = _sd_dis;
			return o;
		}
		
		function show_back(evt:TweenEvent):void
		{//trace(Tween_x.position)
			ask_points(Tween_x.position, Tween_y.position);	
		}
		
		function get_back(evt:TweenEvent):void
		{			
			Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, get_back);
			
			var l_event:L_Event = new L_Event(L_Event.POINTS_BACK);
			l_event.args.flip_over = _flip_over;
			dispatchEvent(l_event);
		}		
		
		public function drop_page(x:int, y:int):void
		{			
			if (Tween_x.hasEventListener(TweenEvent.MOTION_FINISH))
			{
				Tween_x.stop();
				Tween_y.stop();
				Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, drag_back);
				Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
			}
			
			//var arr:Array = L_FlipPage_Math.get_points(x, y, _p_type);
			//_x = Tween_x.begin = arr[2].x;
			//_y = Tween_y.begin = arr[2].y;
			
			_x = Tween_x.begin = cx;
			_y = Tween_y.begin = cy;
			
			var o:Object = L_FlipPage_Math.get_finish_point(x, _p_type);
			
			Tween_x.finish = o.x;
			Tween_y.finish = o.y;
			
			_flip_over = o.flip_over;
			
			if (!values.is_flip)
			{
				_flip_over = !_flip_over;
			}
			
			//添加侦听
			Tween_x.addEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.addEventListener(TweenEvent.MOTION_FINISH, get_back);
			
			Tween_x.duration = Tween_y.duration = _Tween_flip_duration;
			
			Tween_x.start();
			Tween_y.start();
		}
		
		public function start_drag_page(x:int, y:int, p_type:uint):void
		{			
			p_type -= 4;
			_p_type = p_type;
			if (_p_type == 1 || _p_type == 3)
			{
				_p_type += 1;
			}
			else
			{
				_p_type -= 1;
			}
			
			switch(p_type)
			{
				case 1:
					_x = Tween_x.begin = 0;
					_y = Tween_y.begin = 0;
					break;
				case 2:
					_x = Tween_x.begin = values.page_width;
					_y = Tween_y.begin = 0;
					break;
				case 3:
					_x = Tween_x.begin = 0;
					_y = Tween_y.begin = values.page_height;
					break;
				case 4:
					_x = Tween_x.begin = values.page_width;
					_y = Tween_y.begin = values.page_height;
					break;
					
				default:
					break;
			}

			
			Tween_x.finish = x;
			Tween_y.finish = y;
			
			//添加侦听
			Tween_x.addEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.addEventListener(TweenEvent.MOTION_FINISH, drag_back);
			
			Tween_x.duration = Tween_y.duration = _Tween_drag_duration;
			
			Tween_x.start();
			Tween_y.start();
		}
		
		function drag_back(evt:TweenEvent):void
		{
			Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, drag_back);
			
			var l_event:L_Event = new L_Event(L_Event.DRAG_BACK);
			dispatchEvent(l_event);			
		}
		
		public function start_roll_page(x:int, y:int):void
		{						
			switch(_p_type)
			{
				case 1:
					_x = Tween_x.begin = 0;
					_y = Tween_y.begin = 0;
					break;
				case 2:
					_x = Tween_x.begin = values.page_width;
					_y = Tween_y.begin = 0;
					break;
				case 3:
					_x = Tween_x.begin = 0;
					_y = Tween_y.begin = values.page_height;
					break;
				case 4:
					_x = Tween_x.begin = values.page_width;
					_y = Tween_y.begin = values.page_height;
					break;
					
				default:
					break;
			}

			
			Tween_x.finish = x;
			Tween_y.finish = y;
			
			//添加侦听
			Tween_x.addEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.addEventListener(TweenEvent.MOTION_FINISH, roll_end);
			
			Tween_x.duration = Tween_y.duration = _Tween_roll_over_duration;
			
			Tween_x.start();
			Tween_y.start();
		}
		
		function roll_end(evt:TweenEvent):void
		{
			stop_roll_end();
			
			var l_event:L_Event = new L_Event(L_Event.POINT_ROLL_END);
			dispatchEvent(l_event);	
		}
		
		public function stop_roll_end():void
		{
			if (Tween_x.hasEventListener(TweenEvent.MOTION_FINISH))
			{
				Tween_x.stop();
				Tween_y.stop();
				Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
				Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, roll_end);
			}
		}
		
		
		public function start_roll_back():void
		{			
			if (Tween_x.hasEventListener(TweenEvent.MOTION_FINISH))
			{
				Tween_x.stop();
				Tween_y.stop();
				Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
				Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, roll_end);
			}

			var lx:Number = Tween_x.begin;
			var ly:Number = Tween_y.begin;
			
			Tween_x.begin = cx;
			Tween_y.begin = cy;
			
			Tween_x.finish = lx;			
			Tween_y.finish = ly;

			//添加侦听
			Tween_x.addEventListener(TweenEvent.MOTION_CHANGE, show_back);
			Tween_x.addEventListener(TweenEvent.MOTION_FINISH, roll_back);
			
			Tween_x.duration = Tween_y.duration = _Tween_roll_back_duration;
			
			Tween_x.start();
			Tween_y.start();
		}
		
		function roll_back(evt:TweenEvent):void
		{
			if (Tween_x.hasEventListener(TweenEvent.MOTION_FINISH))
			{
				Tween_x.stop();
				Tween_y.stop();
				Tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, show_back);
				Tween_x.removeEventListener(TweenEvent.MOTION_FINISH, roll_back);
			}
			
			var l_event:L_Event = new L_Event(L_Event.POINT_ROLL_BACK);
			dispatchEvent(l_event);	
		}
		
		public function change_tween_end(x:int, y:int):void
		{
			Tween_x.finish = x;
			Tween_y.finish = y;
		}
		
		public function set point_type(p_type:uint):void
		{
			_p_type = p_type;
		}
		
		public function get is_flipover():Boolean
		{
			return _flip_over;
		}
		
		public function set page_back_seconds(value:Number):void
		{
			if (value > 0)
			{
				_Tween_flip_duration = value;
			}
		}
		
		public function set page_drag_back_seconds(value:Number):void
		{
			if (value > 0)
			{
				_Tween_drag_duration = value;
			}			
		}
		
		public function set page_roll_over_seconds(value:Number):void
		{
			if (value > 0)
			{
				_Tween_roll_over_duration = value;
			}			
		}
		
		public function set page_roll_back_seconds(value:Number):void
		{
			if (value > 0)
			{
				_Tween_roll_back_duration = value;
			}			
		}
	}
	
}