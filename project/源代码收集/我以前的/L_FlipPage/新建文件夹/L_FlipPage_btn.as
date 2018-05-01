package L_FlipPage
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_btn extends Sprite 
	{
		public var position:uint;
		public var is_left:Boolean;
		public var is_up:Boolean;
		public function L_FlipPage_btn(i:uint, w:uint = 50, h:uint = 50):void
		{
			init(i,w, h);
		}
		private function init(i:uint,w:uint,h:uint):void
		{			
			position = i;
			draw_btn(w, h);
			
			this.buttonMode = true;
		}
		public function draw_btn(w:uint, h:uint):void
		{
			var gr:Graphics = this.graphics;
			gr.clear();
			gr.beginFill(0x8CB1FF,0.3);
			gr.moveTo(0, 0);
			gr.lineTo(w, 0);
			gr.lineTo(w, h);
			gr.lineTo(0, h);
			gr.lineTo(0, 0);
			gr.endFill();
		}
	}
	
}