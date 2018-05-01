package org.superkaka.KLib.net.rpc.packager 
{
	import flash.utils.ByteArray;
	import org.superkaka.KLib.net.rpc.RPCRequest;
	import org.superkaka.KLib.net.rpc.RPCResponse;
	
	/**
	 * RPC参数值打包、解包接口
	 * @author ｋａｋａ
	 */
	public interface IValueEncoder 
	{
		
		function encodeRequest(procedureId:uint, vars:*, stream:ByteArray):void;
		
		function decodeRequest(procedureId:uint, stream:ByteArray):*;
		
		function encodeResponse(procedureId:uint, result:*, stream:ByteArray):void;
		
		function decodeResponse(procedureId:uint, stream:ByteArray):*;
		
	}
	
}