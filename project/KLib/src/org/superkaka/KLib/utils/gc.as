package org.superkaka.KLib.utils 
{
	/**
	 * @author ｋａｋａ
	 */
	
	/**
	 * 执行系统垃圾回收
	 */
	public function gc():void
	{
		
		SystemGC.doGC();
		
	}

}