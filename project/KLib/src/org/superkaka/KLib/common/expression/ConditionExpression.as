package org.superkaka.KLib.common.expression 
{
	import org.superkaka.KLib.utils.Calculator;
	/**
	 * 条件表达式
	 * @author ｋａｋａ
	 */
	public class ConditionExpression
	{
		
		protected var _valueA:*;
		
		public var operator:String;
		
		protected var _valueB:*;
		
		public function ConditionExpression(valueA:*= null, operator:String = null, valueB:*= null):void
		{
			
			this.valueA = valueA;
			this.operator = operator;
			this.valueB = valueB;
			
		}
		
		/**
		 * 计算表达式的结果
		 * @return
		 */
		public function calculate():Boolean
		{
			
			var vA:*= _valueA;
			var vB:*= _valueB;
			if (vA is ConditionExpression) vA = (vA as ConditionExpression).calculate();
			if (vB is ConditionExpression) vB = (vB as ConditionExpression).calculate();
			
			return Calculator.op(vA, operator, vB);
			
		}
		
		public function get valueA():* 
		{
			return _valueA;
		}
		
		public function set valueA(value:*):void 
		{
			_valueA = value;
		}
		
		public function get valueB():* 
		{
			return _valueB;
		}
		
		public function set valueB(value:*):void 
		{
			_valueB = value;
		}
	}

}