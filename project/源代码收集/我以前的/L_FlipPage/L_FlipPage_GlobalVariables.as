package L_FlipPage
{
	import flash.events.EventDispatcher;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_GlobalVariables extends EventDispatcher
	{
		private static var _instance:L_FlipPage_GlobalVariables;
		
		private var _width:uint;
		private var _height:uint;
		private var _is_flip:Boolean;
		
		public function L_FlipPage_GlobalVariables(hiddenclass:L_FlipPage_HiddenClass):void
		{			
		}
		
		public static function get values():L_FlipPage_GlobalVariables
		{
			if (_instance == null)
			{
				_instance = new L_FlipPage_GlobalVariables(new L_FlipPage_HiddenClass());
			}
			
			return _instance;
		}
		
		/////////////////////////////////////////////////////////
		
		public function set page_width(value:int):void
		{
			if (value < 0)
			{
				value = -value;
			}			
			_width = value;
			dispatchEvent(new L_Event(L_Event.WIDTH_CHANGED));
		}
		
		public function get page_width():int
		{
			return _width;
		}
		
		public function set page_height(value:int):void
		{
			if (value < 0)
			{
				value = -value;
			}			
			_height = value;
			dispatchEvent(new L_Event(L_Event.HEIGHT_CHANGED));
		}		
		
		public function get page_height():int
		{
			return _height;
		}
		
		public function set is_flip(value:Boolean):void
		{
			_is_flip = value;
		}
		
		public function get is_flip():Boolean
		{
			return _is_flip;
		}
	}
	
}

class L_FlipPage_HiddenClass{}