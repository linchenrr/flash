package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class DistanceEvent extends Event
	{
		static public const DIS_UPDATE:String = "dis_update";
		
		private var _dis:Distance;
		///方向
		private var _direction:Boolean;
		public function DistanceEvent(type:String, direction:Boolean, distance:Distance):void
		{
			super(type);
			this._direction = direction;
			this._dis = distance;
		}
		
		public function get distance():Distance { return _dis; }		
		
		///方向，左打右为true，右打左为false
		public function get direction():Boolean { return _direction; }
		
		override public function clone():Event
		{
			return new DistanceEvent(type, _direction, _dis);
		}
		
	}
	
}