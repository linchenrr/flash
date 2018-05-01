package org.superkaka.KLib.net.rpc.packager 
{
	import flash.utils.ByteArray;
	import org.superkaka.KLib.net.rpc.RPCRequest;
	import org.superkaka.KLib.net.rpc.RPCResponse;
	
	/**
	 * rpc打包器接口
	 * @author ｋａｋａ
	 */
	public interface IRPCPackager 
	{
		
		/**
		 * 注册数据包处理函数
		 * @param	onResponse		RPC调用返回的处理函数
		 * @param	onRequest			RPC调用请求的处理函数
		 */
		function registerHandler(onResponse:Function, onRequest:Function):void;
		
		/**
		 * 注册根据请求id返回过程id的转换器
		 * @param	converter
		 */
		function registerRequestIdToProcedureId(converter:Function):void;
		
		function registerValueEncoder(encoder:IValueEncoder):void;
		
		function encodeRequest(request:RPCRequest):ByteArray;
		
		function encodeResponse(response:RPCResponse):ByteArray;
		
		function decodePacket(stream:ByteArray):void;
		
	}
	
}