package org.superkaka.KLib.net.connection 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import org.superkaka.KLib.events.ConnectionEvent;
	/**
	 * 网络通信连接组件
	 * Connection只管发送和接收数据，不对数据进行任何处理
	 * @author ｋａｋａ
	 */
	public class Connection extends EventDispatcher
	{
		
		private var _blockRead:Boolean;
		private var _blockWrite:Boolean;
		
		private var dataList_read:Array = [];
		private var dataList_write:Array = [];
		
		public function Connection():void
		{
			
		}
		
		public function connect():void
		{
			
			
		}
		
		public function close():void
		{
			
			
		}
		
		final public function send(data:ByteArray):void
		{
			
			if (_blockWrite)
			{
				dataList_write.push(data);
			}
			else
			{
				onSend(data);
			}
			
		}
		
		protected function onSend(data:ByteArray):void
		{
			
			
			
		}
		
		protected function distributeData(data:ByteArray):void
		{
			
			if (_blockRead)
			{
				dataList_read.push(data);
			}
			else
			{
				dispatchEvent(new ConnectionEvent(ConnectionEvent.DATA, data));
			}
			
		}
		
		protected function connectSucess(evt:Event = null):void
		{
			
			dispatchEvent(new ConnectionEvent(ConnectionEvent.SUCCESS));
			
		}
		
		protected function connectFailed(evt:Event = null):void
		{
			
			dispatchEvent(new ConnectionEvent(ConnectionEvent.FAILED));
			
		}
		
		protected function connectClose(evt:Event = null):void
		{
			
			dispatchEvent(new ConnectionEvent(ConnectionEvent.CLOSE));
			
		}
		
		/**
		 * 获取或设置是否阻塞读数据操作
		 * 如果设置为true，接收到的数据将被加入等待队列，不进行分发
		 */
		public function get blockRead():Boolean 
		{
			return _blockRead;
		}
		
		public function set blockRead(value:Boolean):void 
		{
			_blockRead = value;
			
			if (false == _blockRead)
			{
				
				while (dataList_read.length > 0)
				{
					
					distributeData(dataList_read.shift());
					
					if (_blockRead)
					break;
					
				}
				
			}
		}
		
		/**
		 * 获取或设置是否阻塞写数据操作
		 * 如果设置为true，写入的数据将被加入等待队列，不进行传送
		 */
		public function get blockWrite():Boolean 
		{
			return _blockWrite;
		}
		
		public function set blockWrite(value:Boolean):void 
		{
			_blockWrite = value;
			
			if (false == _blockWrite)
			{
				
				while (dataList_write.length > 0)
				{
					
					onSend(dataList_write.shift());
					
					if (_blockWrite)
					break;
					
				}
				
			}
		}
		
	}

}