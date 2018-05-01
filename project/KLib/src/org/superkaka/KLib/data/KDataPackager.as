package org.superkaka.KLib.data 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * KData格式数据封包、解包
	 * @author ｋａｋａ
	 */
	public class KDataPackager
	{
		
		/**
		 * 处理的字节数据
		 */
		private var _data:ByteArray;
		
		private var _endian:String;
		
		public function KDataPackager(data:ByteArray = null, endian:String = Endian.LITTLE_ENDIAN):void
		{
			
			_endian = endian;
			this.data = data || new ByteArray();
			
		}
		
		/**
		 * 处理的字节数据
		 */
		public function get data():ByteArray 
		{
			return _data;
		}
		
		/**
		 * 处理的字节数据
		 */
		public function set data(value:ByteArray):void 
		{
			_data = value;
			if (_data == null) return;
			_data.endian = _endian;
		}
		
		public function get position():uint 
		{
			return _data.position;
		}
		
		public function set position(value:uint):void 
		{
			_data.position = value;
		}
		
		public function get endian():String 
		{
			return _endian;
		}
		
		public function set endian(value:String):void 
		{
			_endian = value;
			
			if (_data != null)
			_data.endian = _endian;
			
		}
		
		/**
		 * 重置到初始状态
		 * 清除字节数组的内容，并将指针重置为 0
		 */
		public function reset():void
		{
			
			_data.clear();
			
		}
		
		public function writeByte(i:int, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.BYTE);
			_data.writeByte(i);
			
		}
		
		public function readByte(withTag:Boolean = false):int
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readByte();
			
		}
		
		public function readUByte(withTag:Boolean = false):uint
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readUnsignedByte();
			
		}
		
		public function writeShort(i:int, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.SHORT);
			_data.writeShort(i);
			
		}
		
		public function readShort(withTag:Boolean = false):int
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readShort();
			
		}
		
		public function readUShort(withTag:Boolean = false):uint
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readUnsignedShort();
			
		}
		
		public function writeInt(i:int, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.INT);
			_data.writeInt(i);
			
		}
		
		public function readInt(withTag:Boolean = false):int
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readInt();
			
		}
		
		public function writeUint(u:uint, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.UINT);
			_data.writeUnsignedInt(u);
			
		}
		
		public function readUint(withTag:Boolean = false):uint
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readUnsignedInt();
			
		}
		
		public function writeDouble(n:Number, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.NUMBER);
			_data.writeDouble(n);
			
		}
		
		public function readDouble(withTag:Boolean = false):Number
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readDouble();
			
		}
		
		public function writeBoolean(bool:Boolean, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.BOOLEAN);
			_data.writeBoolean(bool);
			
		}
		
		public function readBoolean(withTag:Boolean = false):Boolean
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readBoolean();
			
		}
		
		public function writeString(str:String, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.STRING);
			_data.writeUTF(str);
			
		}
		
		public function readString(withTag:Boolean = false):String
		{
			
			if (withTag)_data.position += 1;
			
			return _data.readUTF();
			
		}
		
		public function writeBinary(ba:ByteArray, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.BINARY);
			_data.writeUnsignedInt(ba.length);
			_data.writeBytes(ba);
			
		}
		
		public function readBinary(withTag:Boolean = false):ByteArray
		{
			
			if (withTag)_data.position += 1;
			
			var length:uint = _data.readUnsignedInt();
			var ba:ByteArray = new ByteArray();
			_data.readBytes(ba, 0, length);
			ba.position = 0;
			
			return ba;
			
		}
		
		public function writeArray(array:Array, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.ARRAY);
			
			var i:int = 0;
			var c:int = array.length;
			
			_data.writeUnsignedInt(c);
			
			while (i < c) 
			{
				
				writeValue(array[i]);
				
				i++;
				
			}
			
		}
		
		public function readArray(withTag:Boolean = false):Array
		{
			
			if (withTag)_data.position += 1;
			
			var i:int = 0;
			var c:uint = _data.readUnsignedInt();
			var array:Array = new Array(c);
			
			while (i < c) 
			{
				
				array[i] = readValue();
				
				i++;
				
			}
			
			return array;
			
		}
		
		public function writeTypeArray(typeArray:KTypeArray, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.TYPEARRAY);
			
			var type:int = typeArray.type;
			var array:Array = typeArray.array;
			
			var i:int = 0;
			var c:int = array.length;
			
			_data.writeUnsignedInt(c);
			_data.writeByte(type);
			
			while (i < c) 
			{
				
				writeValue(new KTypeData(type, array[i]), false);
				
				i++;
				
			}
			
		}
		
		public function readTypeArray(withTag:Boolean = false):KTypeArray
		{
			
			if (withTag)_data.position += 1;
			
			var i:int = 0;
			var c:uint = _data.readUnsignedInt();
			
			var type:int = _data.readByte();
			var typeArray:KTypeArray = new KTypeArray(type);
			var array:Array = typeArray.array;
			array.type = type;
			
			while (i < c) 
			{
				
				array[i] = readValue(type);
				
				i++;
				
			}
			
			return typeArray;
			
		}
		
		public function writeObject(o:Object, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.OBJECT);
			
			var curPos:uint = _data.position;
			var c:uint = 0;
			
			//这一句写入无意义数据是为了让指针向前移动
			_data.writeUnsignedInt(c);
			
			for (var key:String in o)
			{
				
				_data.writeUTF(key);
				writeValue(o[key]);
				
				c++;
				
			}
			
			var newPos:uint = _data.position;
			
			_data.position = curPos;
			_data.writeUnsignedInt(c);
			_data.position = newPos;
			
		}
		
		public function readObject(withTag:Boolean = false):Object
		{
			
			if (withTag)_data.position += 1;
			
			var o:Object = { };
			
			var i:uint = 0;
			var c:uint = _data.readUnsignedInt();
			
			while (i < c) 
			{
				
				o[_data.readUTF()] = readValue();
				
				i++;
				
			}
			
			return o;
			
		}
		
		public function writeTypeObject(typeObject:KTypeObject, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.TYPEOBJECT);
			
			var type:int = typeObject.type;
			var o:Object = typeObject.object;
			
			var curPos:uint = _data.position;
			var c:uint = 0;
			
			_data.writeUnsignedInt(c);
			_data.writeByte(type);
			
			for (var key:String in o)
			{
				
				_data.writeUTF(key);
				writeValue(new KTypeData(type, o[key]), false);
				
				c++;
				
			}
			
			var newPos:uint = _data.position;
			
			_data.position = curPos;
			_data.writeUnsignedInt(c);
			_data.position = newPos;
			
		}
		
		public function readTypeObject(withTag:Boolean = false):KTypeObject
		{
			
			if (withTag)_data.position += 1;
			
			var i:uint = 0;
			var c:uint = _data.readUnsignedInt();
			
			var type:int = _data.readByte();
			
			var typeObject:KTypeObject = new KTypeObject(type);
			var o:Object = typeObject.object;
			
			while (i < c) 
			{
				
				o[_data.readUTF()] = readValue(type);
				
				i++;
				
			}
			
			return typeObject;
			
		}
		
		public function writeDate(date:Date, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.DATE);
			_data.writeDouble(date.getTime() - date.getTimezoneOffset() * 60000);
			
		}
		
		public function readDate(withTag:Boolean = false):Date
		{
			
			if (withTag)_data.position += 1;
			var date:Date = new Date();
			date.setTime(_data.readDouble() + date.getTimezoneOffset() * 60000);
			
			return date;
			
		}
		
		public function writeTable(table:KTable, withTag:Boolean = false):void
		{
			
			if (withTag)_data.writeByte(KDataFormat.TABLE);
			
			var header:Array = table.header;
			var dataList:Array = table.Select();
			var rowNum:int = dataList.length;
			var columnNum:Number = header.length;
			
			_data.writeInt(table.primaryKeyIndex);
			_data.writeInt(rowNum);
			_data.writeInt(columnNum);
			
			var i:int = 0;
			var c:int = header.length;
			while (i < c)
			{
				
				_data.writeUTF(header[i]);
				
				i++;
				
			}
			
			var row:int = 0;
			while (row < rowNum)
			{
				
				var column:int = 0;
				
				var dataItem:Object = dataList[row];
				
				while (column < columnNum) 
				{
					
					_data.writeUTF(dataItem[header[column]]);
					
					column++;
					
				}
				
				row++;
				
			}
			
		}
		
		public function readTable(withTag:Boolean = false):KTable
		{
			
			if (withTag)_data.position += 1;
			
			var primaryKeyIndex:int = _data.readInt();
			
			var rowC:int = _data.readInt();
			var columnC:int = _data.readInt();
			
			var row:int = 0;
			var column:int = 0;
			
			var header:Array = new Array(columnC);
			
			while (column < columnC)
			{
				
				header[column] = _data.readUTF();
				
				column++;
				
			}
			
			var table:KTable = new KTable(header, primaryKeyIndex);
			
			while (row < rowC)
			{
				
				column = 0;
				
				var dataItemObject:Object = new Object();
				
				while (column < columnC)
				{
					
					var dataValue:String = _data.readUTF();
					
					dataItemObject[header[column]] = dataValue;
					
					column++;
					
				}
				
				table.Insert(dataItemObject);
				
				row++;
				
			}
			
			return table;
			
		}
		
		public function writeValue(value:*, withTag:Boolean = true):void
		{
			
			if (value is KTypeData)
			{
				
				var ktData:KTypeData = value as KTypeData;
				
				switch(ktData.type)
				{
					
					case KDataFormat.BYTE:
						return writeByte(ktData.value, withTag);
						
					case KDataFormat.UINT:
						return writeUint(ktData.value, withTag);
						
					case KDataFormat.INT:
						return writeInt(ktData.value, withTag);
						
					case KDataFormat.NUMBER:
						return writeDouble(ktData.value, withTag);
						
					case KDataFormat.BOOLEAN:
						return writeBoolean(ktData.value, withTag);
						
					case KDataFormat.STRING:
						return writeString(ktData.value, withTag);
						
					case KDataFormat.BINARY:
						return writeBinary(ktData.value, withTag);
						
					case KDataFormat.DATE:
						return writeDate(ktData.value, withTag);
						
					case KDataFormat.TABLE:
						return writeTable(ktData.value, withTag);
						
					case KDataFormat.TYPEOBJECT:
						return writeTypeObject(ktData.value, withTag);
						
					case KDataFormat.TYPEARRAY:
						return writeTypeArray(ktData.value, withTag);
						
					case KDataFormat.ARRAY:
						return writeArray(ktData.value, withTag);
						
					case KDataFormat.OBJECT:
						return writeObject(ktData.value, withTag);
						
				}
				
			}
			else
			{
				
				if (value is uint)
				
				return writeUint(value, withTag);
				
				else if (value is int)
				
				return writeInt(value, withTag);
				
				else if (value is Number)
				
				return writeDouble(value, withTag);
				
				else if (value is Boolean)
				
				return writeBoolean(value, withTag);
				
				else if (value is String)
				
				return writeString(value, withTag);
				
				else if (value is ByteArray)
				
				return writeBinary(value, withTag);
				
				else if (value is Date)
				
				return writeDate(value, withTag);
				
				else if (value is KTable)
				
				return writeTable(value, withTag);
				
				else if (value is KTypeObject)
				
				return writeTypeObject(value, withTag);
				
				else if (value is KTypeArray)
				
				return writeTypeArray(value, withTag);
				
				else if (value is Array)
				
				return writeArray(value, withTag);
				
				else if (value is Object)
				
				return writeObject(value, withTag);
				
			}
			
			throw new Error("数据为空或无效的数据类型！");
			
		}
		
		//public function readValue(type:int = KDataFormat.NONE):*
		public function readValue(type:int = 0):*
		{
			
			if (type == KDataFormat.NONE)
			{
				type = _data.readByte();
			}
			
			switch(type)
			{
				
				case KDataFormat.BYTE:
					return readByte(false);
					
				case KDataFormat.UINT:
					return readUint(false);
					
				case KDataFormat.INT:
					return readInt(false);
					
				case KDataFormat.NUMBER:
					return readDouble(false);
					
				case KDataFormat.BOOLEAN:
					return readBoolean(false);
					
				case KDataFormat.STRING:
					return readString(false);
					
				case KDataFormat.BINARY:
					return readBinary(false);
					
				case KDataFormat.DATE:
					return readDate(false);
					
				case KDataFormat.TABLE:
					return readTable(false);
					
				case KDataFormat.TYPEOBJECT:
					return readTypeObject(false);
					
				case KDataFormat.TYPEARRAY:
					return readTypeArray(false);
					
				case KDataFormat.ARRAY:
					return readArray(false);
					
				case KDataFormat.OBJECT:
					return readObject(false);
					
			}
			
			throw new Error("无效的数据类型:" + type);
			
		}
		
	}

}