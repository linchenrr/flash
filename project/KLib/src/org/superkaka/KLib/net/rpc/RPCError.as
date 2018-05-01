package org.superkaka.KLib.net.rpc 
{
	/**
	 * 表示RPC请求异常信息
	 * @author ｋａｋａ
	 */
	public class RPCError
	{
		
		public var id:uint;
        public var message:String;
		public var request:RPCRequest;
		
		public function RPCError(id:int = 0, message:String = ""):void
		{
			
			this.id = id;
			this.message = message;
			
		}
		
		public function toString():String
        {
			
            return "RPCError  id:" + id + "  message: " + message;
			
        }
		
	}

}