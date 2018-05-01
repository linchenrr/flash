package
{
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.utils.ArrayUtil;
	import org.superkaka.kakalib.utils.splitNumber;
	import org.superkaka.kakalib.view.loading.ILoading;
	
	public class AnyTest extends Sprite
	{
		public function AnyTest():void
		{
			
			var arr:Array = [];
			
			var i:int = 0;
			while (i < 10000)
			{
				arr[i] = (Math.random() * 1000000^0);
				i++;
			}
			
			var t:Number = getTimer();
			//ArrayUtil.bsort(arr);
			//ArrayUtil.qsort(arr, 0, arr.length - 1);
			//arr.sort(Array.NUMERIC);
			trace(getTimer() - t);
			
			var v:Vector.<Sprite>=new Vector.<Sprite>();
			var xml:XML=describeType(this);
			//trace(xml);
		}
	}
}