package org.superkaka.KLib.utils 
{
	/**
	 * 事件监听函数封装
	 * 好像容易造成监听器无法回收，内存泄露  不建议使用
	 * target.addEventListener(Event.COMPLETE, wrapper(eventHandler, "参数1", 0, 1 , 2 , 3, bmp));
	 * @author ｋａｋａ
	 */
	public function wrapperEventHandler(func:Function, ...args):Function
	{
		return function(...args2):*
		{
			
			//此处对于类绑定方法无需thisObject,其他情况需另考虑；
			
			return func.apply(null,  args2.concat(args));
			
		}
	}

}