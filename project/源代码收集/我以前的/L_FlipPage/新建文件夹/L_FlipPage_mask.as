package L_FlipPage
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_mask extends Sprite
	{
		public function L_FlipPage_mask():void
		{
			init();
		}
		private function init():void
		{
			
		}
		
		public function mask_draw(o:Object):void
		{
			var ox:Array = o.x;
			var oy:Array = o.y;
			
			var gr:Graphics = this.graphics;
			gr.clear();			
			gr.beginFill(0);			
			gr.moveTo(ox[0], oy[0]);
			var c:uint = ox.length;
			for (var i:uint = 1; i < c; i++)
			{
				gr.lineTo(ox[i], oy[i]);
			}
			gr.lineTo(ox[0], oy[0]);
			gr.endFill();
		}
		
		public function mask_clear():void
		{
			var gr:Graphics = this.graphics;
			gr.clear();
		}		
	}
	
}