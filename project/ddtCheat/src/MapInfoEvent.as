package
{
	import flash.events.Event;
	
	public class MapInfoEvent extends Event
	{
		static public const Info_Change:String = "info_change";
		
		public var width:Number;
		
		public function MapInfoEvent(type:String,width:Number):void
		{
			super(type);
			
			this.width=width;
		}
		
		override public function clone():Event
		{
			return new MapInfoEvent(type,width);
		}
	}
}