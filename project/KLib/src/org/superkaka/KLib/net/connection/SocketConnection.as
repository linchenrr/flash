package org.superkaka.KLib.net.connection 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	/**
	 * 基于socket协议的网络通信连接组件
	 * @author ｋａｋａ
	 */
	public class SocketConnection extends Connection
	{
		
		private var socket:Socket;
		
		private var len:int = -1;
		
		public var host:String;
		public var port:int;
		
		//由于TCP协议需要等待对方的响应才能继续发送下一个包，所以做一些延时等待以将数据包合成一个一次性发出，避免高延迟时包之间间隔变大
		protected var timer:Timer = new Timer(30, 1);
		
		public function SocketConnection(host:String = null, port:int = 0):void
		{
			
			socket = new Socket();
			this.endian = Endian.BIG_ENDIAN;
			this.host = host;
			this.port = port;
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onFlush);
			
		}
		
		override public function connect():void
		{
			
			if (connected)
			{
				throw new Error("尝试对处于连接状态的socket进行连接操作");
			}
			
			
			configureListeners();
			
			socket.connect(host, port);
			
		}
		
		override public function close():void
		{
			
			socket.close();
			
		}
		
		override protected function onSend(data:ByteArray):void
		{
			
			socket.writeInt(data.length);
			socket.writeBytes(data);
			
			if (!timer.running)
			{
				timer.reset();
				timer.start();
			}
			
		}
		
		protected function onFlush(evt:TimerEvent):void
		{
			socket.flush();
		}
		
		private function configureListeners():void 
		{
			socket.addEventListener(Event.CLOSE, connectClose);
			socket.addEventListener(Event.CONNECT, connectSucess);
			socket.addEventListener(IOErrorEvent.IO_ERROR, connectFailed);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectFailed);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		
		private function socketDataHandler(event:ProgressEvent):void 
		{
			
			readData();
			
		}
		
		private function readData():void
		{
			
			if (len < 0 && socket.connected && socket.bytesAvailable >= 2)
			{
				
				len = socket.readInt();
				
			}
			
			if (len >= 0 && socket.bytesAvailable >= len)
			{
				
				var data:ByteArray = new ByteArray();
				data.endian = this.endian;
				socket.readBytes(data, 0, len);
				
				distributeData(data);
				
				len = -1;
				
				readData();
				
			}
			
		}
		
		public function get endian():String 
		{
			return socket.endian;
		}
		
		public function set endian(value:String):void 
		{
			socket.endian = value;
		}
		
		public function get connected():Boolean 
		{
			return socket.connected;
		}
		
		public function set writeDelay(value:int):void
		{
			if (value < 0)
			value = 0;
			timer.delay = value;
		}
		
		public function get writeDelay():int
		{
			return timer.delay;
		}
		
	}

}