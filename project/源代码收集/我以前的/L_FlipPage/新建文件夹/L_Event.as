package L_FlipPage
{
	import flash.events.Event;	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_Event extends Event 
	{
		public static const POINTS_READY:String = "points_ready";
		public static const POINTS_BACK:String = "points_back";
		public static const DRAG_BACK:String = "drag_back";
		public static const MOUSE_PRESS:String = "mouse_press";
		public static const MOUSE_INSIDE_PRESS:String = "mouse_inside_press";
		public static const MOUSE_ROLL_OVER:String = "mouse_roll_over";
		public static const MOUSE_ROLL_OUT:String = "mouse_roll_out";
		public static const POINT_ROLL_BACK:String = "point_roll_back";
		public static const POINT_ROLL_END:String = "point_roll_end";
		public static const REACH_SIDE:String = "reach_side";
		public static const PAGES_READY:String = "pages_ready";
		public static const BUTTONS_RESRT:String = "buttons_reset";
		public static const WIDTH_CHANGED:String = "width_changed";
		public static const HEIGHT_CHANGED:String = "height_changed";
		
	    private var _obj:Object;
		
		//在构造函数中传入事件类型
		public function L_Event(type:String):void
		{
			super(type);
			_obj = new Object();
		}
		
		//设置事件附带的参数
		public function set args(obj:Object):void
		{
			_obj = obj;
		}

		//取得事件附带的参数
		public function get args():Object
		{
			return _obj;
		}
		
		//重写toString()方法
		override public function toString():String
		{
			//这里要输出什么还可以自己加
			return formatToString("L_Event", "type", "args");
		}
	}
	
}