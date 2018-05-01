package org.superkaka.KLib.net.rpc 
{
	/**
	 * RPC请求存储池
	 * @author ｋａｋａ
	 */
	public class RPCRequestPool
	{
		
		private const dic_request:Object = { };
		private var requestId:uint = 1;
		
		private var _poolId:String;
		
		private var defaultCompleteHandler:Function;
		private var defaultErrorHandler:Function;
		
		public function RPCRequestPool(poolId:String, hiddenCls:HiddenCls):void
		{
			
			if (null == hiddenCls) throw new Error("请通过connect静态方法创建");
			
			this._poolId = poolId;
			
		}
		
		public function registerDefaultHandler(defaultCompleteHandler:Function, defaultErrorHandler:Function):void
		{
			this.defaultCompleteHandler = defaultCompleteHandler;
			this.defaultErrorHandler = defaultErrorHandler;
		}
		
		public function doResponse(response:RPCResponse):void
		{
			
			var request:RPCRequest = dic_request[response.requestId];
			
			if (request == null) return;
			
			callHandlers(request, response.result);
			
			removeRequest(response.requestId);
			
		}
		
		private function callHandlers(request:RPCRequest, result:*):void
		{
			
			var handlers:Array;
			
			var rpcResult:*;
			
			if (result is RPCError)
			{
				var rpcError:RPCError = result;
				rpcError.request = request;
				rpcResult = rpcError;
				handlers = request.errorHandlers;
			}
			else
			{
				rpcResult = new RPCResult(result, request);
				handlers = request.callBacks;
			}
			
			if (handlers == null) return;
			
			var i:int = 0;
			var c:int = handlers.length;
			
			while (i < c) 
			{
				
				handlers[i].call(null, rpcResult);
				
				i++;
				
			}
			
		}
		
		public function newRequest(procedureId:uint, vars:*, callBack:Function = null, errorHandler:Function = null):RPCRequest
		{
			
			var request:RPCRequest = new RPCRequest(requestId, procedureId, vars, 
				joinHandlers(defaultCompleteHandler, callBack), 
				joinHandlers(defaultErrorHandler, errorHandler)
			);
			
			if (null != request.callBacks || null != request.errorHandlers) 
			{
				dic_request[request.requestId] = request;
				//ushort最大值65535
				if (++requestId > 65535)
				requestId = 1;
			}
			
			return request;
			
		}
		
		public function removeRequest(requestId:uint):void
		{
			
			dic_request[requestId] = null;
			delete dic_request[requestId];
			
		}
		
		public function getProcedureIdByRequestId(requestId:uint):uint
		{
			
			var request:RPCRequest = dic_request[requestId];
			if (null == request) throw new Error("无效的requestId");
			
			return request.procedureId;
			
		}
		
		public function get poolId():String 
		{
			return _poolId;
		}
		
		private function joinHandlers(firstHandler:Function, handler:Function):Array
		{
			
			if (null == handler) return null;
			
			var handlerList:Array = [handler];
			
			if (firstHandler != null)
			{
				handlerList.unshift(firstHandler);
			}
			
			return handlerList;
			
		}
		
		
		//===============静态================
		static private const dic_pool:Object = { };
		static private var idx:uint = 0;
		
		static public function connect(poolId:String = null):RPCRequestPool
		{
			
			if (null == poolId) poolId = "poolId" + (++idx);
			return dic_pool[poolId] || (dic_pool[poolId] = new RPCRequestPool(poolId, new HiddenCls));
			
		}
		
		
		
	}

}
class HiddenCls { };