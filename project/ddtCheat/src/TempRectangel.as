package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TempRectangel extends UIComponent
	{
		private var dect:Sprite;
		private var receiver:DistancePanel;
		private var lb_map:Label;
		
		[Embed(source="stuff/Arrow.png")]
		private var cls_Arrow:Class; 
		
		public function TempRectangel(receiver:DistancePanel,lb_map:Label):void
		{
			this.receiver=receiver;
			this.lb_map=lb_map;
			
			dect = new Sprite();
			addChild(dect);
			
			this.buttonMode = true;
			
			drawSelf();
			initControl();
		}
		
		private function initControl():void
		{
			dect.addEventListener(MouseEvent.MOUSE_DOWN, md);
		}
		
		private function drawSelf():void
		{
			var gr:Graphics = dect.graphics;
			gr.beginFill(0x669966, 0.2);
			gr.drawRect(50, 0, 20, 40);
			gr.endFill();
			gr.beginFill(0, 0.1);
			gr.drawRect(0, 0, 50, 40);
			gr.endFill();
			
			gr.lineStyle(1, 0xffffff);
			gr.drawRect(0, 0, 70, 40);
		}
		
		private function md(evt:MouseEvent):void
		{
			if (dect.mouseX >= 50)
			{
				CursorManager.setCursor(cls_Arrow,2,-16,-8);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mm);
				stage.addEventListener(MouseEvent.MOUSE_UP, mp);
				
			}
			else
			{
				dect.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, mp2);
			}
			
		}
		
		private function mp2(evt:MouseEvent):void
		{
			dect.stopDrag();
		}
		
		private function mm(evt:MouseEvent):void
		{
			var w:Number = this.mouseX - dect.x;
			if (w > 30)
			{
				dect.width = w;
			}
		}
		
		private function mp(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mm);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mp);
			
			CursorManager.removeCursor(CursorManager.currentCursorID);
			
			receiver.spaceX=dect.width;
			lb_map.text="自定义 "+dect.width;
			
			dect.addEventListener(MouseEvent.MOUSE_DOWN, md);
		}
	}
	
}