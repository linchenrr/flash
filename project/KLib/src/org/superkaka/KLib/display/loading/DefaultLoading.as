package org.superkaka.KLib.display.loading 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * 框架默认loading
	 * @author ｋａｋａ
	 */
	public class DefaultLoading extends Loading
	{
		
		protected var txt_pec:TextField;
		protected var txt_msg:TextField;
		protected var mc_progress:MovieClip;
		
		public function DefaultLoading():void
		{
			
		}
		
		override protected function onContentReady():void
		{
			
			mc_progress = _content["mc_progress"];
			txt_pec = _content["txt_pec"];
			txt_msg = _content["txt_msg"];
			
			mc_progress.gotoAndStop(1);
			txt_pec.text = "0%";
			
		}
		
		override protected function onProgressChanged(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void
		{
			
			var pec:uint = uint((bytesLoaded / bytesTotal) * 100);
			
			mc_progress.gotoAndStop(pec);
			txt_pec.text = pec + "%";
			
			if (null != customData)
			{
				txt_msg.text = String(customData);
			}
			
		}
		
	}

}