package org.superkaka.KLib.net.connection 
{
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import org.superkaka.KLib.events.ConnectionEvent;
	import org.superkaka.KLib.utils.Cloner;
	/**
	 * sim模式专用，客户端与模拟服务器使用的连接
	 * @author ｋａｋａ
	 */
	public class SimConnection extends Connection
	{
		
		private var dic_timer:Dictionary = new Dictionary();
		
		///最大模拟响应延迟，以秒为单位
		public var maxDelay:Number = 1;
		
		public function SimConnection():void
		{
			
		}
		
		override public function connect():void
		{
			
			trace("SimConnection connect !");
			
		}
		
		override protected function onSend(data:ByteArray):void
		{
			
			delayCall(data, doSend);
			
		}
		
		private function doSend(data:ByteArray):void
		{
			
			dispatchEvent(new ConnectionEvent(ConnectionEvent.DATA_SEND, (Cloner.cloneByteArray(data))));
			
		}
		
		public function sendBack(data:ByteArray):void
		{
			
			delayCall(Cloner.cloneByteArray(data), distributeData);
			
		}
		
		private function delayCall(data:ByteArray, handler:Function):void
		{
			
			var timer:Timer = new Timer((Math.random() * maxDelay) * 1000, 1);
			dic_timer[timer] = [data, handler];
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayCall);
			timer.start();
			
		}
		
		private function onDelayCall(evt:TimerEvent):void
		{
			
			var timer:Timer = evt.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayCall);
			
			var info:Array = dic_timer[timer];
			
			dic_timer[timer] = null;
			delete dic_timer[timer];
			
			info[1](info[0]);
			
		}
		
	}

}