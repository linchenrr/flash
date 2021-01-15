package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import org.superkaka.kakalib.manager.BitmapFrameInfoManager;
	import org.superkaka.kakalib.utils.BitmapCacher;
	import org.superkaka.kakalib.view.BitmapMovieClip;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 * 位图缓存_多显示对象移动
	 */
	public class Demo5 extends Sprite
	{
		var mainContainer:Sprite
		var arr_child:Array = [];
		private var w:int;
		private var h:int;
		private const r:int = 60;
		
		public function Demo5():void 
		{
			w = stage.stageWidth;
			h = stage.stageHeight;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			mainContainer = new Sprite();
			
			addChild(mainContainer);
			
			cacheBitmapMC();
			
			initBitmapChilds(1000);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * 预先缓存好位图动画
		 */
		private function cacheBitmapMC():void
		{
			var i:int = 0;
			while (i < DemoConfig.ItemTypeNumber)
			{
				var cls:Class = getDefinitionByName(DemoConfig.ItemLinkPrefix +i) as Class;
				var mc:MovieClip = new cls();
				
				BitmapFrameInfoManager.storeBitmapFrameInfo(String(i), BitmapCacher.cacheBitmapMovie(mc));
				
				//========不透明优化========
				//BitmapFrameInfoManager.storeBitmapFrameInfo(String(i), BitmapCacher.cacheBitmapMovie(mc, false, 0xffffffff));
				i++;
			}
		}
		
		function initBitmapChilds(num:int):void
		{
			for (var i:int = 0; i < num; i++)
			{
				var child:VBitmapMovieClip = new VBitmapMovieClip(BitmapFrameInfoManager.getBitmapFrameInfo(String(Math.random() * DemoConfig.ItemTypeNumber ^ 0)));
				child.vx = Math.random() * 8 - 4;
				child.vy = Math.random() * 8 - 4;
				child.x = Math.random() * w;
				child.y = Math.random() * h;
				arr_child.push(child); 
				mainContainer.addChild(child);
				
				//=========鼠标优化========
				//child.nextFrame();
				//child.stop();
				mainContainer.mouseChildren = false;
				mainContainer.mouseEnabled = false;
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
				var child:VBitmapMovieClip = arr_child[i];
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
		
	}

}