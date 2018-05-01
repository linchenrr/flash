package org.superkaka.KLib.net.rpc.packager 
{
	import org.superkaka.KLib.data.KDataPackager;
	import org.superkaka.KLib.net.rpc.RPCResponse;
	import org.superkaka.KLib.net.rpc.RPCRequest;
	import flash.utils.ByteArray;
	/**
	 * RPC动态协议打包器，使用 KData 编码格式
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-26-星期一 13:02
	 */
	public class DynamicValueEncoder implements IValueEncoder
	{
		
		public function DynamicValueEncoder():void
		{
			
		}
		
		/* INTERFACE org.superkaka.KLib.net.rpc.packager.IValueEncoder */
		
		public function encodeRequest(procedureId:uint, vars:*, stream:ByteArray):void
		{
			
			var kData:KDataPackager = new KDataPackager(stream);
			kData.writeValue(vars);
			
		}
		
		public function decodeRequest(procedureId:uint, stream:ByteArray):* 
		{
			
			var kData:KDataPackager = new KDataPackager(stream);
			return kData.readValue();
			
		}
		
		public function encodeResponse(procedureId:uint, result:*, stream:ByteArray):void 
		{
			
			var kData:KDataPackager = new KDataPackager(stream);
			kData.writeValue(result);
			
		}
		
		public function decodeResponse(procedureId:uint, stream:ByteArray):* 
		{
			
			var kData:KDataPackager = new KDataPackager(stream);
			return kData.readValue();
			
		}
		
	}

}