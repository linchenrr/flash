package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class XmlLoader extends EventDispatcher
	{
		private var loader:URLLoader;
		private var url:String;
		private var receiver:MapChoosePanel;
		
		private var p:int=0;
		
		public function XmlLoader(receiver:MapChoosePanel):void
		{
			this.receiver = receiver;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
		}
		
		public function load(url:String):void
		{
			this.url=url;
			loader.load(new URLRequest(url))
		}
		
		private function loadCompleteHandler(evt:Event):void
		{
			trace("加载成功");
			p = 0;
			
			receiver.mapInfo = new XML(loader.data);
		}
		
		private function loadFailedHandler(evt:IOErrorEvent):void
		{
			if (p < 3)
			{
				p++;
				load(url);
			}
			else
			{
				p = 0;
				trace("加载失败！");
			}
		}
	}
	
}