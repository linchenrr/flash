package org.superkaka.KLib.net.rpc 
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import org.superkaka.KLib.events.ConnectionEvent;
	import org.superkaka.KLib.net.connection.Connection;
	import org.superkaka.KLib.net.rpc.packager.IRPCPackager;
	
	/**
	 * 远程过程调用客户端
	 * @author ｋａｋａ
	 */
	public class RPCClient extends EventDispatcher
	{
		
		protected var requestPool:RPCRequestPool;
		
		protected var connection:Connection;
		protected var packager:IRPCPackager;
		
		protected const dic_requestHandler:Object = { };
		
		public function RPCClient():void
		{
			
		}
		
		public function initialize(connection:Connection, packager:IRPCPackager):void
		{
			
			this.connection = connection;
			this.packager = packager;
			
			requestPool = RPCRequestPool.connect();
			
			packager.registerHandler(onResponse, onRequest);
			packager.registerRequestIdToProcedureId(requestPool.getProcedureIdByRequestId);
			
		}
		
		public function connect():void
		{
			
			this.connection.addEventListener(ConnectionEvent.DATA, connectDataHandler);
			this.connection.addEventListener(ConnectionEvent.SUCCESS, connectionEventHandler);
			this.connection.addEventListener(ConnectionEvent.FAILED, connectionEventHandler);
			this.connection.addEventListener(ConnectionEvent.CLOSE, connectionEventHandler);
			
			this.connection.connect();
			
		}
		
		public function registerDefaultHandler(defaultCompleteHandler:Function, defaultErrorHandler:Function):void
		{
			requestPool.registerDefaultHandler(defaultCompleteHandler, defaultErrorHandler);
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
		public function call(procedureId:uint, vars:*, callBack:Function = null, errorHandler:Function = null):void
		{
			
			var request:RPCRequest = requestPool.newRequest(procedureId, vars, callBack, errorHandler);
			
			send(packager.encodeRequest(request));
			
		}
		
		protected function send(data:ByteArray):void
		{
			connection.send(data);
		}
		
		protected function onRequest(request:RPCRequest):void
		{
			
			var handler:Function = dic_requestHandler[request.procedureId];
			if (null == handler) throw new Error("过程" + request.procedureId + "缺少处理函数！");
			
			var result:*= handler.call(null, request.vars);
			
			///如果没有返回值则不作响应
			if (null == result)
			return;
			
			send(packager.encodeResponse(new RPCResponse(request.requestId, request.procedureId, result)));
			
		}
		
		protected function onResponse(response:RPCResponse):void
		{
			
			requestPool.doResponse(response);
			
		}
		
		protected function connectDataHandler(evt:ConnectionEvent):void
		{
			
			packager.decodePacket(evt.data);
			
		}
		
		protected function connectionEventHandler(evt:ConnectionEvent):void
		{
			
			dispatchEvent(evt);
			
		}
		
	}

}