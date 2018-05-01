package org.superkaka.KLib.net.protocol 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;


    public class PackageTranslator
    {
		
        private var dic_vo:Object = { };
        
        public function PackageTranslator():void
        {
            
        }
		
        public function RegisterMessage(protocolId:int, packageCreateFun:Function):void
        {
            dic_vo[protocolId] = packageCreateFun;
        }
		
        public function Encode(vo:BaseVO):ByteArray
        {
            var binWriter:ProtocolByteArray = new ProtocolByteArray();
            binWriter.endian = Endian.BIG_ENDIAN;
            binWriter.writeInt(vo.ProtocolId);
            vo.encode(binWriter);
            return binWriter;
        }
		
        public function Decode(bytes:ByteArray):BaseVO
        {
            var binReader:ProtocolByteArray = new ProtocolByteArray(bytes);
            binReader.endian = Endian.BIG_ENDIAN;
            var id:int = binReader.readInt();
			
            var packageCreateFun:Function = dic_vo[id];
			
            var vo:BaseVO = packageCreateFun();
            vo.decode(binReader);
			
            return vo;
        }
		
    }
}
