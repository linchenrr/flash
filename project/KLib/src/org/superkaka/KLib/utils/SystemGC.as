package org.superkaka.KLib.utils 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * 内存回收
	 * @author ｋａｋａ
	 */
	internal class SystemGC
	{
		
		private static var gcing:Boolean;
        private static var loader:Loader = new Loader();
        private static var swfBytes:ByteArray = new ByteArray();
		
		init();
		static private function init():void
		{
			
			var swfHex:Array = [0x46, 0x57, 0x53, 0x09, 0x24, 0x00, 0x00, 0x00, 0x78, 0x00, 0x05, 0x5f, 0x00, 0x00, 0x0f, 0xa0, 0x00, 0x00, 0x0c, 0x01, 0x00, 0x44, 0x11, 0x08, 0x00, 0x00, 0x00, 0x43, 0x02, 0xff, 0xff, 0xff, 0x40, 0x00, 0x00, 0x00];
			
			var i:int = 0;
			var c:int = swfHex.length;
			while (i < c)
			{
				
				swfBytes.writeByte(swfHex[i]);
				
				i++;
			}
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
		}
		
		static public function doGC():void
		{
			
			if (gcing) return;
			
			gcing = true;
			loader.loadBytes(swfBytes);
			
		}
		
		static private function onComplete(evt:Event):void
		{
			
			loader.unloadAndStop();
			gcing = false;
			
		}
		
	}

}