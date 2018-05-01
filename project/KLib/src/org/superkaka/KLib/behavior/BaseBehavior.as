package org.superkaka.KLib.behavior 
{
	import flash.events.IEventDispatcher;
	/**
	 * 行为基类
	 * @author ｋａｋａ
	 */
	public class BaseBehavior 
	{
		
		protected var target:IEventDispatcher;
		
		public function BaseBehavior(target:IEventDispatcher, autoStart:Boolean = true):void
		{
			
			this.target = target;
			
			init();
			
			if (autoStart)
			start();
		}
		
		protected function init():void
		{
			
		}
		
		public function start():void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
	}

}