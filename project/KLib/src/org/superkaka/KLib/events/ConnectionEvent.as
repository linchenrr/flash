package org.superkaka.KLib.events 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * 通信连接组件事件
	 * @author ｋａｋａ
	 */
	public class ConnectionEvent extends Event 
	{
		
		///接收到数据包
		static public const DATA:String = "data";
		///发送出数据包(此事件仅供内部sim模式使用)
		static public const DATA_SEND:String = "data_send";
		///连接成功
		static public const SUCCESS:String = "success";
		///连接失败
		static public const FAILED:String = "failed";
		///连接断开
		static public const CLOSE:String = "close";
		
		private var _data:ByteArray;
		
		public function ConnectionEvent(type:String, data:ByteArray = null):void
		{ 
			
			super(type);
			
			this._data = data;
			
		} 
		
		public override function clone():Event 
		{ 
			return new ConnectionEvent(type, data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ConnectionEvent", "type");
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
	}
	
}