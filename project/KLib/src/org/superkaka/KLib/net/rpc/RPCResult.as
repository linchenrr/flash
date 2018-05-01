package org.superkaka.KLib.net.rpc 
{
	/**
	 * 单个RPC过程调用结果
	 * @author ｋａｋａ
	 */
	public class RPCResult
	{
		
		public var result:*;
		
		public var request:RPCRequest;
		
		public function RPCResult(result:*= null, request:RPCRequest = null):void
		{
			
			this.result = result;
			this.request = request;
			
		}
		
	}

}