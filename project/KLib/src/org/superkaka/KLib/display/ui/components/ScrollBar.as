package org.superkaka.KLib.display.ui.components 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 当数据太多以至于显示区域无法容纳时，最终用户可以使用 ScrollBar 组件控制所显示的数据部分。 滚动条由四部分组成：两个箭头按钮、一个轨道和一个滑块
	 * @author ｋａｋａ
	 */
	public class ScrollBar extends MovieClipComponent
	{
		
		private var silder_vertical:ScrollBarSlider = new ScrollBarSlider(ScrollBarSlider.DIRECTION_VERTICAL);
		private var silder_horizontal:ScrollBarSlider = new ScrollBarSlider(ScrollBarSlider.DIRECTION_HORIZONTAL);
		
		private var _scrollVertical:Boolean;
		private var _scrollHorizontal:Boolean;
		
		private var maskSP:Shape;
		private var bgSP:Shape;
		private var _target:DisplayObject;
		private var targetContainer:Sprite;
		
		/**
		 * 显示区域宽
		 */
		private var _viewWidth:Number = 0;
		
		/**
		 * 显示区域高
		 */
		private var _viewHeight:Number = 0;
		
		public function ScrollBar():void
		{
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			if (movieClip.getChildByName("scrollBar_vertical") != null)
			{
				_scrollVertical = true;
				silder_vertical.bind(movieClip.getChildByName("scrollBar_vertical"));
				this.addEventListener(MouseEvent.MOUSE_WHEEL, silder_vertical.mouseWheelHandler);
			}
			
			if (movieClip.getChildByName("scrollBar_horizontal") != null)
			{
				_scrollHorizontal = true;
				silder_horizontal.bind(movieClip.getChildByName("scrollBar_horizontal"));
				this.addEventListener(MouseEvent.MOUSE_WHEEL, silder_horizontal.mouseWheelHandler);
			}
			
			targetContainer = new Sprite();
			addChild(targetContainer);
			addChild(silder_vertical);
			addChild(silder_horizontal);
			
			maskSP = new Shape();
			addChild(maskSP);
			
			bgSP = new Shape();
			addChildAt(bgSP, 0);
			
			targetContainer.mask = maskSP;
			
			if (_scrollVertical)
			{
				this.contentWidth = silder_vertical.x + silder_vertical.contentWidth;
			}
			else
			{
				this.contentWidth = silder_horizontal.contentWidth;
			}
			
			if (_scrollHorizontal)
			{
				this.contentHeight = silder_horizontal.y + silder_horizontal.contentHeight;
			}
			else
			{
				this.contentHeight = silder_vertical.contentHeight;
			}
			
			silder_vertical.addEventListener(UIComponentEvent.CHANGE, silder_verticalChangeHandler);
			silder_horizontal.addEventListener(UIComponentEvent.CHANGE, silder_horizontalChangeHandler);
			
			targetContainer.addEventListener(FocusEvent.FOCUS_IN, targetFocusInHandler);
			
		}
		
		private function targetFocusInHandler(evt:FocusEvent):void
		{
			
			if (_scrollVertical)
			{
				UIStage.focus = silder_vertical;
				return;
			}
			
			UIStage.focus = silder_horizontal;
			
		}
		
		public function show():void
		{
			
			silder_horizontal.visible = true;
			silder_vertical.visible = true;
			
		}
		
		public function hide():void
		{
			
			silder_horizontal.visible = false;
			silder_vertical.visible = false;
			
		}
		
		private function silder_verticalChangeHandler(evt:UIComponentEvent):void
		{
			
			targetContainer.y = -Number(evt.data);
			
		}
		
		private function silder_horizontalChangeHandler(evt:UIComponentEvent):void
		{
			
			targetContainer.x = -Number(evt.data);
			
		}
		
		/**
		 * 获取此滚动条是否进行水平滚动
		 */
		public function get scrollHorizontal():Boolean 
		{
			return _scrollHorizontal;
		}
		
		/**
		 * 获取此滚动条是否进行垂直滚动
		 */
		public function get scrollVertical():Boolean 
		{
			return _scrollVertical;
		}
		
		public function get verticalPosition():Number 
		{
			return silder_vertical.position;
		}
		
		public function set verticalPosition(value:Number):void 
		{
			silder_vertical.position = value;
		}
		
		public function get verticalPositionPec():Number 
		{
			return silder_vertical.positionPec;
		}
		
		public function set verticalPositionPec(value:Number):void 
		{
			silder_vertical.positionPec = value;
		}
		
		public function get horizontalPosition():Number 
		{
			return silder_horizontal.position;
		}
		
		public function set horizontalPosition(value:Number):void 
		{
			silder_horizontal.position = value;
		}
		
		public function get horizontalPositionPec():Number 
		{
			return silder_horizontal.positionPec;
		}
		
		public function set horizontalPositionPec(value:Number):void 
		{
			silder_horizontal.positionPec = value;
		}
		
		/**
		 * 获取或设置此滚动条组件滚动的目标
		 */
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void 
		{
			
			if (_target)
			{
				_target.removeEventListener(Event.RESIZE, targetChangeHandler);
				targetContainer.removeChild(_target);
			}
			
			_target = value;
			
			targetContainer.addChild(_target);
			_target.addEventListener(Event.RESIZE, targetChangeHandler);
			
			resizeTarget();
			
		}
		
		override public function set contentHeight(value:Number):void 
		{
			
			super.contentHeight = value;
			
			_viewHeight = _contentHeight - silder_horizontal.contentHeight;
			
			if (_scrollVertical) silder_vertical.contentHeight = _viewHeight;
			
			silder_horizontal.y = _viewHeight;
			drawMask();
			resizeTarget();
			
		}
		
		override public function set contentWidth(value:Number):void 
		{
			
			super.contentWidth = value;
			
			_viewWidth = _contentWidth - silder_vertical.contentWidth;
			
			if (_scrollHorizontal) silder_horizontal.contentWidth = _viewWidth;
			
			silder_vertical.x = _viewWidth;
			drawMask();
			resizeTarget();
			
		}
		
		public function get verticalPageScrollSize():Number 
		{
			return silder_vertical.pageScrollSize;
		}
		
		public function set verticalPageScrollSize(value:Number):void 
		{
			silder_vertical.pageScrollSize = value;
		}
		
		public function get verticalLineScrollSize():Number 
		{
			return silder_vertical.lineScrollSize;
		}
		
		public function set verticalLineScrollSize(value:Number):void 
		{
			silder_vertical.lineScrollSize = value;
		}
		
		public function get horizontalPageScrollSize():Number 
		{
			return silder_horizontal.pageScrollSize;
		}
		
		public function set horizontalPageScrollSize(value:Number):void 
		{
			silder_horizontal.pageScrollSize = value;
		}
		
		public function get horizontalLineScrollSize():Number 
		{
			return silder_horizontal.lineScrollSize;
		}
		
		public function set horizontalLineScrollSize(value:Number):void 
		{
			silder_horizontal.lineScrollSize = value;
		}
		
		/**
		 * 获取或设置显示区域的宽度
		 */
		public function get viewWidth():Number 
		{
			return _viewWidth;
		}
		
		public function set viewWidth(value:Number):void 
		{
			//_viewWidth = value;
			this.contentWidth = value + silder_vertical.contentWidth;
		}
		
		/**
		 * 获取或设置显示区域的高度
		 */
		public function get viewHeight():Number 
		{
			return _viewHeight;
		}
		
		public function set viewHeight(value:Number):void 
		{
			//_viewHeight = value;
			this.contentHeight = value + silder_horizontal.contentHeight;
		}
		
		/**
		 * 根据滚动目标新的尺寸重新计算布局
		 */
		public function resizeTarget():void
		{
			
			if (_target == null) return;
			
			_target.x = 0;
			_target.y = 0;
			
			//增加对内部坐标不在原点的显示对象的计算兼容性
			var rect:Rectangle = _target.getBounds(_target);
			
			//_target.x = -rect.x;
			//_target.y = -rect.y;
			
			silder_horizontal.pageSize = _viewWidth;
			//silder_horizontal.maxScrollPosition = target.width - _viewWidth;
			silder_horizontal.maxScrollPosition = rect.x + rect.width - _viewWidth;
			silder_vertical.pageSize = _viewHeight;
			//silder_vertical.maxScrollPosition = target.height - _viewHeight;
			silder_vertical.maxScrollPosition = rect.y + rect.height - _viewHeight;
			
		}
		
		/**
		 * 滚动目标大小变化
		 * @param	evt
		 */
		private function targetChangeHandler(evt:Event = null):void
		{
			
			resizeTarget();
			
		}
		
		private function drawMask():void
		{
			
			var gr:Graphics = maskSP.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0);
			gr.drawRect(0, 0, _viewWidth, _viewHeight);
			gr.endFill();
			
			gr = bgSP.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0, 0);
			gr.drawRect(0, 0, _viewWidth, _viewHeight);
			gr.endFill();
			
		}
		
	}

}