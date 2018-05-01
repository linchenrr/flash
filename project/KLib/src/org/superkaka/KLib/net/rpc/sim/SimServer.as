package org.superkaka.KLib.net.rpc.sim 
{
	import flash.utils.ByteArray;
	import org.superkaka.KLib.events.ConnectionEvent;
	import org.superkaka.KLib.net.connection.Connection;
	import org.superkaka.KLib.net.connection.SimConnection;
	import org.superkaka.KLib.net.rpc.packager.IRPCPackager;
	import org.superkaka.KLib.net.rpc.RPCClient;
	import org.superkaka.KLib.net.rpc.RPCRequest;
	import org.superkaka.KLib.net.rpc.RPCResponse;
	
	/**
	 * 模拟服务器
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-28-星期三 19:00
	 */
	public class SimServer extends RPCClient 
	{
		
		protected var simDataTable:SimDataTable = new SimDataTable();
		protected var defaultRequestHandler:Function;
		protected var simConnection:Function;
		
		public function SimServer(connection:SimConnection, packager:IRPCPackager):void 
		{
			
			super(connection, packager);
			
			(connection as SimConnection).addEventListener(ConnectionEvent.DATA_SEND, connectDataHandler);
			
		}
		
		public function registerSimDataTable(simDataTable:SimDataTable):void
		{
			this.simDataTable = simDataTable;
		}
		
		///处理客户端传来的RPC调用请求
		override protected function onRequest(request:RPCRequest):void
		{
			
			///接收到请求后先查找该过程是否指定了处理函数，如果有并且函数返回值非空，则按此返回值回应
			///否则继续查找是否有该过程的模拟返回数据，如果都没有则不作响应
			
			var result:*;
			var handler:Function = dic_requestHandler[request.procedureId];
			
			if (handler != null)
			result = handler.call(null, request.vars);
			
			if (null == result)
			{
				var simData:SimData = simDataTable.getSimData(request.procedureId);
				if (null == simData || null == simData.simReturn)
				{
					trace("过程" + request.procedureId + "缺少处理函数并且没有可模拟数据，因此不作响应");
					return;
					//throw new Error("过程" + request.procedureId + "缺少处理函数并且没有可模拟数据！");
				}
				result = simData.simReturn;
			}
			
			send(packager.encodeResponse(new RPCResponse(request.requestId, request.procedureId, result)));
			
		}
		
		///服务器处于连接的另一端，因此所有的send操作相当于对连接的反向发送数据
		override protected function send(data:ByteArray):void
		{
			(connection as SimConnection).sendBack(data);
		}
		
		override public function connect():void
		{
			throw new Error("模拟服务器处于连接的另一端，不要调用此方法");
		}
		
	}

}