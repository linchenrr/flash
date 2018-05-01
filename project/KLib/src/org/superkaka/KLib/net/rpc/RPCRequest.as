package org.superkaka.KLib.net.rpc 
{
	/**
	 * RPC请求信息
	 * @author ｋａｋａ
	 */
	public class RPCRequest
	{
		
		public var requestId:uint;
		
		public var procedureId:uint;
		
		public var vars:*;
		
		public var callBacks:Array;
		
		public var errorHandlers:Array;
		
		public function RPCRequest(requestId:uint = 0, procedureId:uint = 0, vars:* = null, callBacks:Array = null, errorHandlers:Array = null):void
		{
			
			this.requestId = requestId;
			this.procedureId = procedureId;
			this.vars = vars;
			this.callBacks = callBacks;
			this.errorHandlers = errorHandlers;
			
		}
		
	}

}