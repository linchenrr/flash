package org.superkaka.KLib.utils 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-30-星期五 17:25
	 */
	
	public function getFuncitonCost(fun:Function,...args):Array
	{
		
		var t:int = getTimer();
		
		var result:*= fun.apply(null, args);
		
		return [getTimer() - t, result];
		
	}

}
