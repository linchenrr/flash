package org.superkaka.KLib.net.rpc.packager 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.superkaka.KLib.net.rpc.RPCError;
	import org.superkaka.KLib.net.rpc.RPCRequest;
	import org.superkaka.KLib.net.rpc.RPCResponse;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-27-星期二 14:03
	 */
	public class RPCPackager implements IRPCPackager 
	{
		
		private var onResponse:Function;
		private var onRequest:Function;
		private var converter:Function;
		
		private var encoder:IValueEncoder;
		
		public function RPCPackager(valueEncoder:IValueEncoder = null):void 
		{
			
			registerValueEncoder(valueEncoder);
			
		}
		
		/* INTERFACE org.superkaka.KLib.net.rpc.packager.IRPCPackager */
		
		public function registerHandler(onResponse:Function, onRequest:Function):void 
		{
			
			this.onResponse = onResponse;
			this.onRequest = onRequest;
			
		}
		
		public function registerRequestIdToProcedureId(converter:Function):void 
		{
			
			this.converter = converter;
			
		}
		
		public function registerValueEncoder(encoder:IValueEncoder):void
		{
			
			this.encoder = encoder;
			
		}
		
		public function encodeRequest(request:RPCRequest):ByteArray
		{
			
			var stream:ByteArray = newStream();
			stream.writeByte(RPCPacketType.REQUEST);
			stream.writeShort(request.requestId);
			stream.writeShort(request.procedureId);
			encoder.encodeRequest(request.procedureId, request.vars, stream);
			return stream;
			
		}
		
		public function encodeResponse(response:RPCResponse):ByteArray
		{
			
			var stream:ByteArray = newStream();
			
			if (response.result is RPCError)
			{
				stream.writeByte(RPCPacketType.ERROR);
				stream.writeShort(response.requestId);
				var error:RPCError = response.result;
				stream.writeShort(error.id);
				stream.writeUTF(error.message);
			}
			else
			{
				stream.writeByte(RPCPacketType.RESPONSE);
				stream.writeShort(response.requestId);
				encoder.encodeResponse(response.procedureId, response.result, stream);
			}
			
			return stream;
			
		}
		
		public function decodePacket(stream:ByteArray):void
		{
			
			var packetType:uint = stream.readUnsignedByte();
			var requestId:uint = stream.readUnsignedShort();
			var procedureId:uint;
			var vars:*;
			
			switch(packetType)
			{
				
				case RPCPacketType.REQUEST:
					procedureId = stream.readUnsignedShort();
					vars = encoder.decodeRequest(procedureId, stream);
					if (null != onRequest)
					onRequest(new RPCRequest(requestId, procedureId, vars));
					break;
					
				case RPCPacketType.RESPONSE:
					procedureId = converter(requestId);
					vars = encoder.decodeResponse(procedureId, stream);
					if (null != onResponse)
					onResponse(new RPCResponse(requestId, procedureId, vars));
					break;
					
				case RPCPacketType.ERROR:
					procedureId = converter(requestId);
					var errorId:int = stream.readUnsignedShort();
					var message:String = stream.readUTF();
					onResponse(new RPCResponse(requestId, procedureId, new RPCError(errorId, message)));
					break;
					
				default:
					throw new Error("未知包体类型:" + packetType);
				
			}
			
		}
		
		private function newStream():ByteArray
		{
			
			var stream:ByteArray = new ByteArray();
			stream.endian = Endian.LITTLE_ENDIAN;
			return stream;
			
		}
		
	}

}