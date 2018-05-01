package org.superkaka.KLib.net.rpc 
{
	/**
	 * RPC请求响应结果
	 * @author ｋａｋａ
	 */
	public class RPCResponse
	{
		
		public var requestId:uint;
		
		public var procedureId:uint;
		
		public var result:*;
		
		public function RPCResponse(requestId:uint = 0, procedureId:uint = 0, result:* = null):void
		{
			
			this.requestId = requestId;
			this.procedureId = procedureId;
			this.result = result;
			
		}
		
	}

}