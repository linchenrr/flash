package org.superkaka.KLib.common.expression 
{
	/**
	 * 数据表查询表达式
	 * @author ｋａｋａ
	 */
	public class KTableExpression extends ConditionExpression
	{
		
		/**
		 * 字段名标示前缀
		 */
		static public var prefix:String = "{";
		
		/**
		 * 字段名标示后缀
		 */
		static public var suffix:String = "}";
		
		/**
		 * 关联数据
		 */
		private var _relatedData:Object;
		
		private var keyA:*;
		private var keyB:*;
		
		public function KTableExpression(valueA:*= null, operator:String = null, valueB:*= null):void
		{
			
			super(valueA, operator, valueB);
			
		}
		
		override public function set valueA(value:*):void 
		{
			keyA = value;
			_valueA = getRelatedValue(value);
		}
		
		override public function set valueB(value:*):void 
		{
			keyB = value;
			_valueB = getRelatedValue(value);
		}
		
		/**
		 * 关联数据
		 */
		public function get relatedData():Object 
		{
			return _relatedData;
		}
		
		/**
		 * 关联数据
		 */
		public function set relatedData(value:Object):void 
		{
			
			_relatedData = value;
			
			_valueA = getRelatedValue(keyA);
			_valueB = getRelatedValue(keyB);
			
			if (_valueA is KTableExpression) (_valueA as KTableExpression).relatedData = value;
			if (_valueB is KTableExpression) (_valueB as KTableExpression).relatedData = value;
			
		}
		
		/**
		 * 获取字段名相应的值
		 * @param	value
		 * @return
		 */
		private function getRelatedValue(value:*):*
		{
			
			if (relatedData == null) return value;
			
			var keyName:String = toKeyName(value);
			if (keyName != null)
			{
				
				return relatedData[keyName];
				
			}
			
			return value;
			
		}
		
		/**
		 * 判断传入的参数是否是字段名
		 * @param	value
		 * @return
		 */
		static public function isKeyName(value:*):Boolean
		{
			
			if (!(value is String)) return false;
			
			var keyName:String = value as String;
			
			if (keyName.charAt(0) == prefix && keyName.charAt(keyName.length - 1) == suffix) return true;
			
			return false;
			
		}
		
		/**
		 * 将传入的参数去除前后缀，转换为实际字段名
		 * @param	value
		 * @return
		 */
		static public function toKeyName(value:*):String
		{
			
			if (isKeyName(value))
			{
				
				var str:String = String(value);
				return str.substring(prefix.length, str.length - suffix.length);
				
			}
			
			return null;
			
		}
		
	}

}