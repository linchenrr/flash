package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 通过使用 Slider 组件，用户可以在滑块轨道的端点之间移动滑块来选择值
	 * @author ｋａｋａ
	 */
	public class ScrollBarSlider extends MovieClipComponent
	{
		
		/**
		 * 滑块最小尺寸 (防止内容过长时滑块被缩到过小)
		 */
		static public var sliderMinSize:int = 25;
		
		/**
		 * 将 Slider 组件放在水平轴上
		 */
		static public const DIRECTION_HORIZONTAL:String = "DIRECTION_HORIZONTAL";
		
		/**
		 * 将 Slider 组件放在垂直轴上
		 */
		static public const DIRECTION_VERTICAL:String = "DIRECTION_VERTICAL";
		
		/**
		 * 下箭头或右箭头
		 */
		protected var btn_go:Button = new Button();
		
		/**
		 * 上箭头或左箭头
		 */
		protected var btn_back:Button = new Button();
		
		/**
		 * 滑块
		 */
		protected var btn_slider:Button = new Button();
		
		/**
		 * 轨道
		 */
		protected var btn_track:Button = new Button();
		
		/**
		 * 当为水平方向时，此值为"x"
		 * 当为垂直方向时，此值为"y"
		 */
		protected var posName:String;
		
		/**
		 * 当为水平方向时，此值为"contentWidth"
		 * 当为垂直方向时，此值为"contentHeight"
		 */
		protected var sizeName:String;
		
		/**
		 * 当为水平方向时，此值为contentWidth的值
		 * 当为垂直方向时，此值为contentHeight的值
		 */
		protected var sizeValue:Number;
		
		/**
		 * 当为水平方向时，此值为"mouseX"
		 * 当为垂直方向时，此值为"mouseY"
		 */
		protected var mousePosName:String;
		
		private var _direction:String;
		
		private var _position:Number = 0;
		
		
		/**
		 * 获取或设置一个值，该值表示按下滚动条轨道时页面滚动的增量
		 */
		public var pageScrollSize:Number = 0;
		
		/**
		 * 获取或设置一个值，该值表示按下滚动条箭头时页面滚动的增量
		 */
		public var lineScrollSize:Number = 0;
		
		/**
		 * 获取或设置表示最高滚动位置的数字
		 */
		private var _maxScrollPosition:Number = 0;
		
		/**
		 * 获取或设置页的尺寸
		 */
		private var _pageSize:Number = 0;
		
		
		
		//==================
		private var keepMoveSize:Number;
		private var timer_startKeepMove:Timer = new Timer(300, 1);
		private var timer_keepMove:Timer = new Timer(60);
		
		private var isPageMove:Boolean;
		
		public function ScrollBarSlider(direction:String = DIRECTION_HORIZONTAL):void
		{
			
			this.direction = direction;
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			var width:Number = movieClip.width;
			var height:Number = movieClip.height;
			
			//var mc_go:MovieClip = movieClip["btn_go"] || new MovieClip();
			//var mc_back:MovieClip = movieClip["btn_back"] || new MovieClip();
			
			var mc_go:MovieClip = movieClip["btn_go"];
			var mc_back:MovieClip = movieClip["btn_back"];
			
			btn_go.bind(mc_go);
			btn_back.bind(mc_back);
			btn_slider.bind(movieClip["btn_slider"]);
			btn_track.bind(movieClip["btn_track"]);
			
			
			addChild(btn_track);
			addChild(btn_go);
			addChild(btn_back);
			addChild(btn_slider);
			
			this.contentWidth = width;
			this.contentHeight = height;
			
		}
		
		/**
		 * 配置侦听器
		 */
		override protected function active():void
		{
			
			btn_go.addEventListener(MouseEvent.MOUSE_DOWN, btn_goMouseDownHandler);
			btn_back.addEventListener(MouseEvent.MOUSE_DOWN, btn_backMouseDownHandler);
			btn_slider.addEventListener(MouseEvent.MOUSE_DOWN, btn_sliderMouseDownHandler);
			btn_track.addEventListener(MouseEvent.MOUSE_DOWN, btn_trackMouseDownHandler);
			
			timer_startKeepMove.addEventListener(TimerEvent.TIMER_COMPLETE, timer_startKeepMoveHandler);
			timer_keepMove.addEventListener(TimerEvent.TIMER, timer_keepMoveHandler);
			
			//this.addEventListener(FocusEvent.FOCUS_IN, thisFocusInHandler);
			//this.addEventListener(FocusEvent.FOCUS_OUT, thisFocusOutHandler);
			//this.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
		}
		
		//private function thisFocusInHandler(evt:FocusEvent):void
		//{
			//
			//UIStage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//
		//}
		//
		//private function thisFocusOutHandler(evt:FocusEvent):void
		//{
			//
			//UIStage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//
		//}
		
		public function mouseWheelHandler(evt:MouseEvent):void
		{
			
			position += -evt.delta * lineScrollSize;
			
		}
		
		/**
		 * 移除侦听器
		 */
		override protected function backStage():void
		{
			
			
			
		}
		
		/**
		 * 设置滑块的方向。 可接受的值为 Slider.HORIZONTAL 和 Slider.VERTICAL
		 * 默认值为 Slider.HORIZONTAL
		 */
		public function get direction():String 
		{
			return _direction;
		}
		
		public function set direction(value:String):void 
		{
			
			if (value == _direction) return;
			_direction = value;
			
			if (_direction == DIRECTION_HORIZONTAL)
			{
				
				posName = "x";
				sizeName = "contentWidth";
				mousePosName = "mouseX";
				
			}
			else
			if (_direction == DIRECTION_VERTICAL)
			{
				
				posName = "y";
				sizeName = "contentHeight";
				mousePosName = "mouseY";
				
			}
			else
			{
				throw new Error("无效的方向值", _direction);
			}
			
		}
		
		
		override public function set contentWidth(value:Number):void
		{
			
			super.contentWidth = value;
			
			
			if (_direction == DIRECTION_HORIZONTAL)
			{
				
				movieClip.width = value;
				
				sizeValue = value;
				updateLayout();
				
			}
			
		}
		
		override public function set contentHeight(value:Number):void
		{
			
			super.contentHeight = value;
			
			
			if (_direction == DIRECTION_VERTICAL)
			{
				
				movieClip.height = value;
				
				sizeValue = value;
				updateLayout();
				
			}
			
		}
		
		/**
		 * 获取或设置当前滚动位置
		 */
		public function get position():Number 
		{
			return _position;
		}
		
		public function set position(value:Number):void 
		{
			
			_position = value;
			
			if (_position < 0) _position = 0;
			else if (_position > maxScrollPosition)_position = maxScrollPosition;
			
			btn_slider[posName] = btn_track[posName] + (btn_track[sizeName] - btn_slider[sizeName]) * (_position / _maxScrollPosition);
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, _position));
			
		}
		
		public function set positionPec(value:Number):void
		{
			
			this.position = _maxScrollPosition * value;
			
		}
		
		/**
		 * 获取或设置当前滚动位置的百分比
		 */
		public function get positionPec():Number
		{
			
			return _position / _maxScrollPosition;
			
		}
		
		public function get pageSize():Number 
		{
			return _pageSize;
		}
		
		public function set pageSize(value:Number):void 
		{
			_pageSize = value;
			if (_pageSize < 0)_pageSize = 0;
			
			lineScrollSize = _pageSize / 10;
			pageScrollSize = _pageSize;
			
			updateLayout();
		}
		
		public function get maxScrollPosition():Number 
		{
			return _maxScrollPosition;
		}
		
		public function set maxScrollPosition(value:Number):void 
		{
			_maxScrollPosition = value;
			if (_maxScrollPosition < 0)_maxScrollPosition = 0;
			updateLayout();
		}
		
		
		/**
		 * 更新布局
		 * @param	value
		 */
		private function updateLayout():void
		{
			
			btn_back[posName] = 0;
			btn_track[posName] = btn_back[sizeName];
			btn_track[sizeName] = sizeValue - btn_back[sizeName] - btn_go[sizeName];
			btn_go[posName] = sizeValue - btn_go[sizeName];
			
			if (maxScrollPosition <= 0)
			{
				
				btn_slider.visible = false;
				this.mouseChildren = false;
				
			}
			else
			{
				btn_slider.visible = true;
				this.mouseChildren = true;
				btn_slider[sizeName] = (pageSize / (maxScrollPosition + pageSize)) * btn_track[sizeName];
				if (btn_slider[sizeName] < sliderMinSize)
				btn_slider[sizeName] = sliderMinSize;
				
			}
			
			this.position = _position;
			
		}
		
		
		//===========鼠标侦听器================
		private function btn_goMouseDownHandler(evt:MouseEvent):void
		{
			
			keepMoveSize = lineScrollSize;
			
			timer_keepMoveHandler();
			
			btn_go.addEventListener(MouseEvent.ROLL_OUT, stopMove);
			UIStage.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			
			isPageMove = false;
			timer_startKeepMove.start();
			
		}
		
		private function btn_backMouseDownHandler(evt:MouseEvent):void
		{
			
			keepMoveSize = -lineScrollSize;
			
			timer_keepMoveHandler();
			
			btn_back.addEventListener(MouseEvent.ROLL_OUT, stopMove);
			UIStage.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			
			isPageMove = false;
			timer_startKeepMove.start();
			
		}
		
		private function btn_sliderMouseDownHandler(evt:MouseEvent):void
		{
			
			lastPos = UIStage[mousePosName];
			
			UIStage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			UIStage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			
		}
		
		
		
		private function btn_trackMouseDownHandler(evt:MouseEvent):void
		{
			
			btn_track.addEventListener(MouseEvent.ROLL_OUT, stopMove);
			btn_track.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			
			keepMoveSize = this[mousePosName] > btn_slider[posName] ? pageScrollSize : -pageScrollSize;
			//keepMoveSize = this[mousePosName] > btn_slider[posName] ? lineScrollSize : -lineScrollSize;
			
			timer_startKeepMove.start();
			
			isPageMove = true;
			timer_keepMoveHandler();
			
		}
		
		private function timer_startKeepMoveHandler(evt:TimerEvent):void
		{
			
			timer_keepMove.start();
			
		}
		
		private function timer_keepMoveHandler(evt:TimerEvent = null):void
		{
			
			position += keepMoveSize;
			
			if (isPageMove)
			{
				if (btn_slider[posName] <= this[mousePosName]&&btn_slider[posName]+btn_slider[sizeName]>= this[mousePosName])
				{
					stopMove();
				}
			}
			
		}
		
		private var lastPos:Number;
		
		private function stageMouseMoveHandler(evt:MouseEvent):void
		{
			
			///如果拖动时鼠标在轨道区域之外移动则忽略
			if (this[mousePosName] < btn_track[posName])
			{
				position = 0;
				return;
			}
			else
			if (this[mousePosName] > btn_track[posName] + btn_track[sizeName])
			{
				position = maxScrollPosition;
				return;
			}
			
			
			var curPos:Number = UIStage[mousePosName];
			
			btn_slider[posName] += (curPos - lastPos);
			
			//position = ((btn_slider[posName] - btn_track[posName]) / (btn_track[sizeName] - btn_slider[sizeName])) * _maxScrollPosition;
			positionPec = ((btn_slider[posName] - btn_track[posName]) / (btn_track[sizeName] - btn_slider[sizeName]));
			
			lastPos = curPos;
			
			//evt.updateAfterEvent();
			
		}
		
		private function stopMove(evt:MouseEvent = null):void
		{
			
			timer_startKeepMove.stop();
			timer_keepMove.stop();
			
			btn_track.removeEventListener(MouseEvent.ROLL_OUT, stopMove);
			btn_track.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
			btn_go.removeEventListener(MouseEvent.ROLL_OUT, stopMove);
			btn_back.removeEventListener(MouseEvent.ROLL_OUT, stopMove);
			
			UIStage.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
			
		}
		
		private function stageMouseUpHandler(evt:MouseEvent):void
		{
			
			UIStage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			UIStage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			
		}
		
	}

}