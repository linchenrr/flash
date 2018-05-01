package org.superkaka.KLib.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.superkaka.KLib.common.expression.KTableExpression;
	import org.superkaka.KLib.utils.ArrayUtil;
	import org.superkaka.KLib.utils.Cloner;
	import org.superkaka.KLib.utils.ObjectUtil;
	
	/**
	 * 数据表
	 * @author ｋａｋａ
	 */
	public class KTable extends EventDispatcher
	{
		
		/**
		 * 表头
		 */
		private var _header:Array;
		
		/**
		 * 表
		 */
		private var table:Object;
		
		/**
		 * 主键
		 */
		private var _primaryKey:String;
		
		/**
		 * 主键索引
		 */
		private var _primaryKeyIndex:int = -1;
		
		/**
		 * 创建一个KTable
		 * @param	header					字段名数组
		 * @param	primaryKey				表的主键，传入数字则使用header中相应索引的值作为主键，传入字符串则该字符串即为表的主键。如果省略此参数则默认使用header的第一项作为主键。
		 */
		public function KTable(header:Array, primaryKey:*= null):void
		{
			
			table = new Object();
			
			_header = header;
			
			var list_sameField:Array = ArrayUtil.searchSameElement(header);
			if (list_sameField.length != 0) throw new Error("不允许重复的字段名:" + list_sameField);
			
			if (primaryKey == null) primaryKey = 0;
			
			if (primaryKey is int) 
			{
				_primaryKeyIndex = primaryKey;
				this._primaryKey = header[_primaryKeyIndex];
			}
			else if (primaryKey is String)
			{
				
				this._primaryKey = primaryKey;
				
				var i:int = 0;
				var c:int = header.length;
				
				while (i < c) 
				{
					
					if (primaryKey == header[i])
					{
						_primaryKeyIndex = i;
						break;
					}
					
					i++;
					
				}
				
			}
			else
			{
				throw new Error("无效的主键参数类型");
			}
			
			if (header[_primaryKeyIndex] == null) throw new Error("不存在主键字段索引:" + _primaryKeyIndex);
			
		}
		
		/**
		 * 查询数据
		 * @param	expressions		查询表达式
		 * @param	rankKey				一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @return							符合条件的数据数组
		 */
		public function Select(expressions:Array = null, rankKey:Object = null):Array
		{
			
			return doSelect(expressions, rankKey);
			
		}
		
		/**
		 * 查询数据(内部方法，返回数据的源对象，用于直接操作源数据)
		 * @param	expressions		查询表达式
		 * @param	rankKey				一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @return							符合条件的数据数组
		 */
		private function doSelect(expressions:Array = null, rankKey:Object = null):Array
		{
			
			//深复制避免改变外部参数引起bug
			if (null != expressions)
			expressions = Cloner.deepClone(expressions);
			
			var list_data:Array = [];
			
			var data:Object;
			
			if (expressions == null || expressions.length < 3)
			{
				
				for each(data in table)
				{
					
					list_data.push(data);
					
				}
				
			}
			else
			{
				
				var kExpression:KTableExpression = translateExpression(expressions);
				
				for each(data in table)
				{
					
					kExpression.relatedData = data;
					
					if (kExpression.calculate())
					{
						list_data.push(data);
					}
					
				}
				
			}
			
			
			if (rankKey == null) rankKey = [_primaryKey];
			
			list_data.sortOn(rankKey, Array.NUMERIC);
			
			return list_data;
			
		}
		
		/**
		 * 使用自定义筛选器查询数据
		 * @param	selecter		自定义的数据筛选函数，需要实现(data:Object)的参数签名并返回布尔值指示该条数据是否符合筛选条件
		 * @param	rankKey		一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @return					符合条件的数据数组
		 */
		public function SelectC(selecter:Function, rankKey:Object = null):Array
		{
			
			var list_data:Array = [];
			var data:Object;
			
			for each(data in table)
			{
				
				if (selecter(data))
				{
					list_data.push(data);
				}
				
			}
			
			if (rankKey == null) rankKey = [_primaryKey];
			
			list_data.sortOn(rankKey, Array.NUMERIC);
			
			return list_data;
			
		}
		
		/**
		 * 添加数据
		 * @param	...data
		 */
		public function Insert(...data):void
		{
			
			var i:int = 0;
			var c:int = data.length;
			
			while (i < c) 
			{
				
				doInsert(data[i]);
				
				i++;
				
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		/**
		 * 添加数据
		 * @param	data					数据
		 */
		private function doInsert(data:*):void
		{
			
			//如果插入的数据是数组则按照表头顺序建立数据值
			if (data is Array)
			{
				
				var dataArr:Array = data as Array;
				data = { };
				var i:int = 0;
				var c:int = _header.length;
				
				while (i < c) 
				{
					
					data[_header[i]] = dataArr[i];
					
					i++;
					
				}
				
			}
			else
			{
				
				data = Cloner.deepClone(data);
				
			}
			
			var key:String = data[_primaryKey];
			if (key == null) throw new Error("数据缺少主键");
			if (getValue(key) != null) throw new Error("已存在的主键:" + key);
			
			table[key] = data;
			
		}
		
		/**
		 * 更新表数据
		 * @param	expressions		查询表达式
		 * @param	values				以键/值对方式表示的需要更新数据的部分
		 * @return							更新的行数
		 */
		public function Update(expressions:Array, values:Object):int
		{
			
			for (var key:String in values)
			{
				if (_header.indexOf(key) == -1)
				{
					throw new Error("尝试更新的键值非法:" + key);
				}
			}
			
			var list_data:Array = doSelect(expressions);
			
			for each(var data:Object in list_data)
			{
				
				for (key in values)
				{
					
					data[key] = values[key];
					
				}
				
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
			return list_data.length;
			
		}
		
		/**
		 * 删除数据
		 * @param	expressions		查询表达式
		 * @return							删除的行数
		 */
		public function Delete(expressions:Array):int
		{
			
			var list_data:Array = doSelect(expressions);
			
			for each(var data:Object in list_data)
			{
				
				var primaryValue:String = data[_primaryKey];
				table[primaryValue] = null;
				delete table[primaryValue];
				
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
			return list_data.length;
			
		}
		
		/**
		 * 将表达式数组转换为表达式对象
		 * @param	expression
		 * @return
		 */
		private function translateExpression(expressions:Array):KTableExpression
		{
			
			if (expressions.length < 3) 
			{
				
				//if (expressions[0] is Array) return translateExpression(expressions[0]);
				//else if (expressions[0] is KTableExpression) return expressions[0];
				
				throw new Error("无效的表达式长度:" + expressions.length);
				
			}
			
			while (expressions.length > 1)
			{
				
				var valueA:*= expressions[0];
				var op:String = expressions[1];
				var valueB:*= expressions[2];
				
				if (op == "&&" || op == "and" || op == "||" || op == "or")
				{
					
					if (valueA is Array) valueA = translateExpression(valueA);
					if (valueB is Array) valueB = translateExpression(valueB);
					
				}
				
				expressions.splice(0, 3, new KTableExpression(valueA, op, valueB));
				
			}
			
			return expressions[0];
			
		}
		
		
		/**
		 * 根据主键值获取数据
		 * @param	primaryValue		主键值
		 * @return
		 */
		public function getValue(primaryValue:String):*
		{
			
			return table[primaryValue];
			
		}
		
		/**
		 * 获取主键名
		 */
		public function get primaryKey():String 
		{
			return _primaryKey;
		}
		
		/**
		 * 表头
		 */
		public function get header():Array 
		{
			return _header.concat();
		}
		
		/**
		 * 获取主键索引
		 */
		public function get primaryKeyIndex():int 
		{
			return _primaryKeyIndex;
		}
		
		/**
		 * 复制表
		 * @return
		 */
		public function clone():KTable
		{
			
			var newTable:KTable = new KTable(_header, _primaryKey);
			
			newTable.table = getDataHashTable();
			
			return newTable;
			
		}
		
		/**
		 * 以键/值对形势返回表内部的数据集副本
		 */
		public function getDataHashTable():Object
		{
			
			return Cloner.deepClone(table);
			
		}
		
		/**
		 * 将其它表的字段关联到当前表
		 * @param	field					关联时使用的映射字段
		 * @param	sourceTB			作为数据源的表
		 */
		public function relateTable(field:String, sourceTB:*):void
		{
			
			var sourceTable:KTable;
			
			if (sourceTB is String)
			{
				sourceTable = getTable(String(sourceTB));
			}
			else
			{
				sourceTable = sourceTB as KTable;
			}
			
			var newHeader:Array = sourceTable.header;
			newHeader.shift();
			newHeader = _header.concat(newHeader);
			
			//var list_sameField:Array = ArrayUtil.searchSameElement(newHeader);
			//if (list_sameField.length != 0) throw new Error("不允许重复的字段名:" + list_sameField);
			
			_header = newHeader;
			
			for each(var data:Object in table)
			{
				
				var relateData:Object = sourceTable.table[data[field]];
				
				//ObjectUtil.copyTo(relateData, data);
				if (relateData == null)
				continue;
				
				for (var key:String in relateData)
				{
					if (data[key] == null)
					data[key] = relateData[key];
					
				}
			}
			
		}
		
		/**
		 * 对指定字段的数据进行转换操作
		 * @param	field								要转换的字段
		 * @param	transformFunction			要对字段中的每一项运行的转换函数。此函数需要一个实现参数来接收源数据，并返回转换后的新数据
		 */
		public function transformField(field:String, transformFunction:Function):void
		{
			
			for each(var data:Object in table)
			{
				
				data[field] = transformFunction(data[field]);
				
			}
			
		}
		
		
		//=================静态管理===============
		
		
		static private var dic_table:Object = new Object();
		
		/**
		 * 获取字典表
		 * @param	tableId				表id
		 * @return
		 */
		static public function getTable(tableId:String):KTable
		{
			
			return dic_table[tableId];
			
		}
		
		/**
		 * 内部获取字典表方法，如果不存在则抛出异常
		 * @param	tableId				表id
		 * @return
		 */
		static public function tryGetTable(tableId:String):KTable
		{
			
			var table:KTable = dic_table[tableId];
			if (null == table) throw new Error("不存在的表:" + tableId);
			
			return table;
			
		}
		
		/**
		 * 创建并返回字典表
		 * @param	tableId				表id
		 * @param	header				表头字段数组
		 * @param	primaryKey			表主键
		 * @return
		 */
		static public function createTable(tableId:String, header:Array, primaryKey:*= null):KTable
		{
			
			var table:KTable = new KTable(header, primaryKey);
			
			addTable(tableId, table);
			
			return table;
			
		}
		
		/**
		 * 添加字典表并返回字典表
		 * @param	tableId				表id
		 * @param	table					字典表对象
		 */
		static public function addTable(tableId:String, table:KTable):KTable
		{
			
			if (hasTable(tableId)) throw new Error("表" + tableId + "已存在");
			
			dic_table[tableId] = table;
			
			return table;
			
		}
		
		/**
		 * 删除字典表
		 * @param	tableId				表id
		 */
		static public function deleteTable(tableId:String):void
		{
			
			dic_table[tableId] = null;
			
			delete dic_table[tableId];
			
		}
		
		
		/**
		 * 是否存在字典表
		 * @param	tableId				表id
		 */
		static public function hasTable(tableId:String):Boolean
		{
			
			return dic_table[tableId] != null;
			
		}
		
		/**
		 * 根据主键值获取数据
		 * @param	tableId				表id
		 * @param	primaryValue		主键值
		 * @return
		 */
		static public function getValue(tableId:String, primaryValue:String):*
		{
			
			return tryGetTable(tableId).getValue(primaryValue);
			
		}
		
		/**
		 * 查询数据
		 * @param	tableId				表id
		 * @param	expressions		查询表达式
		 * @param	rankKey				一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @return							符合条件的数据数组
		 */
		static public function Select(tableId:String, expressions:Array = null, rankKey:Object = null):Array
		{
			
			return tryGetTable(tableId).Select(expressions, rankKey);
			
		}
		
		/**
		 * 使用自定义筛选器查询数据
		 * @param	tableId		表id
		 * @param	selecter		自定义的数据筛选函数，需要实现(data:Object)的参数签名并返回布尔值指示该条数据是否符合筛选条件
		 * @param	rankKey		一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @return					符合条件的数据数组
		 */
		static public function SelectC(tableId:String, selecter:Function, rankKey:Object = null):Array
		{
			
			return tryGetTable(tableId).SelectC(selecter, rankKey);
			
		}
		
		/**
		 * 添加数据
		 * @param	tableId				表id
		 * @param	...data
		 */
		static public function Insert(tableId:String, ...data):void
		{
			
			tryGetTable(tableId).Insert.apply(null, data);
			
		}
		
		/**
		 * 更新表数据
		 * @param	tableId				表id
		 * @param	expressions		查询表达式
		 * @param	values				以键/值对方式表示的需要更新数据的部分
		 * @return							更新的行数
		 */
		static public function Update(tableId:String, expressions:Array, values:Object):int
		{
			
			return tryGetTable(tableId).Update(expressions, values);
			
		}
		
		/**
		 * 删除数据
		 * @param	tableId				表id
		 * @param	expressions		查询表达式
		 * @return							删除的行数
		 */
		static public function Delete(tableId:String, expressions:Array):int
		{
			
			return tryGetTable(tableId).Delete(expressions);
			
		}
		
	}

}