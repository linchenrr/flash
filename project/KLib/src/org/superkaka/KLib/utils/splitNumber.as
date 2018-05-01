package org.superkaka.KLib.utils 
{
	
	public function splitNumber(source:*, minPos:int = 0):Array
	{
		var num:uint = uint(source);
		
		var arr_num:Array = String(num).split("");
		
		if (minPos > 0)
		{
			
			var addCount:int = minPos - arr_num.length;
			
			var i:int = 0;
			while (i < addCount)
			{
				arr_num.unshift("0");
				
				i++;
			}
			
		}
		
		return arr_num;
		
	}

}