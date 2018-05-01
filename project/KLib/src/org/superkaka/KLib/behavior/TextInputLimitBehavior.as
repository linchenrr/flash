package org.superkaka.KLib.behavior 
{
	import flash.events.Event;
	import flash.text.TextField;
	import org.superkaka.KLib.utils.StringTool;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TextInputLimitBehavior extends DisplayObjectBehavior
	{
		
		protected var txt:TextField;
		
		protected var limit:int;
		
		public function TextInputLimitBehavior(txt:TextField, limit:int):void
		{
			
			super(txt);
			
			this.limit = limit;
			
		}
		
		override protected function init():void
		{
			
			txt = displayObject as TextField;
			
		}
		
		override public function start():void
		{
			txt.addEventListener(Event.CHANGE, inputHandler);
		}
		
		override public function stop():void
		{
			txt.removeEventListener(Event.CHANGE, inputHandler);
		}
		
		private function inputHandler(evt:Event):void
		{
			
			var newStr:String = txt.text;
			
			if (StringTool.getStringCharLength(newStr) > limit)
			{
				
				while (StringTool.getStringCharLength(newStr) > limit)
				{
					newStr = newStr.substring(0, newStr.length - 1);
				}
				
				txt.text = newStr;
				
			}
			
		}
		
	}

}