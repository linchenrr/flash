package 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.flash.UIMovieClip;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class DistancePanel extends UIMovieClip
	{
		private var colorPanel:Shape;
		private var w:int;
		private var h:int;
		
		private var dis_sp:Shape;
		
		///x轴1距离的像素值
		private var space_x:Number =0;
		
		
		///ctrl是否按下
		private var ctrlDown:Boolean = false;
		
		///攻击方坐标点
		private var point_me:Point;
		///目标坐标点
		private var point_target:Point;
		
		private var point_a:Point;
		private var point_b:Point;
		
		public function DistancePanel(w:int,h:int):void
		{
			this.w = w;
			this.h = h;
			
			point_a=new Point();
			point_b=new Point();
			
			dis_sp=new Shape();
			addChild(dis_sp);
			
			colorPanel = new Shape();
			drawBG(w, h);
			addChild(colorPanel);
			
			if (stage)
			{
				init();
			}			
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			}
		}
		
		///添加到舞台
		private function addToStageHandler(evt:Event):void
		{
			init();
		}
		
		///初始化
		private function init():void
		{
			configListeners();
		}
		
		///初始化侦听器
		private function configListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		///设置x间距
		public function set spaceX(value:Number):void
		{
			if(value<0)return;
			this.space_x=value/10;
			updateCount();
		}
		
		public function get spaceX():Number
		{
			return this.space_x*10;
		}
		
		///更新绘制点
		private function updatePointView():void
		{
			var gr:Graphics = this.graphics;
			gr.clear();
			if(point_me)
			{
				gr.lineStyle(0.8,0);
				gr.beginFill(0xf96538, 0.8);
				gr.drawCircle(point_me.x,point_me.y,3);
				gr.endFill();
			}
			
			if(point_target)
			{
				gr.lineStyle(0.8,0);
				gr.beginFill(0xbe1df9, 0.8);
				gr.drawCircle(point_target.x,point_target.y,3);
				gr.endFill();
			}
			
		}
		
		///更新小框
		private function updateRectView():void
		{
			var gr:Graphics=dis_sp.graphics;
			gr.clear();
			
			if(point_a.x>=point_b.x)return;
			
			var h:Number=point_b.y-point_a.y;
			if(h<30)h=30;
			
			gr.clear();
			gr.lineStyle(1,0xffffff);
			gr.beginFill(0,0.07);
			gr.drawRect(point_a.x,point_a.y,point_b.x-point_a.x,h);
			gr.endFill();
			
			dispatchEvent(new MapInfoEvent(MapInfoEvent.Info_Change,dis_sp.width));
		}
		
		///计算距离
		private function updateCount():void
		{
			if (point_me && point_target)
			{
				///x轴距离
				var dx:Number;
				///y轴距离
				var dy:Number;
				
				var dis_X:int;
				
				var dis_Y:int;
				
				var offsetX:Number;
				var offsetY:Number;
				
				
				dx = point_me.x - point_target.x;
				dy = point_me.y - point_target.y;
				
				var direction:Boolean = dx < 0;
				
				if(direction)
				{
					dx = -dx;
				}
				
				dx = dx / space_x;
				
				dis_X = int(dx);
				offsetX = dx - dis_X;
				
				//dis_X = Math.abs(dis_X);
				
				//dis_X = Math.round(dis_X / space_x);
				
				//var point:Number=dis_X%space_x;
				
				//dis_X = int(Math.abs(dis_X / space_x));
				
				
				/*
				if(point>space_x*0.9)
				{
					dis_X++;
				}
				*/
				dispatchEvent(new DistanceEvent(DistanceEvent.DIS_UPDATE, direction,new Distance(dis_X,offsetX)));
			}
		}
		
		///重新计算
		private function updateData():void
		{
			updateCount();
			
			updatePointView();
		}
		
		///鼠标按下
		private function mouseDownHandler(evt:MouseEvent):void
		{
			point_target=new Point(evt.localX, evt.localY);
			evt.stopPropagation();
			updateData();
		}
		
		///鼠标右键按下
		private function rightClickHandler(evt:MouseEvent):void
		{
			
			point_me = new Point(evt.localX, evt.localY);
			evt.stopPropagation();
			updateData();
		}
		
		///键盘按下
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			ctrlDown = evt.ctrlKey;
		}
		
		///键盘弹起
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			ctrlDown = evt.ctrlKey;
		}
		
		///绘制背景
		private function drawBG(w:int,h:int):void
		{
			var gr:Graphics = colorPanel.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0x6565FF, 0.03);
			gr.drawRect(0, 0, w, h);
			gr.endFill();
		}
		
		public function changeMode(mode:Boolean):void
		{
			var gr:Graphics=dis_sp.graphics;
			gr.clear();
			
			this.graphics.clear();
			
			if(mode)
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler);
				
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler_dis);
//				this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler_dis);
				
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler_dis);
				this.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler_dis);
				
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
//				this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler);
				
				updateData();
			}
		}
		
		private var downX:Number;
		private var downY:Number;
		private function mouseDownHandler_dis(evt:MouseEvent):void
		{
			evt.stopPropagation();
			
			var gr:Graphics=dis_sp.graphics;
			gr.clear();
			
			downX=this.mouseX;
			downY=this.mouseY;
			//trace(downX,downY)
			stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			
//			point_a.x=evt.localX;
//			point_a.y=evt.localY;
//			
//			updateRectView();
		}
		
		private function rightClickHandler_dis(evt:MouseEvent):void
		{
			point_b.x=evt.localX;
			point_b.y=evt.localY;
			
			updateRectView();
		}
		
		private function stageMouseMoveHandler(evt:MouseEvent):void
		{
			var gr:Graphics=dis_sp.graphics;
			gr.clear();
			gr.lineStyle(1,0xffffff);
			gr.beginFill(0,0.07);
			gr.drawRect(downX,downY,this.mouseX-downX,this.mouseY-downY);
			gr.endFill();
			
			//trace("downX,downY,this.mouseX,this.mouseY",downX,downY,this.mouseX,this.mouseY);
		}
		
		private function stageMouseUpHandler(evt:MouseEvent):void
		{
			//trace(dis_sp.width)
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			
			var dis:Number=dis_sp.width;
			
			if(dis>20)
			{
				dispatchEvent(new MapInfoEvent(MapInfoEvent.Info_Change,dis));
			}
			else
			{
				var gr:Graphics=dis_sp.graphics;
				gr.clear();
			}
			
		}
		
	}
	
}