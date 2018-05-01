package org.superkaka.KLib.utils 
{
	/**
	 * 计算器
	 * @author ｋａｋａ
	 */
	public class Calculator
	{
		
		public static function op(a:*,op:String,b:*):Boolean
		{
			switch(op)
			{
				case ">":return a > b;
				case ">=":return a >= b;
				case "=":
				case "==":
				return a == b;
				
				case "<=":return a <= b;
				case "<":return a < b;
				case "!=":return a != b;
				case "&&":
				case "and":
				return a && b;
				case "||":
				case "or":
				return a || b;
				
				//case "@":return a.indexOf(b)!=-1;
				//case "@<":return a.lastIndexOf(b)==(a.length-b.length)&&(a.length-b.length)!=-1;
				//case "@>":return a.indexOf(b)==0;
			}
			throw new Error("无效的运算符:" + op);
			return false;
		}
		
		public static function compute(a:*, op:String, b:*):*
		{
			if(a is String){b=String(b)}else{b=Number(b);}
			switch(op)
			{
				case "+":return a+b;
				case "-":return a-b;
				case "*":return a*b;
				case "/":return a/b;
				case "%":return a%b;
			}
			throw new Error("无效的运算符:" + op);
			return null;
		}
		
	}

}