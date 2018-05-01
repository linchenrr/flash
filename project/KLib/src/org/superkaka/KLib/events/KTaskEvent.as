package org.superkaka.KLib.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class KTaskEvent extends Event
	{
		
		static public const START:String = "start";
		
		static public const PROGRESS:String = "progress";
		
		static public const COMPLETE:String = "complete";
		
		static public const PAUSE:String = "pause";
		
		static public const CANCEL:String = "cancel";
		
		/**
		 * 任务进度
		 */
		private var _progress:Number;
		
		public function KTaskEvent(type:String, progress:Number = 0):void
		{
			
			super(type);
			
			_progress = progress;
			
		}
		
		public override function clone():Event 
		{ 
			return new KTaskEvent(type, _progress);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ResourceLoaderEvent", "type");
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
	}

}