package org.superkaka.KLib.net.protocol
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import org.superkaka.KLib.events.ConnectionEvent;
	import org.superkaka.KLib.net.connection.Connection;
	
	/**
	 * 远程过程调用客户端
	 * @author ｋａｋａ
	 */
	public class RPCClient extends EventDispatcher
	{
		
		protected var connection:Connection;
		protected var packager:PackageTranslator;
		
		protected const dic_requestHandler:Object = { };
		public var defaultHandler:Function;
		
		public function RPCClient(connection:Connection, packager:PackageTranslator):void
		{
			this.connection = connection;
			this.packager = packager;
		}
		
		public function connect():void
		{
			
			this.connection.addEventListener(ConnectionEvent.DATA, connectDataHandler);
			this.connection.addEventListener(ConnectionEvent.SUCCESS, connectionEventHandler);
			this.connection.addEventListener(ConnectionEvent.FAILED, connectionEventHandler);
			this.connection.addEventListener(ConnectionEvent.CLOSE, connectionEventHandler);
			
			this.connection.connect();
			
		}
		
		/**
		 * 注册处理RPC请求的函数
		 * @param	procedureId			过程id
		 * @param	handler					指定要处理该过程的处理器
		 */
		public function registerRequestHandler(procedureId:uint, handler:Function):void
		{
			
			dic_requestHandler[procedureId] = handler;
			
		}
		
		/**
		 * 调用远程过程
		 * @param	procedureId			过程id
		 * @param	vars						指定调用过程的参数
		 * @param	completeHandler		指定处理该过程调用返回时的处理器
		 * @param	errorHandler			指定本次过程调用异常时的回调
		 */
		public function call(vo:BaseVO):void
		{
			
			var bytes:ByteArray = packager.Encode(vo);
			send(bytes);
			
		}
		
		protected function send(data:ByteArray):void
		{
			connection.send(data);
		}
		
		protected function connectDataHandler(evt:ConnectionEvent):void
		{
			
			var vo:BaseVO = packager.Decode(evt.data);
			if (null != defaultHandler)
			defaultHandler.call(null, vo);
			
			var handler:Function = dic_requestHandler[vo.ProtocolId];
			if (null == handler) 
			{
				trace("过程" + vo.ProtocolId + "缺少处理函数！");
				return;
			}
			handler.call(null, vo);
			
		}
		
		protected function connectionEventHandler(evt:ConnectionEvent):void
		{
			
			dispatchEvent(evt);
			
		}
		
	}

}