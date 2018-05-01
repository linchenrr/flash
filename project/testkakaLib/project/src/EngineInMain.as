package  
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import org.superkaka.kakalib.core.Engine;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class EngineInMain extends Sprite
	{
		
		//private var main:Engine;
		
		private var load1:Loader = new Loader();
		private var load2:Loader = new Loader();
		
		public function EngineInMain():void
		{
			
			//main = new testlc();
			//addChild(main);
			
			
			
			load1.name = "load1";
			load2.name = "load2";
			
			load1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, prg);
			load2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, prg);
			
			var url:String = "http://postimg1.mop.com//2011/07/16/13107801913046601.jpg";
			
			load1.load(new URLRequest(url));
			load2.load(new URLRequest(url));
			
		}
		
		private function prg(evt:ProgressEvent):void
		{
			
			trace((evt.currentTarget as LoaderInfo).loader.name, evt.bytesLoaded, getTimer());
			
		}
		
	}

}