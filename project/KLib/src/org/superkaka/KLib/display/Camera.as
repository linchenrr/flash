package org.superkaka.KLib.display 
{
	//import com.greensock.easing.Cubic;
	//import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 镜头控制
	 * @author ｋａｋａ
	 */
	public class Camera extends EventDispatcher
	{
		
		/**
		 * 镜头移动
		 */
		static public const Move:String = "Move";
		
		/**
		 * 镜头尺寸变化
		 */
		static public const SizeChange:String = "SizeChange";
		
		/**
		 * 当前移动控制优先级
		 */
		private var _priority:int;
		
		/**
		 * 当前锁定优先级
		 */
		private var _lockPriority:int;
		
		/**
		 * 当前控制目标
		 */
		private var _target:DisplayObject;
		
		/**
		 * 镜头宽
		 */
		private var _width:Number;
		
		/**
		 * 镜头高
		 */
		private var _height:Number;
		
		/**
		 * 移动限定范围
		 */
		private var _limitRectangle:Rectangle;
		
		/**
		 * 视点实际移动范围
		 */
		private var _viewRectangle:Rectangle;
		
		/**
		 * 当前视点覆盖区域
		 */
		private var _curViewRectangle:Rectangle;
		
		/**
		 * 当前缓动移动目标
		 */
		private var targetPosition:Point;
		
		/**
		 * 计算后的合理移动坐标
		 */
		private var reasonablePosition:Point;
		
		
		public function Camera():void
		{
			
			_width = 0;
			_height = 0;
			_limitRectangle = new Rectangle();
			_viewRectangle = new Rectangle();
			_curViewRectangle = new Rectangle();
			
			targetPosition = new Point();
			reasonablePosition = new Point();
			
		}
		
		/**
		 * 移动镜头
		 * @param	x
		 * @param	y
		 * @param	priority								移动控制优先级
		 * @param	onCompleteFunction				移动完成回调
		 * @param	onCompleteParam				移动完成回调参数
		 * @param	duration								移动过程持续时间
		 * @param	easeFunction						缓动函数
		 * @return
		 */
		//public function moveTo(x:Number, y:Number, priority:int = 0, duration:Number = 0.75, easeFunction:Function = null):Boolean
		//{
			//
			//if (priority < this._priority) return false;
			//
			//this._priority = priority;
			//
			//var reasonablePosition:Point = getRealMovePosition(x, y);
			//
			//TweenLite.killTweensOf(_target);
			//
			//如果不传缓动函数则制定默认缓动函数
			//if (easeFunction == null) easeFunction = Cubic.easeOut;
			//
			//TweenLite.to(_target, duration, { x:reasonablePosition.x, y:reasonablePosition.y, ease:easeFunction, onComplete:onComplete } );
			//
			//return true;
			//
		//} 
		
		//private function onComplete():void
		//{
			//
			//this._priority = 0;
			//
		//}
		
		
		public function moveTo(x:Number, y:Number, priority:int = 0):Boolean
		{
			
			if (priority < this._priority) return false;
			
			this._priority = priority;
			
			updateMovePosition(x, y);
			
			targetPosition.x = reasonablePosition.x;
			targetPosition.y = reasonablePosition.y;
			
			_target.addEventListener(Event.ENTER_FRAME, movingHandler);
			
			return true;
			
		}
		
		private function movingHandler(evt:Event):void
		{
			
			var dx:Number = targetPosition.x - _target.x;
			var dy:Number = targetPosition.y - _target.y;
			
			var disX:Number = dx > 0? dx : -dx;
			var disY:Number = dy > 0? dy : -dy;
			
			if (disX <= 1 && disY <= 1)
			{
				
				moveTarget(targetPosition.x, targetPosition.y);
				
				//移动完成
				stopMoving();
				
			}
			else
			{
				
				moveTarget(_target.x + dx * 0.2, _target.y + dy * 0.2);
				
			}
			
		}
		
		/**
		 * 停止移动
		 */
		private function stopMoving():void
		{
			
			_target.removeEventListener(Event.ENTER_FRAME, movingHandler);
			this._priority = 0;
			
		}
		
		/**
		 * 瞬间移动镜头
		 * @param	x
		 * @param	y
		 * @param	priority				移动控制优先级
		 * @return
		 */
		public function teleportTo(x:Number, y:Number, priority:int = 0):Boolean
		{
			
			if (priority < this._priority) return false;
			
			stopMoving();
			
			updateMovePosition(x, y);
			
			moveTarget(reasonablePosition.x, reasonablePosition.y);
			
			return true;
			
		}
		
		private function moveTarget(x:Number, y:Number):void
		{
			
			_target.x = x;
			_target.y = y;
			
			_curViewRectangle.x = -_target.x;
			_curViewRectangle.y = -_target.y;
			
			dispatchEvent(new Event(Move));
			
		}
		
		/**
		 * 更新实际移动坐标
		 * @param	x
		 * @param	y
		 */
		private function updateMovePosition(x:Number, y:Number):void
		{
			
			x -= _width / 2;
			y -= _height / 2;
			
			if (x < _viewRectangle.x) x = _viewRectangle.x;
			else if (x > _viewRectangle.right) x = _viewRectangle.right;
			
			if (y < _viewRectangle.y) y = _viewRectangle.y;
			else if (y > _viewRectangle.bottom) y = _viewRectangle.bottom;
			
			reasonablePosition.x = -x;
			reasonablePosition.y = -y;
			
		}
		
		/**
		 * 更新视点实际移动范围
		 */
		private function updateRect():void
		{
			
			_curViewRectangle.width = _width;
			_curViewRectangle.height = _height;
			
			_viewRectangle.x = _limitRectangle.x;
			_viewRectangle.y = _limitRectangle.x;
			_viewRectangle.right = _limitRectangle.right - _width;
			_viewRectangle.bottom = _limitRectangle.bottom - _height;
			
			if (_viewRectangle.x > _viewRectangle.right)_viewRectangle.width = 0;
			if (_viewRectangle.y > _viewRectangle.bottom)_viewRectangle.height = 0;
			
		}
		
		/**
		 * 指定的控制目标
		 */
		public function set target(value:DisplayObject):void
		{
			
			this._target = value;
			
		}
		
		/**
		 * 指定的控制目标
		 */
		public function get target():DisplayObject
		{
			
			return this._target;
			
		}
		
		/**
		 * 设置镜头尺寸
		 */
		public function setSize(width:Number, height:Number):void
		{
			
			_width = width;
			_height = height;
			updateRect();
			
			dispatchEvent(new Event(SizeChange));
			
		}
		
		
		/**
		 * 镜头移动限定范围
		 */
		public function get limitRectangle():Rectangle 
		{
			return _limitRectangle;
		}
		
		/**
		 * 镜头移动限定范围
		 */
		public function set limitRectangle(value:Rectangle):void 
		{
			_limitRectangle = value.clone();
			updateRect();
		}
		
		/**
		 * 获取当前视点覆盖区域
		 * @return
		 */
		public function getCurViewRectangle():Rectangle
		{
			
			return _curViewRectangle.clone();
			
		}
		
		
	}

}