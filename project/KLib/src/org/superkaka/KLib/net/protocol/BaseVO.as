package org.superkaka.KLib.net.protocol
{
	
    public class BaseVO
    {
		
        private var protocolId:int;
		
        public function BaseVO(protocolId:int):void
        {
            this.protocolId = protocolId;
        }
		
        public function get ProtocolId():int
        {
            return protocolId;
        }
		
        //子类覆写
        public function decode(stream:ProtocolByteArray):void
        {
			
        }
		
        //子类覆写
        public function encode(stream:ProtocolByteArray):void
        {
			
        }
		
    }
}