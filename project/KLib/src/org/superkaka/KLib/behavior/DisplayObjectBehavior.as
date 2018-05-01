package org.superkaka.KLib.behavior 
{
	import flash.display.DisplayObject;
	/**
	 * 控制显示对象的行为基类
	 * @author ｋａｋａ
	 */
	public class DisplayObjectBehavior extends BaseBehavior
	{
		
		protected var displayObject:DisplayObject;
		
		public function DisplayObjectBehavior(displayObject:DisplayObject, autoStart:Boolean = true):void
		{
			
			this.displayObject = displayObject;
			
			super(displayObject, autoStart);
			
			
		}
		
	}

}