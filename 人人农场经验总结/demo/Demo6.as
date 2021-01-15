package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 大量子显示对象
	 */
	public class Demo6 extends Sprite
	{
		
		var container:Sprite;
		var arr_child:Array = [];
		private var w:int;
		private var h:int;
		private const r:int = 60;
		
		public function Demo6():void 
		{
			w = stage.stageWidth;
			h = stage.stageHeight;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			container = new Sprite();
			
			addChild(container);
			
			initBitmapChilds(100);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}
		
		function initBitmapChilds(num:int):void
		{
			for (var i:int = 0; i < num; i++)
			{
				var cls:Class = getDefinitionByName(DemoConfig.ItemLinkPrefix +String(Math.random() * DemoConfig.ItemTypeNumber ^ 0)) as Class;
				var child:MovieClip = new cls();
				
				//child.stop();
				
				child.vx = Math.random() * 8 - 4;
				child.vy = Math.random() * 8 - 4;
				child.x = Math.random() * DemoConfig.stageWidth - 50;
				child.y = Math.random() * DemoConfig.stageHeight - 50;
				arr_child.push(child);
				child.isItem = true;
				container.addChild(child);
				
				//=========鼠标优化========
				//container.mouseChildren = false;
				//container.mouseEnabled = false;
			}
		}
		
		function enterFrameHandler(evt:Event):void
		{
			var mx:int = w - r;
			var my:int = h - r;
			
			var i:int = 0;
			var c:int = arr_child.length;
			while (i < c)
			{
				var child:MovieClip = arr_child[i];
				var x:Number = child.x + child.vx;
				var y:Number = child.y + child.vy;
				
				if (x < 0)
				{
					x = 0;
					child.vx = -child.vx;
				}
				else
				if (x > mx)
				{
					x = mx;
					child.vx = -child.vx;
				}
				
				if (y < 0)
				{
					y = 0;
					child.vy = -child.vy;
				}
				else
				if (y > my)
				{
					y = my;
					child.vy = -child.vy;
				}
				
				child.x = x;
				child.y = y;
				
				i++;
			}
		}
		
		private var last_mc:MovieClip;
		protected function stageMouseDownHandler(evt:MouseEvent):void
		{
			if (null != last_mc) last_mc.filters = null;
			
			var arr_obj:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
			var mc:MovieClip = finditem(arr_obj[arr_obj.length - 1]);
			mc.filters = [new GlowFilter(0xFFF4A6, 0.1, 150, 150, 0.8, 1, true), new GlowFilter(0xFFF4A6, 0.9, 3, 3, 8, 3)];
			
			last_mc = mc;
		}
		
		function finditem(target:*):MovieClip
		{
			if (target is MovieClip && target.isItem)
			{
				return target;
			}
			else
			{
				return finditem(target.parent);
			}
		}
		
	}

}