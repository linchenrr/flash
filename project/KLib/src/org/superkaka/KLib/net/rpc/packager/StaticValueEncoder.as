package org.superkaka.KLib.net.rpc.packager 
{
	import flash.utils.ByteArray;
	/**
	 * RPC静态协议打包器，以协议描述信息为依据进行编解码
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-26-星期一 20:27
	 */
	public class StaticValueEncoder implements IValueEncoder 
	{
		
		private var protocolDescription:XML;
		
		public function StaticValueEncoder(protocolDescription:XML):void 
		{
			
			this.protocolDescription = protocolDescription.copy();
			pretreatment();
			
		}
		
		/* INTERFACE org.superkaka.KLib.net.rpc.packager.IValueEncoder */
		
		public function encodeRequest(procedureId:uint, vars:*, stream:ByteArray):void 
		{
			
			encode(getDescription(procedureId, "param"), vars, stream);
			
		}
		
		public function decodeRequest(procedureId:uint, stream:ByteArray):* 
		{
			
			return decode(getDescription(procedureId, "param"), stream)[0];
			
		}
		
		public function encodeResponse(procedureId:uint, result:*, stream:ByteArray):void 
		{
			
			encode(getDescription(procedureId, "return"), result, stream);
			
		}
		
		public function decodeResponse(procedureId:uint, stream:ByteArray):* 
		{
			
			return decode(getDescription(procedureId, "return"), stream)[0];
			
		}
		
		private function getDescription(procedureId:uint, part:String):XML
		{
			
			var xml_description:XML = protocolDescription.message.(@id == procedureId)[0];
			if (null == xml_description) 
			{
				throw new Error("id:" + procedureId + "的描述信息不存在");
			}
			
			return xml_description[part][0];
			
		}
		
		private function getStructArgs(structId:uint):XMLList
		{
			
			var xml_description:XML = protocolDescription.struct.(@id == structId)[0];
			if (null == xml_description) 
			{
				throw new Error("id:" + structId + "的结构体不存在");
			}
			
			return xml_description.args;
			
		}
		
		///预处理XML，将结构体引用节点使用实际结构体节点替换
		private function pretreatment():void
		{
			
			var message:XMLList = protocolDescription.message;
			var i:int = 0;
			var c:int = protocolDescription.message.length();
			while (i < c) 
			{
				
				replaceStruct(message[i]["param"][0].args);
				replaceStruct(message[i]["return"][0].args);
				
				i++;
			}
			
			function replaceStruct(args:XMLList):void
			{
				
				var j:int = 0;
				var k:int = args.length();
				while (j < k) 
				{
					
					var xml_arg:XML = args[j];
					if (xml_arg.@type == "struct")
					{
						if (xml_arg.hasOwnProperty("@id"))
						{
							xml_arg.args = getStructArgs(xml_arg.@id);
						}
						
						replaceStruct(args[j].args);
						
					}
					
					j++;
				}
				
			}
			
		}
		
		private function decode(xml_value:XML, stream:ByteArray, count:uint = 1):Array
		{
			
			var parObj:Array = [];
			
			var xmlList_param:XMLList = xml_value.args;
			
			var p_i:uint = 0;
			
			while (p_i < count) 
			{
				
				var i:int = 0;
				var c:int = xmlList_param.length();
				
				var param:Array = [];
				
				while (i < c) 
				{
					
					var xml_param:XML = xmlList_param[i];
					
					var type:String = xml_param.@type;
					type = type.toLowerCase();
					
					var par:*;
					
					switch(type)
					{
						
						case "byte":
							par = stream.readByte();
							break;
							
						case "ushort":
							par = stream.readUnsignedShort();
							break;
							
						case "short":
							par = stream.readShort();
							break;
							
						case "uint":
							par = stream.readUnsignedInt();
							break;
							
						case "int":
							par = stream.readInt();
							break;
							
						case "boolean":
							par = stream.readBoolean();
							break;
							
						case "string":
							par = stream.readUTF();
							break;
							
						case "date":
							var date:Date = new Date();
							date.setTime(stream.readUnsignedInt() * 1000);
							par = date;
							break;
							
						case "struct":
							par = decode(xml_param, stream, stream.readUnsignedShort());
							break;
							
						default:
							throw new Error("未知的参数类型:" + type);
							break;
							
					}
					param[i] = par;
					param[xml_param.@name] = par;
					
					i++;
					
				}
				
				parObj[p_i] = param;
				
				p_i++;
				
			}
			
			return parObj;
			
		}
		
		private function encode(xml_param:XML, param:*, stream:ByteArray):void
		{
			
			var xmlList_param:XMLList = xml_param.args;
			
			var paramList:Array;
			
			if (param is Array)
			{
				paramList = param;
			}
			else
			{
				paramList = [];
				
				var p_i:uint = 0;
				var len:uint = xmlList_param.length();
				
				while (p_i < len) 
				{
					
					var paramName:String = String(xmlList_param[p_i].@name);
					var paramValue:*= param[paramName];
					if (null == paramValue) 
					{
						throw new Error("参数" + paramName + "未赋值！");
					}
					paramList[p_i] = paramValue;
					
					p_i++;
					
				}
				
			}
			
			
			var i:int = 0;
			var c:int = paramList.length;
			
			while (i < c) 
			{
				
				var type:String = xmlList_param[i].@type;
				type = type.toLowerCase();
				
				switch(type)
				{
					
					case "byte":
						stream.writeByte(paramList[i]);
						break;
						
					case "short":
					case "ushort":
						stream.writeShort(paramList[i]);
						break;
						
					case "uint":
						stream.writeUnsignedInt(paramList[i]);
						break;
						
					case "int":
						stream.writeInt(paramList[i]);
						break;
						
					case "boolean":
						stream.writeBoolean(paramList[i]);
						break;
						
					case "string":
						stream.writeUTF(paramList[i]);
						break;
						
					case "date":
						var date:Date = paramList[i];
						stream.writeUnsignedInt(date.getTime() / 1000);
						break;
						
					case "struct":
						var structList:Array = paramList[i];
						
						var count:uint = structList.length;
						stream.writeShort(count);
						p_i = 0;
						while (p_i < count) 
						{
							
							encode(xmlList_param[i], structList[p_i], stream);
							p_i++;
							
						}
						break;
						
					default:
						throw new Error("未知的参数类型:" + type);
						break;
						
				}
				
				i++;
				
			}
			
		}
		
	}

}